import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'animal_view.dart';
import 'animal_submit.dart';
// import 'package:flutter/cupertino.dart'; // for ios

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
    // async

    DummyData dummy = DummyData();

    setState(() {
      animals = dummy.animals;
    });
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
      body: AnimalGrid(animals: animals),
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
    Widget photo = (animal.photoUrl != "")
        ? Image(
            image: AssetImage(animal.photoUrl),
          )
        : const Text("No photo");
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
