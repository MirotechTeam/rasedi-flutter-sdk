import 'enums.dart';

class CreatePaymentPayload {
  final String amount;
  final String title;
  final String description;
  final List<Gateway> gateways;
  final String redirectUrl;
  final String callbackUrl;
  final bool collectFeeFromCustomer;
  final bool collectCustomerEmail;
  final bool collectCustomerPhoneNumber;

  CreatePaymentPayload({
    required this.amount,
    required this.title,
    required this.description,
    required this.gateways,
    required this.redirectUrl,
    required this.callbackUrl,
    required this.collectFeeFromCustomer,
    required this.collectCustomerEmail,
    required this.collectCustomerPhoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'title': title,
      'description': description,
      'gateways': gateways.map((e) => e.name).toList(),
      'redirectUrl': redirectUrl,
      'callbackUrl': callbackUrl,
      'collectFeeFromCustomer': collectFeeFromCustomer,
      'collectCustomerEmail': collectCustomerEmail,
      'collectCustomerPhoneNumber': collectCustomerPhoneNumber,
    };
  }
}

class CreatePaymentResponse {
  final CreatePaymentResponseBody body;
  final Map<String, String> headers;
  final int statusCode;

  CreatePaymentResponse({
    required this.body,
    required this.headers,
    required this.statusCode,
  });
}

class CreatePaymentResponseBody {
  final String referenceCode;
  final String amount;
  final String? paidVia;
  final String? paidAt;
  final String redirectUrl;
  final PaymentStatus status;
  final String? payoutAmount;

  CreatePaymentResponseBody({
    required this.referenceCode,
    required this.amount,
    this.paidVia,
    this.paidAt,
    required this.redirectUrl,
    required this.status,
    this.payoutAmount,
  });

  factory CreatePaymentResponseBody.fromJson(Map<String, dynamic> json) {
    return CreatePaymentResponseBody(
      referenceCode: json['referenceCode'],
      amount: json['amount'],
      paidVia: json['paidVia'],
      paidAt: json['paidAt'],
      redirectUrl: json['redirectUrl'],
      status: PaymentStatus.values.byName(json['status']),
      payoutAmount: json['payoutAmount'],
    );
  }
}

class PaymentDetailsResponse {
  final PaymentDetailsResponseBody body;
  final Map<String, String> headers;
  final int statusCode;

  PaymentDetailsResponse({
    required this.body,
    required this.headers,
    required this.statusCode,
  });
}

class PaymentHistoryItem {
  final String referenceCode;
  final PaymentStatus status;
  final String amount;
  final String? gateway;
  final String? paidAt;
  final String? payoutAmount;
  final String? serviceFeeAmount;
  final String? gatewayFeeAmount;
  final String? expiresAt;

  PaymentHistoryItem({
    required this.referenceCode,
    required this.status,
    required this.amount,
    this.gateway,
    this.paidAt,
    this.payoutAmount,
    this.serviceFeeAmount,
    this.gatewayFeeAmount,
    this.expiresAt,
  });

  factory PaymentHistoryItem.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryItem(
      referenceCode: json['referenceCode'],
      status: PaymentStatus.values.byName(json['status']),
      amount: json['amount'],
      gateway: json['gateway'],
      paidAt: json['paidAt'],
      payoutAmount: json['payoutAmount'],
      serviceFeeAmount: json['serviceFeeAmount'],
      gatewayFeeAmount: json['gatewayFeeAmount'],
      expiresAt: json['expiresAt'],
    );
  }
}

class PaymentDetailsResponseBody {
  final String referenceCode;
  final String amount;
  final String? paidVia;
  final String? paidAt;
  final String redirectUrl;
  final PaymentStatus status;
  final String? payoutAmount;
  final List<PaymentHistoryItem> history;

  PaymentDetailsResponseBody({
    required this.referenceCode,
    required this.amount,
    this.paidVia,
    this.paidAt,
    required this.redirectUrl,
    required this.status,
    this.payoutAmount,
    this.history = const [],
  });

  factory PaymentDetailsResponseBody.fromJson(Map<String, dynamic> json) {
    return PaymentDetailsResponseBody(
      referenceCode: json['referenceCode'],
      amount: json['amount'],
      paidVia: json['paidVia'],
      paidAt: json['paidAt'],
      redirectUrl: json['redirectUrl'],
      status: PaymentStatus.values.byName(json['status']),
      payoutAmount: json['payoutAmount'],
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => PaymentHistoryItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CancelPaymentResponse {
  final CancelPaymentResponseBody body;
  final Map<String, String> headers;
  final int statusCode;

  CancelPaymentResponse({
    required this.body,
    required this.headers,
    required this.statusCode,
  });
}

class CancelPaymentResponseBody {
  final String referenceCode;
  final String amount;
  final String? paidVia;
  final String? paidAt;
  final String redirectUrl;
  final PaymentStatus status;
  final String? payoutAmount;

  CancelPaymentResponseBody({
    required this.referenceCode,
    required this.amount,
    this.paidVia,
    this.paidAt,
    required this.redirectUrl,
    required this.status,
    this.payoutAmount,
  });

  factory CancelPaymentResponseBody.fromJson(Map<String, dynamic> json) {
    return CancelPaymentResponseBody(
      referenceCode: json['referenceCode'],
      amount: json['amount'],
      paidVia: json['paidVia'],
      paidAt: json['paidAt'],
      redirectUrl: json['redirectUrl'],
      status: PaymentStatus.values.byName(json['status']),
      payoutAmount: json['payoutAmount'],
    );
  }
}

@Deprecated('Use status checking or webhooks instead.')
class VerifyPayload {
  final String keyId;
  final String? content;

  VerifyPayload({required this.keyId, this.content});
}
