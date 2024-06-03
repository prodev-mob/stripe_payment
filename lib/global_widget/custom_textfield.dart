import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.title,
      required this.hint,
      this.isNumber,
      required this.controller,});

  final String title, hint;
  final bool? isNumber;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType:
          isNumber == null ? TextInputType.text : TextInputType.number,
      decoration: InputDecoration(label: Text(title), hintText: hint),
      controller: controller,
    );
  }
}
