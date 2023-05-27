import 'dart:async';
import 'package:first_app/constants.dart';
import 'dart:ui';
import 'socket.dart';
import 'package:flutter/material.dart';
import 'privateChat.dart';

class ChatsMain extends StatefulWidget {
  const ChatsMain({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _chatsPageState();
  }
}

class _chatsPageState extends State<ChatsMain> {
  List<String> chatUsers = [];
  void getChatUsers() async {
    print("in getChat");
    channel.sink.add("Get_Chats $globalUserName");
  }

  @override
  void initState() {
    super.initState();
    print("in initState");
    getChatUsers();
    Timer(const Duration(seconds: 1), () {
      setState(() {
        chatUsers = globalChatUsers;
      });
    });
  }

  void moveToPrivateChat(BuildContext context, String nameOfUser) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return PrivateChatPage(nameOfClient: nameOfUser);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: ListView(
        children: chatUsers.map(
          (title) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: Text(title),
                onTap: () => moveToPrivateChat(context, title),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
