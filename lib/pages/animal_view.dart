import 'package:flutter/material.dart';

import 'main.dart';

class AnimalViewPage extends StatelessWidget {
  const AnimalViewPage({
    Key? key,
    required this.animal
  }) : super(key: key);

  final Animal animal;

  @override
  Widget build(BuildContext context) {

    Widget photo = (animal.photoUrl != "")
        ? Image(
      image: AssetImage(animal.photoUrl),
    )
        : const Text("No photo");

    List<TextButton> tags = animal.tags.map((tag) =>
        TextButton(onPressed: null, child: Text(tag))).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(animal.name),
      ),
      body: Column(
        children: <Widget>[
          photo,
          Text(animal.description),
          Row(
            children: tags,
          ),

        ],

      )
    );
  }
}
