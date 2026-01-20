import 'package:flutter/material.dart';
import 'package:flutter_demo/keys/keys.dart';
import 'package:rasedi_flutter_sdk/rasedi_flutter_sdk.dart';

/// Entry point of the application.
void main() {
  runApp(const RasediTestApp());
}

/// The root widget of the application.
class RasediTestApp extends StatelessWidget {
  const RasediTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RasediTestScreen(),
    );
  }
}

/// Main screen of the application that provides UI to interact with Rasedi SDK.
///
/// Wraps the state logic in [_RasediTestScreenState].
class RasediTestScreen extends StatefulWidget {
  const RasediTestScreen({super.key});

  @override
  State<RasediTestScreen> createState() => _RasediTestScreenState();
}

/// State class for [RasediTestScreen].
///
/// Handles initialization of [RasediClient] and manages payment operations.
class _RasediTestScreenState extends State<RasediTestScreen> {
  /// Instance of the Rasedi SDK client.
  late final RasediClient client;

  /// Stores the reference code of the created payment.
  String? referenceCode;

  /// Stores logs of operations and responses.
  String log = "";

  final amountCtrl = TextEditingController(text: "10200");
  final titleCtrl = TextEditingController(text: "Test Payment");
  final descCtrl = TextEditingController(text: "This is a test payment");

  @override
  void initState() {
    super.initState();
    // Initialize the Rasedi client with your private and secret keys.
    client = RasediClient(privateKey, secretKey);
    _appendLog("RasediClient initialized");
  }

  /// Appends a new message to the log view.
  void _appendLog(String message) {
    setState(() {
      log = "$message\n\n$log";
    });
  }

  /// Creates a new payment session.
  ///
  /// Uses the data from text controllers to form a [CreatePaymentPayload].
  /// On success, updates [referenceCode] and logs the result.
  Future<void> createPayment() async {
    try {
      final payload = CreatePaymentPayload(
        amount: amountCtrl.text,
        title: titleCtrl.text,
        description: descCtrl.text,
        gateways: [Gateway.CREDIT_CARD],
        redirectUrl: "https://google.com",
        callbackUrl: "https://google.com",
        collectFeeFromCustomer: true,
        collectCustomerEmail: true,
        collectCustomerPhoneNumber: false,
      );

      final res = await client.createPayment(payload);
      referenceCode = res.body.referenceCode;

      _appendLog("PAYMENT CREATED\nReference: ${res.body.referenceCode}");
    } catch (e) {
      referenceCode = '0b0a8bce-bf3c-4fc4-993e-6179d95e9ece';
      _appendLog("CREATE PAYMENT ERROR: $e");
    }
  }

  /// Retrieves the status of the current payment.
  ///
  /// Uses [referenceCode] to fetch payment details from the SDK.
  Future<void> getPayment() async {
    if (referenceCode == null) {
      _appendLog("No referenceCode available");
      return;
    }

    try {
      final PaymentDetailsResponse res = await client.getPaymentByReference(
        referenceCode!,
      );

      final Map<String, dynamic> json = {
        "referenceCode": res.body.referenceCode,
        "status": res.body.status,
        "amount": res.body.amount,
        "redirectUrl": res.body.redirectUrl,
      };
      _appendLog("GET PAYMENT\nStatus: ${res.body.status}");
      _appendLog("GET PAYMENT\nDetails: $json");
    } catch (e) {
      _appendLog("GET PAYMENT ERROR: $e");
    }
  }

  /// Cancels the current payment session.
  ///
  /// Uses [referenceCode] to cancel the payment.
  Future<void> cancelPayment() async {
    if (referenceCode == null) {
      _appendLog("No referenceCode available");
      return;
    }

    try {
      final res = await client.cancelPayment(referenceCode!);
      _appendLog("CANCEL PAYMENT\nStatus: ${res.body.status}");
    } catch (e) {
      _appendLog("CANCEL PAYMENT ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rasedi SDK")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: amountCtrl,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: createPayment,
                    child: const Text("Create Payment"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: getPayment,
                    child: const Text("Get Payment"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: cancelPayment,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                "Cancel Payment",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Logs",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  reverse: true,
                  child: Text(
                    log,
                    style: const TextStyle(fontFamily: "monospace"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
