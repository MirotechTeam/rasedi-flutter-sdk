# Rasedi Flutter SDK

The official Flutter SDK for [Rasedi Payment Gateway](https://rasedi.com). This library provides a simple way to integrate Rasedi payments into your Flutter/Dart applications.

## Features

- **Cross-Platform**: Works on Android, iOS, Web, macOS, Windows, and Linux.
- **Secure**: Built-in authentication and request signing.
- **Easy Integration**: Simple key-based initialization and typed response models.

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  rasedi_flutter_sdk:
    git:
      url: https://github.com/MirotechTeam/rasedi-flutter-sdk.git
      ref: main
```

*Note: Once published to pub.dev, you can use `rasedi_flutter_sdk: ^0.0.1`.*

## Quick Start

### 1. Initialize the Client

```dart
import 'package:rasedi_flutter_sdk/rasedi_flutter_sdk.dart';

void main() async {
  // Your credentials
  const secretKey = "live_...";
  const privateKey = """-----BEGIN PRIVATE KEY-----
...
-----END PRIVATE KEY-----""";

  // Initialize client
  // The environment (Test/Live) is automatically detected from the secret key.
  final client = RasediClient(privateKey, secretKey);
}
```

### 2. Create a Payment

```dart
final payload = CreatePaymentPayload(
  amount: "10000",
  title: "Order #123",
  description: "Payment description",
  gateways: [Gateway.CREDIT_CARD],
  redirectUrl: "https://your-site.com/callback",
  callbackUrl: "https://your-site.com/webhook",
  collectFeeFromCustomer: true,
  collectCustomerEmail: true,
  collectCustomerPhoneNumber: false,
);

try {
  final response = await client.createPayment(payload);
  print("Payment created: ${response.body.referenceCode}");
  print("Redirect user to: ${response.body.redirectUrl}");
} catch (e) {
  print("Error creating payment: $e");
}
```

### 3. Check Payment Status

```dart
try {
  final response = await client.getPaymentByReference("reference-code");
  print("Status: ${response.body.status}");
} catch (e) {
  print("Error fetching status: $e");
}
```

### 4. Cancel a Payment

```dart
try {
  final response = await client.cancelPayment("reference-code");
  print("Payment cancelled: ${response.body.status}");
} catch (e) {
  print("Error cancelling payment: $e");
}
```

## Requirements

- Flutter >=3.0.0
- Dart >=3.0.0

## License

This project is licensed under the MIT License.
