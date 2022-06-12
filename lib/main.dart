import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/main.dart';
import 'pages/register.dart';
import 'pages/animal_submit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Cat Matcher Mobile',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const LoginPage(), // home
        "/main": (context) => const MainPage(),
        "/register": (context) => const RegisterPage(),
        "/animal_submit": (context) => const AnimalSubmit(),
      }
    );
  }
}

