import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'animal_view.dart';
import 'animal_submit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
// import 'package:flutter/cupertino.dart'; // for ios

final logger = Logger();

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Animal> animals = [];

  @override
  void initState() {
    super.initState();

    fetchData();

    // // Stub loads data from dummy
    // DummyData dummy = DummyData();
    // setState(() {
    //   animals = dummy.animals;
    // });
  }

  void fetchData() async {
    logger.d("Fetching data from /api/animals");

    var response = await http.get(
        Uri.parse("http://127.0.0.1:4000/api/animals"),
        headers: {"Content-type": "application/json"});

    if (response.statusCode == 200) {
      logger.d("Received response from GET /api/animals");
      List<dynamic> animalJsonList = json.decode(response.body);
      List<Animal> animalList = [];
      for (var i = 0; i < animalJsonList.length; i++) {
        var json = animalJsonList[i];
        List<dynamic> tagList = json['tags'];
        var tags = tagList.map((t) => t.toString()).toList();
        var newAnimal = Animal(
            json["name"], json["description"], tags, json["photoUrls"][0]);
        animalList.add(newAnimal);
      }

      setState(() {
        animals = animalList;
      });
    } else {
      logger.d("Error response: ${response.statusCode}");
    }
  }

  void navigateOnSuccess() {
    Navigator.pushReplacementNamed(context, "/");
  }

  void handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    navigateOnSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dog Cat Matcher", style: TextStyle(fontSize: 20)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                handleLogout();
              },
              child: const Icon(Icons.lock_open_outlined),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          fetchData();
        },
        child: AnimalGrid(animals: animals),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AnimalSubmit()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AnimalGrid extends StatelessWidget {
  const AnimalGrid({Key? key, required this.animals}) : super(key: key);

  final List<Animal> animals;

  @override
  Widget build(BuildContext context) {
    List<AnimalCard> animalCards = animals
        .map((animal) => AnimalCard(
              animal: animal,
            ))
        .toList();

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: const EdgeInsets.all(16.0),
      children: animalCards,
    );
  }
}

class AnimalCard extends StatelessWidget {
  const AnimalCard({Key? key, required this.animal}) : super(key: key);

  final Animal animal;

  void handlerTap(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AnimalViewPage(animal: animal)));
  }

  @override
  Widget build(BuildContext context) {
    // Widget photo = (animal.photoUrl != "")
    //     ? Image(
    //         image: AssetImage(animal.photoUrl),
    //       )
    //     : const Text("No photo");

    Widget photo = (animal.photoUrl != '')
        ? Image.network("http://127.0.0.1:4000${animal.photoUrl}")
        : const Text("No Photo");

    return Card(
        color: Colors.amber[100],
        child: InkWell(
          splashColor: Colors.orangeAccent,
          onTap: () {
            handlerTap(context);
          },
          child: Column(
            children: <Widget>[
              photo,
              Text(animal.name, style: const TextStyle(fontSize: 18)),
              Text(animal.description, style: const TextStyle(fontSize: 10)),
            ],
          ),
        ));
  }
}

// data
class Animal {
  String name = "";
  String description = "";
  String photoUrl = "";
  List<String> tags = [];

  Animal(this.name, this.description, this.tags, this.photoUrl);
}

class DummyData {
  List<Animal> animals = [
    Animal("Shabu", "Lovely corgi", ["corgi", "male"], "assets/IMG_9102.jpeg"),
    Animal("Bubu", "Fat corgi", ["corgi", "fat"], "assets/IMG_9131.jpeg"),
    Animal(
        "Fatbu", "Lovely chubby", ["corgi", "chubby"], "assets/IMG_9134.jpeg"),
    Animal("Shabu", "Lovely corgi", ["corgi", "male"], "assets/IMG_9102.jpeg"),
    Animal("Bubu", "Fat corgi", ["corgi", "fat"], "assets/IMG_9131.jpeg"),
    Animal(
        "Fatbu", "Lovely chubby", ["corgi", "chubby"], "assets/IMG_9134.jpeg"),
    Animal("Shabu", "Lovely corgi", ["corgi", "male"], "assets/IMG_9102.jpeg"),
    Animal("Bubu", "Fat corgi", ["corgi", "fat"], "assets/IMG_9131.jpeg"),
    Animal(
        "Fatbu", "Lovely chubby", ["corgi", "chubby"], "assets/IMG_9134.jpeg"),
  ];
}
