import 'dart:collection';
import 'dart:ui';
import 'package:first_app/privateChat.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_socket_channel/io.dart';
import 'constants.dart';
import 'mainPage.dart';

final channel = IOWebSocketChannel.connect('ws://192.168.56.1:12345');

class MessageHandler {
  final Map<String, Function> messageHandlers = {
    'Match': handleMatch,
    'Chat': handleChat,
    'GetChats': handleGetChat,
    'Login': handleLogin,
    'Registration': handleRegistration,
    //'Cities': handleCities
  };

  void startListening() {
    print("listeningggggggggg");
    var msg = "";
    channel.stream.listen((message) {
      msg += message;
      print("message received here is $message");
      final messageType = getMessageType(message);
      if (messageHandlers.containsKey(messageType)) {
        messageHandlers[messageType]!(message);
      } else {
        handleUnknownMessage(message);
      }
    }, onDone: () {
      print('Stream closed');
    }, onError: (error) {
      print('Error: $error');
    });
  }

  String getMessageType(String message) {
    final parts = message.split(',');
    return parts.isNotEmpty ? parts[0] : '';
  }

  static void handleMatch(String message) {
    print("sending!!!");
    if (message.contains("Match,Succeed,Server,")) {
      String msgToDisplay = "";
      if (message.contains("Lost")) {
        msgToDisplay =
            "${message.substring(26)} lost product that matches the one you found. Chat with him!";
      } else {
        msgToDisplay =
            "${message.substring(26)} found product that matches the one you lost. Chat with him!";
      }
      Fluttertoast.showToast(
        msg: msgToDisplay,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Currently there is no product that matches yours",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static void handleChat(String message) {
    print("the message in chats is $message");
    String msgFrom = message.split(",")[1];
    print("msgFrom $msgFrom");
    String msgContent = message.split(",")[2];
    print("msgCont $msgContent");
    if (!chatQueues.containsKey(msgFrom)) {
      print("Contains");
      chatQueues[msgFrom] = Queue();
    }
    chatQueues[msgFrom]?.add(msgContent);
  }

  static void handleGetChat(String message) {
    if (message.substring(0, 24) == "GetChats,Succeed,Server,") {
      message = message.substring(25);
      globalChatUsers = message.split(" ");
    }
  }

  static void handleLogin(String message) {
    if (message.contains("Login,Succeed,Server,")) {
      globalUserName = message.substring(21);
      Navigator.pushReplacement(currentContext!,
          MaterialPageRoute(builder: (context) => const MainPage()));
    } else {
      showValidationError("Username or password is incorrect", currentContext!);
    }
  }

  static void handleRegistration(String message) {
    if (message.contains("Registration,Succeed,Server,")) {
      globalUserName = message.substring(28);
      Navigator.pushReplacement(currentContext!,
          MaterialPageRoute(builder: (context) => const MainPage()));
    } else if (message == "Registration,Failed,Server,user already exists") {
      showValidationError(
          "A user with that username already exsits", currentContext!);
    }
  }

/*
  static void handleCities(String message) {
    print("message in cities is $message");
    if (message.contains("Cities,Succeed,Server,")) {
      var allCities = message.substring(23);
      print("cities is $allCities");
      cities = allCities.split(",");
    }
  }
*/
  static void handleUnknownMessage(String message) {
    // handle unknown message
  }
  static void showValidationError(String message, BuildContext context) {
    // Display an error message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String xor_dec_enc(String text) {
    List<int> encrypted = [];
    for (int i = 0; i < text.length; i++) {
      int charCode = text.codeUnitAt(i) ^ key.codeUnitAt(i % key.length);
      encrypted.add(charCode);
    }
    return String.fromCharCodes(encrypted);
  }
}
