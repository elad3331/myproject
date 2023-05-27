import 'package:first_app/category.dart';
import 'package:first_app/chats.dart';
import 'package:flutter/material.dart';
import 'package:first_app/description.dart';
import 'dart:ui';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _mainPageState();
  }
}

class _mainPageState extends State<MainPage> {
  void pressOnChats() {}
  void pressOnLost() {
    print("bye");
  }

  void pressOnFound() {
    print("hey");
  }

  void moveToLossFoundPage(BuildContext context, String titleSen) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return ProductInfo(titleText: titleSen);
        },
      ),
    );
  }

  void moveToChats(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return const ChatsMain();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ReturnIt'),
        ),
        body: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(50),
          child: Column(
            children: [
              InkWell(
                onTap: () =>
                    (moveToLossFoundPage(context, "Describe the loss")),
                child: const categoryItem(
                  "I lost an item",
                ),
              ),
              InkWell(
                onTap: () =>
                    (moveToLossFoundPage(context, "Describe the finding")),
                child: const categoryItem(
                  "I found an item",
                ),
              ),
              InkWell(
                onTap: () => (moveToChats(context)),
                child: const categoryItem(
                  "Chats",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
