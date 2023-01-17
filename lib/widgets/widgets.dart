import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TFWidget extends StatelessWidget {
final Function() function;
final String hint;
final TextEditingController controller;
final TextInputType input;

  const TFWidget({super.key, required this.function, required this.hint, required this.controller,  required this.input});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        keyboardType:input ,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: hint
        ),
        onTap: function,
        controller: controller,
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
final Function() function;
final String text;

  const ButtonWidget({super.key, required this.function, required this.text});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: function, child: Text("${text}"));
  }
}

