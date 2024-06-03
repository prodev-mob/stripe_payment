// To parse this JSON data, do
//
//     final paymentRequest = paymentRequestFromJson(jsonString);

import 'dart:convert';

PaymentRequest paymentRequestFromJson(String str) =>
    PaymentRequest.fromJson(json.decode(str));

String paymentRequestToJson(PaymentRequest data) => json.encode(data.toJson());

class PaymentRequest {
  List<String>? paymentMethodTypes;
  String? description;
  String? currency;
  AutomaticPaymentMethods? automaticPaymentMethods;
  String? amount;
  Shipping? shipping;

  PaymentRequest({
    this.paymentMethodTypes,
    this.description,
    this.currency,
    this.automaticPaymentMethods,
    this.amount,
    this.shipping,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => PaymentRequest(
        paymentMethodTypes: json["payment_method_types"] == null
            ? []
            : List<String>.from(json["payment_method_types"]!.map((x) => x)),
        description: json["description"],
        currency: json["currency"],
        automaticPaymentMethods: json["automatic_payment_methods"] == null
            ? null
            : AutomaticPaymentMethods.fromJson(
                json["automatic_payment_methods"]),
        amount: json["amount"],
        shipping: json["shipping"] == null
            ? null
            : Shipping.fromJson(json["shipping"]),
      );

  Map<String, dynamic> toJson() => {
        "payment_method_types": paymentMethodTypes == null
            ? []
            : List<dynamic>.from(paymentMethodTypes!.map((x) => x)),
        "description": description,
        "currency": currency,
        "automatic_payment_methods": automaticPaymentMethods?.toJson(),
        "amount": amount,
        "shipping": shipping?.toJson(),
      };
}

class AutomaticPaymentMethods {
  String? enabled;

  AutomaticPaymentMethods({
    this.enabled,
  });

  factory AutomaticPaymentMethods.fromJson(Map<String, dynamic> json) =>
      AutomaticPaymentMethods(
        enabled: json["enabled"],
      );

  Map<String, dynamic> toJson() => {
        "enabled": enabled,
      };
}

class Shipping {
  Address? address;
  String? name;

  Shipping({
    this.address,
    this.name,
  });

  factory Shipping.fromJson(Map<String, dynamic> json) => Shipping(
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "address": address?.toJson(),
        "name": name,
      };
}

class Address {
  String? line1;
  String? state;
  String? postalCode;
  String? city;
  String? country;

  Address({
    this.line1,
    this.state,
    this.postalCode,
    this.city,
    this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        line1: json["line1"],
        state: json["state"],
        postalCode: json["postal_code"],
        city: json["city"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "line1": line1,
        "state": state,
        "postal_code": postalCode,
        "city": city,
        "country": country,
      };
}
