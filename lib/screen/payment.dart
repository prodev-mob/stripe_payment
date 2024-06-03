import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:payment_gateway_demo/model/payment_request_model.dart';

Future<Map<String, dynamic>>  createPaymentIntent(
    PaymentRequest paymentRequest) async {
  try {
    final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
    final secretKey = dotenv.env["STRIPE_SECRET_KEY"]!;

    print('-------------paymentRequest ${paymentRequestToJson(paymentRequest)}');
    Map<String, String> body = {
      'amount': paymentRequest.amount!,
      'currency': paymentRequest.currency!,
      'description': paymentRequest.description ?? '',
      'shipping[name]': paymentRequest.shipping?.name ?? '',
      'shipping[address][line1]': paymentRequest.shipping?.address?.line1 ?? '',
      'shipping[address][postal_code]': paymentRequest.shipping?.address?.postalCode ?? '',
      'shipping[address][city]': paymentRequest.shipping?.address?.city ?? '',
      'shipping[address][state]': paymentRequest.shipping?.address?.state ?? '',
      'shipping[address][country]': paymentRequest.shipping?.address?.country ?? '',
      'payment_method_types[]': paymentRequest.paymentMethodTypes?.join(',') ?? 'card',
    };

    print('===============body :: $body');
    print('paymentRequestToJson :: ${paymentRequest.toJson()}');

    Map<String, dynamic> abc = paymentRequest.toJson();
    abc.addAll({'amount': '300'});
    String jsonRequest = json.encode(abc);
    print(' ====================$jsonRequest');
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $secretKey",
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('status code ${response.statusCode}');
      print('status code ${response.body}');
      throw Exception('Failed to create payment intent');
    }
  } on Exception catch (e) {
    throw Exception('$e');
  }
}
