import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _formEmail = "";
  String _formPassword = "";

  void handleLogin() async {
    final response = await http.post(
        Uri.parse("http://127.0.0.1:4000/api/login"),
        headers: {"Content-type": "application/json"},
        body: json.encode({"email": _formEmail, "password": _formPassword}));

    if (response.statusCode == 200) {
      Navigator.pushNamedAndRemoveUntil(
          context, "/main", (Route<dynamic> route) => false);
    } else {
      throw Exception("Server error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            const Image(
              image: AssetImage("assets/IMG_9185.jpeg"),
            ),
            const Text("Dog Cat Matcher Mobile",
                style: TextStyle(fontSize: 26)),
            TextField(
              onChanged: (value) {
                setState(() {
                  _formEmail = value;
                });
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Email Address"),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  _formPassword = value;
                });
              },
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password"),
            ),
            ElevatedButton(
                onPressed: handleLogin,
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  padding: const EdgeInsets.all(16.0)
                ),
                child: const Text("Login")),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/register");
                },
                child: const Text("Create New Account"))
          ],
        ));
  }
}
