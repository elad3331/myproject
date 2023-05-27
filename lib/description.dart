import 'package:flutter/material.dart';
import 'constants.dart';
import 'socket.dart';
import 'dart:ui';

class ProductInfo extends StatefulWidget {
  final String titleText;

  const ProductInfo({Key? key, required this.titleText}) : super(key: key);

  @override
  _productInfoState createState() => _productInfoState();

  static void send2(message) {}
}

class _productInfoState extends State<ProductInfo> {
  // Initial Selected Value
  String dropdownvalue = 'cellphone';
  String dropdownvalue1 = 'black';
  String dropdownvalue2 = 'brand-new';
  String dropdownvalue3 = "ABU JUWEI'ID";

  // List of items in our dropdown menu
  var items = [
    'cellphone',
    'watch',
    'wallet',
  ];
  var colors = [
    'black',
    'dark-blue',
    'red',
    'orange',
    'yellow',
    'light-blue',
    'green',
    'grey',
    'brown',
  ];
  var condition = [
    'brand-new',
    'good',
    'bad',
  ];
  @override
  void initState() {
    super.initState();
    print("in initState");
    // getCities();
  }

  void getCities() async {
    print("in getCities");
    channel.sink.add("Get_Cities");
  }

  void sendDescription() async {
    String msgType = "";
    if (widget.titleText.contains("loss")) {
      msgType = "Lost";
    } else {
      msgType = "Found";
    }
    channel.sink.add(
        "$msgType $globalUserName $dropdownvalue $dropdownvalue1 $dropdownvalue2");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titleText),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              // Initial Value
              value: dropdownvalue,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
              },
            ),
            DropdownButton(
              // Initial Value
              value: dropdownvalue1,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: colors.map((String colors) {
                return DropdownMenuItem(
                  value: colors,
                  child: Text(colors),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue1 = newValue!;
                });
              },
            ),
            DropdownButton(
              // Initial Value
              value: dropdownvalue2,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: condition.map((String condition) {
                return DropdownMenuItem(
                  value: condition,
                  child: Text(condition),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue2 = newValue!;
                });
              },
            ),
            DropdownButton(
              // Initial Value
              value: dropdownvalue3,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: cities.map((String cities) {
                return DropdownMenuItem(
                  value: cities,
                  child: Text(cities),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue3 = newValue!;
                });
              },
            ),
            ElevatedButton(
                onPressed: sendDescription,
                child: const Text("submit your description"))
          ],
        ),
      ),
    );
  }
}
