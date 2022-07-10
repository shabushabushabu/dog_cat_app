import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'main.dart';

final logger = Logger();

class AnimalViewPage extends StatelessWidget {
  const AnimalViewPage({Key? key, required this.animal}) : super(key: key);

  final Animal animal;

  @override
  Widget build(BuildContext context) {
    Widget photo = (animal.photoUrl != '')
        ? Image.network("http://127.0.0.1:4000${animal.photoUrl}")
        : const Text("No Photo");

    List<Chip> tags = animal.tags
        .map((tag) => Chip(
              labelPadding: const EdgeInsets.only(left: 8.0, right: 8.0),
              label: Text("#$tag"),
              onDeleted: null,
              backgroundColor: Colors.amber[100],
            ))
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: Text(animal.name),
        ),
        body: Column(
          children: <Widget>[
            photo,
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 10, bottom: 10),
              child: Text(animal.description,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16)),
            ),
            Wrap(
              spacing: 15,
              children: tags,
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 50, bottom: 10),
                child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 3,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 25.0),
                        child: Text(
                          "Adopt me!",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.orange),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.pets_rounded, size: 50.0),
                        color: Colors.amber.shade400,
                        onPressed: () {
                          logger.d("Adopt pet: ${animal.name}");
                          Navigator.pushNamed(context, "/main");
                        },
                      ),
                    ])),
          ],
        ));
  }
}
