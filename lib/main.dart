import 'dart:async';
import 'dart:ui';
import 'package:first_app/registerPage.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'constants.dart';
import 'mainPage.dart';
import 'socket.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Login Demo',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void showValidationError(String message, BuildContext context) {
    // Display an error message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void login(String userName, String password, BuildContext context) async {
    print("Tries to Login");
    print("here");
    channel.sink.add("Login $userName $password");
    currentContext = context;
    MessageHandler messageHandler = MessageHandler();
    messageHandler.startListening();
  }

  void moveToRegistration(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return RegisterPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                login(_usernameController.text, _passwordController.text,
                    context);
                // TODO: Implement login functionality
              },
              child: const Text('Login'),
            ),
            InkWell(
              onTap: () => moveToRegistration(context),
              child: const Text("Don't have an account yet? Sign up for free."),
            )
          ],
        ),
      ),
    );
  }
}
