import 'package:flutter/material.dart';

class categoryItem extends StatelessWidget {
  final String text;

  categoryItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(1, 123, 79, 165),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 28,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
