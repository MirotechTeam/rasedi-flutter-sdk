import 'dart:convert';
import 'package:rasedi_flutter_sdk/rasedi_flutter_sdk.dart';

Future<void> main() async {
  const secretKey = "live_laisxVjnNnoY1w5mwWP6YwzfPg_zmu2BnWnJH1uCOzOGcAflAYShdjVPuDAG10DLSEpTOlsOopiyTJHJjO4fbqqU";
  const privateKey = """-----BEGIN PRIVATE KEY-----
MC4CAQAwBQYDK2VwBCIEID2nK2pCcGSbtS+U9jc2SCYxHWOo1eA4IR97bdif4+rx
-----END PRIVATE KEY-----""";

  final client = RasediClient(privateKey, secretKey);
  print("INSTALLED_OK RasediClient");

  // Create Payment
  final createPayload = CreatePaymentPayload(
    amount: "10200",
    title: "Test Payment",
    description: "This is a test payment",
    gateways: [Gateway.CREDIT_CARD],
    redirectUrl: "https://google.com",
    collectFeeFromCustomer: true,
    collectCustomerEmail: true,
    collectCustomerPhoneNumber: false,
    callbackUrl: "https://google.com",
  );

  String? referenceCode;

  try {
    final createRes = await client.createPayment(createPayload);
    print("PAYMENT_CREATION_RESPONSE: ${jsonEncode(createRes.body.referenceCode)}");
    referenceCode = createRes.body.referenceCode;
  } catch (e) {
    print("PAYMENT_CREATION_ERROR: $e");
    // Fallback for testing logic if creation implementation isn't perfect yet or net error
    referenceCode = "0b0a8bce-bf3c-4fc4-993e-6179d95e9ece"; 
  }

  // Get Payment
  if (referenceCode != null) {
    try {
      final getRes = await client.getPaymentByReference(referenceCode);
      print("GET_PAYMENT_RESPONSE: ${getRes.body.status}");
    } catch (e) {
      print("GET_PAYMENT_ERROR: $e");
    }
  }

  // Cancel Payment
  if (referenceCode != null) {
    try {
      final cancelRes = await client.cancelPayment(referenceCode);
      print("CANCEL_PAYMENT_RESPONSE: ${cancelRes.body.status}");
    } catch (e) {
      print("CANCEL_PAYMENT_ERROR: $e");
    }
  }

  // Get After Cancel
  if (referenceCode != null) {
    try {
      final getAfterCancel = await client.getPaymentByReference(referenceCode);
      print("GET_AFTER_CANCEL: ${getAfterCancel.body.status}");
    } catch (e) {
      print("GET_AFTER_CANCEL_ERROR: $e");
    }
  }
}
