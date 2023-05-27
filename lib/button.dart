import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String buttonText;
  VoidCallback whenPressed;

  Button(this.buttonText, this.whenPressed, {super.key});
  @override
  Widget build(BuildContext buildContext) {
    return ElevatedButton(
      onPressed: whenPressed,
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
      ),
    );
  }
}
