import 'dart:convert';
import 'dart:typed_data';
import 'package:basic_utils/basic_utils.dart';
import 'package:cryptography/cryptography.dart';

class Auth {
  final String _privateKeyPem;
  final String _keyId;

  Auth(this._privateKeyPem, this._keyId);

  String get keyId => _keyId;

  Future<String> makeSignature(String method, String relativeUrl) async {
    // 1. Prepare data to sign
    final rawSign = "$method || $_keyId || $relativeUrl";
    final data = utf8.encode(rawSign);

    // 2. Parse Private Key
    // Try basic_utils for RSA/EC first (Synchronous and easy for PEM)
    RSAPrivateKey? rsaKey;
    ECPrivateKey? ecKey;

    try {
      rsaKey = CryptoUtils.rsaPrivateKeyFromPem(_privateKeyPem);
    } catch (e) {
      // Not RSA
    }

    if (rsaKey == null) {
      try {
        ecKey = CryptoUtils.ecPrivateKeyFromPem(_privateKeyPem);
      } catch (e) {
        // Not EC either
      }
    }

    Uint8List signature;

    if (rsaKey != null) {
      // RSA-SHA256
      signature = CryptoUtils.rsaSign(rsaKey, Uint8List.fromList(data));
    } else if (ecKey != null) {
      // EC-SHA256 (ECDSA)
      final sig = CryptoUtils.ecSign(ecKey, Uint8List.fromList(data));
      signature = Uint8List.fromList([
         ..._bigIntToBytes(sig.r), 
         ..._bigIntToBytes(sig.s)
      ]);
    } else {
        // Try Ed25519 using 'cryptography' package
        // We need to extract the seed from the PEM/Base64.
        // Assuming the structure is PKCS8 Ed25519 as identified before.
        final cleanPem = _privateKeyPem
            .replaceAll("-----BEGIN PRIVATE KEY-----", "")
            .replaceAll("-----END PRIVATE KEY-----", "")
            .replaceAll("\n", "")
            .replaceAll("\r", "")
            .trim();
        
        final bytes = base64Decode(cleanPem);
        
        // Simple heuristic for Ed25519 PKCS8 (48 bytes usually: 16 prefix + 32 key)
        if (bytes.length > 32) {
             final seed = bytes.sublist(bytes.length - 32);
             final algorithm = Ed25519();
             final keyPair = await algorithm.newKeyPairFromSeed(seed);
             final sig = await algorithm.sign(
               data,
               keyPair: keyPair,
             );
             signature = Uint8List.fromList(sig.bytes);
        } else {
            throw Exception("Unsupported private key format");
        }
    }

    return base64Encode(signature);
  }

  Uint8List _bigIntToBytes(BigInt number) {
    var hex = number.toRadixString(16);
    if (hex.length % 2 != 0) hex = '0$hex';
    final len = hex.length ~/ 2;
    final bytes = Uint8List(len);
    for (var i = 0; i < len; i++) {
        bytes[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return bytes;
  }
}
