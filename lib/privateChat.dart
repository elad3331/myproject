import 'dart:async';
import 'dart:collection';
import 'package:first_app/socket.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'dart:ui';

class PrivateChatPage extends StatefulWidget {
  final String nameOfClient;

  const PrivateChatPage({Key? key, required this.nameOfClient})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _privateChatPageState();
  }
}

class _privateChatPageState extends State<PrivateChatPage> {
  final TextEditingController _userMsgController = TextEditingController();
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    // Start the timer when the widget is initialized
    _startTimer();
  }

  @override
  void dispose() {
    _userMsgController.dispose();
    super.dispose();
  }

  void _submitMsg(String text) {
    String message = "Chat $globalUserName ${widget.nameOfClient} $text";
    print("here is message $message");
    channel.sink.add("Chat $globalUserName ${widget.nameOfClient} $text");
    setState(() {
      _messages.insert(0, text);
    });
    _userMsgController.clear();
  }

  void _startTimer() {
    print("start timer");
    // Create a repeating timer that executes the _submitPalMsg() function every 1 second
    var _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _submitPalMsg();
    });
  }

  void _submitPalMsg() {
    print("got here");
    Queue<String>? currentQueue;
    if (chatQueues.containsKey(widget.nameOfClient)) {
      // The specified client name exists as a key in the chatQueues map
      currentQueue = chatQueues[widget.nameOfClient];
      while (currentQueue!.isNotEmpty) {
        String msgText = currentQueue.removeFirst();
        setState(() {
          _messages.insert(0, msgText);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.nameOfClient}"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: _userMsgController,
                      onSubmitted: _submitMsg,
                      decoration: const InputDecoration(
                        hintText: "Type your message here...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _submitMsg(_userMsgController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
