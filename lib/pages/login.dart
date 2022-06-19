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

  void navigateOnSuccess() {
    Navigator.pushNamedAndRemoveUntil(
        context, "/main", (Route<dynamic> route) => false);
  }

  void handleLogin() async {
    final response = await http.post(
        Uri.parse("http://127.0.0.1:4000/api/login"),
        headers: {"Content-type": "application/json"},
        body: json.encode({"email": _formEmail, "password": _formPassword}));

    if (response.statusCode == 200) {
      navigateOnSuccess();
    } else {
      throw Exception("Server error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dog Cat Matcher Mobile")
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const Image(
                image: AssetImage("assets/IMG_9185.jpeg"),
              ),

              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "For all animal lovers",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15),
                ),
              ),


              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _formEmail = value;
                    });
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email Address"),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _formPassword = value;
                    });
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password"),
                ),
              ),

              SizedBox(
                height:  50,
                // padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  onPressed: handleLogin,
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                      padding: const EdgeInsets.all(16.0)
                  ),
                  child: const Text ("Login"),
                ),
              ),

              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/register");
                  },
                  child: const Text("Create New Account"))
            ],
          ),
        )
        );
  }
}
