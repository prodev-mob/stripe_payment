import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_gateway_demo/global_widget/custom_textfield.dart';
import 'package:payment_gateway_demo/model/payment_request_model.dart' as model;
import 'package:payment_gateway_demo/model/payment_request_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  List<String> currencyList = <String>[
    'USD',
    'INR',
    'EUR',
    'JPY',
    'GBP',
    'AED'
  ];
  String selectedCurrency = 'USD';

  bool hasDonated = false;

  Future<void> initPaymentSheet() async {
    try {
      final paymentRequest = model.PaymentRequest(
        amount: (int.parse(amountController.text) * 100).toString(),
        currency: selectedCurrency,
        paymentMethodTypes: ['card'],
        description: "Test Donation",
        automaticPaymentMethods: model.AutomaticPaymentMethods(enabled: "true"),
        shipping: model.Shipping(
          name: nameController.text,
          address: model.Address(
            line1: addressController.text,
            postalCode: pincodeController.text,
            city: cityController.text,
            state: stateController.text,
            country: countryController.text,
          ),
        ),
      );

      final data = await createPaymentIntent(paymentRequest);
      print('isGooglePaySupported ;');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Image(
              image: AssetImage("assets/image.jpg"),
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            hasDonated
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Thanks for your ${amountController.text} $selectedCurrency donation",
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Text(
                          "We appreciate your support",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent.shade400),
                            child: const Text(
                              "Donate again",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              setState(() {
                                hasDonated = false;
                                amountController.clear();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Support us with your donations",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: CustomTextField(
                                  controller: amountController,
                                  isNumber: true,
                                  title: "Donation Amount",
                                  hint: "Any amount you like",
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              DropdownButton<String>(
                                value: selectedCurrency,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCurrency = newValue!;
                                  });
                                },
                                items: currencyList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            title: "Name",
                            hint: "Ex. John Doe",
                            controller: nameController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            title: "Address Line",
                            hint: "Ex. 123 Main St",
                            controller: addressController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: CustomTextField(
                                  title: "City",
                                  hint: "Ex. New Delhi",
                                  controller: cityController,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 5,
                                child: CustomTextField(
                                  title: "State (Short code)",
                                  hint: "Ex. DL for Delhi",
                                  controller: stateController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: CustomTextField(
                                  title: "Country (Short Code)",
                                  hint: "Ex. IN for India",
                                  controller: countryController,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 5,
                                child: CustomTextField(
                                  title: "Pincode",
                                  hint: "Ex. 123456",
                                  controller: pincodeController,
                                  isNumber: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent.shade400),
                              child: const Text(
                                "Proceed to Pay",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () async {
                                if (amountController.text.isNotEmpty &&
                                    nameController.text.isNotEmpty &&
                                    addressController.text.isNotEmpty &&
                                    cityController.text.isNotEmpty &&
                                    stateController.text.isNotEmpty &&
                                    countryController.text.isNotEmpty &&
                                    pincodeController.text.isNotEmpty) {
                                  await initPaymentSheet();

                                  try {
                                    await Stripe.instance.presentPaymentSheet();

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                        "Payment Done",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green,
                                    ));

                                    setState(() {
                                      hasDonated = true;
                                    });
                                    nameController.clear();
                                    addressController.clear();
                                    cityController.clear();
                                    stateController.clear();
                                    countryController.clear();
                                    pincodeController.clear();
                                  } catch (e) {
                                    print("Payment sheet failed");
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                        "Payment Failed",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                    ));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please fill all the fields",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              },
                            ),
                          )
                        ]),
                  ),
          ],
        ),
      ),
    );
  }
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
}
