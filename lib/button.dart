import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String buttonText;
  VoidCallback whenPressed;

  Button(this.buttonText, this.whenPressed);
  @override
  Widget build(BuildContext buildContext) {
    return ElevatedButton(
      child: Text(
        buttonText,
        style: TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
      ),
      onPressed: whenPressed,
    );
  }
}
