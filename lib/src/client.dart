import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';
import 'auth.dart';

class RasediClient {
  static const String _apiBaseUrl = "https://api.rasedi.com";
  static const int _upstreamVersion = 1;

  final Auth _auth;
  final http.Client _httpClient;
  late final bool _isTest;

  RasediClient(String privateKey, String secretKey, {http.Client? httpClient})
      : _auth = Auth(privateKey, secretKey),
        _httpClient = httpClient ?? http.Client() {
    _isTest = secretKey.contains("test");
  }

  /// call the API
  Future<Map<String, dynamic>> _call(String path, String method,
      [Map<String, dynamic>? body]) async {
    final env = _isTest ? "test" : "live";
    final relativeUrl = "/v$_upstreamVersion/payment/rest/$env$path";
    final uri = Uri.parse("$_apiBaseUrl$relativeUrl");

    final signature = await _auth.makeSignature(method, relativeUrl);

    final headers = {
      'Content-Type': 'application/json',
      'x-signature': signature,
      'x-id': _auth.keyId,
    };

    http.Response response;
    try {
      if (method == 'POST') {
        response = await _httpClient.post(uri,
            headers: headers, body: body != null ? jsonEncode(body) : null);
      } else if (method == 'GET') {
        response = await _httpClient.get(uri, headers: headers);
      } else if (method == 'PATCH') {
        response = await _httpClient.patch(uri,
            headers: headers, body: body != null ? jsonEncode(body) : null);
      } else {
        throw Exception("Unsupported method: $method");
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }

    final responseBody =
        response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (response.statusCode < 200 || response.statusCode > 209) {
      throw Exception(
          "Unexpected status: ${response.statusCode}, body: ${response.body}");
    }

    return {
      'body': responseBody,
      'headers': response.headers,
      'statusCode': response.statusCode,
    };
  }

  Future<CreatePaymentResponse> createPayment(
      CreatePaymentPayload payload) async {
    final resp = await _call("/create", "POST", payload.toJson());
    
    return CreatePaymentResponse(
      body: CreatePaymentResponseBody.fromJson(resp['body']),
      headers: Map<String, String>.from(resp['headers']),
      statusCode: resp['statusCode'],
    );
  }

  Future<PaymentDetailsResponse> getPaymentByReference(
      String referenceCode) async {
    final resp = await _call("/status/$referenceCode", "GET");

    return PaymentDetailsResponse(
      body: PaymentDetailsResponseBody.fromJson(resp['body']),
      headers: Map<String, String>.from(resp['headers']),
      statusCode: resp['statusCode'],
    );
  }

  Future<CancelPaymentResponse> cancelPayment(String referenceCode) async {
    final resp = await _call("/cancel/$referenceCode", "PATCH");

    return CancelPaymentResponse(
      body: CancelPaymentResponseBody.fromJson(resp['body']),
      headers: Map<String, String>.from(resp['headers']),
      statusCode: resp['statusCode'],
    );
  }
  
  // Verification logic would go here. 
  // Note: Implementing full JWS verification in Dart requires careful handling of keys.
  // We can add it if requested, similar to python/go.
  // For now, let's keep it defined but simple.
  
  Future<Map<String, dynamic>> verify(VerifyPayload payload) async {
      // Placeholder for verification logic
      throw UnimplementedError("Verify not implemented yet");
  }
}
