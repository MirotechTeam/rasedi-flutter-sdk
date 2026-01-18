enum Gateway {
  FIB,
  ZAIN,
  ASIA_PAY,
  FAST_PAY,
  NASS_WALLET,
  CREDIT_CARD;

  String toJson() => name;
  static Gateway fromJson(String json) => Gateway.values.byName(json);
}

enum PaymentStatus {
  TIMED_OUT,
  PENDING,
  PAID,
  CANCELED,
  FAILED;

  String toJson() => name;
  static PaymentStatus fromJson(String json) => PaymentStatus.values.byName(json);
}
