import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:flutter/cupertino.dart'; // for ios

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _formFirstName = "";
  String _formLastName = "";
  String _formEmail = "";
  String _formBirthDate = "";
  String _formOccupation = "";
  String _formPassword = "";

  void handleSubmit() async {
    final response =
        await http.post(Uri.parse("http://127.0.0.1:4000/api/user"),
            headers: {"Content-type": "application/json"},
            body: json.encode({
              "firstName": _formFirstName,
              "lastName": _formLastName,
              "email": _formEmail,
              "birthdate": _formBirthDate,
              "occupation": _formOccupation,
              "password": _formPassword
            }));

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, "/");
    } else {
      throw Exception("Server error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> listOfOccupation = ["Dog Lover", "Cat Lover", "Shabu Lover"];

    return Scaffold(
        appBar: AppBar(title: const Text("Register")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Fill in your information",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _formFirstName = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "First Name",
                    hintText: "Enter your first name",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _formLastName = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Last Name",
                    hintText: "Enter your last name",
                  ),
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
                    border: OutlineInputBorder(),
                    labelText: "Email Address",
                    hintText: "Enter your email address",
                  ),
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
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "Enter your password",
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 10, bottom: 10),
                  child: DateTimeField(
                    format: DateFormat("yyyy-MM-dd"),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Birth Date",
                        hintText: "Enter your birth date",
                        floatingLabelBehavior: FloatingLabelBehavior.never),
                    onSaved: (val) =>
                        setState(() => _formBirthDate = val.toString()),
                    keyboardType: TextInputType.datetime,
                    onChanged: (dt) {
                      setState(() => _formBirthDate = dt.toString());
                    },
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900, 1, 1),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime.now());
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 10, bottom: 10),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Occupation",
                      hintText: "Select your occupation",
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _formOccupation = newValue!;
                      });
                    },
                    items: listOfOccupation.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
                  )),
              SizedBox(
                height: 50,
                // padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  // style: style,
                  onPressed: handleSubmit,
                  // style: style,
                  child: const Text("Register"),
                ),
              ),
            ],
          ),
        ));
  }
}
