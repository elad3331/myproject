import 'package:flutter/material.dart';

class categoryItem extends StatelessWidget {
  final String text;

  const categoryItem(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(1, 123, 79, 165),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 28,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
