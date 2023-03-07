import 'package:first_app/category.dart';
import 'package:flutter/material.dart';
import 'package:first_app/description.dart';


class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _myAppState();
  }
}

class _myAppState extends State<MyApp> {
  void pressOnChats() {}
  void pressOnLost() {
    print("bye");
  }

  void pressOnFound() {
    print("hey");
  }

  void moveToLossPage(BuildContext context, String titleSen) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return ProductInfo();
        },
      ),
    );
  }

  void moveToFoundPage(BuildContext context, String titleSen) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return ProductInfo();
        },
      ),
    );
  }

  void moveToChats(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return ProductInfo();
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('hey'),
        ),
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.all(50),
          child: Column(
            children: [
              InkWell(
                  onTap: () => (moveToLossPage(context, "Describe the loss")),
                  child: categoryItem(
                    "I found an item",
                  )),
              InkWell(
                  onTap: () =>
                      (moveToFoundPage(context, "Describe the finding")),
                  child: categoryItem(
                    "I lost an item",
                  )),
              InkWell(
                  onTap: () => (moveToChats(context)),
                  child: categoryItem(
                    "Chats",
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
