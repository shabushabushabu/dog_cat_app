import 'package:flutter/material.dart';

class AnimalSubmit extends StatelessWidget {
  const AnimalSubmit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post an animal")
      ),
      body: Column(
        children: const [Text("Post")],
      )

    );
  }
}

