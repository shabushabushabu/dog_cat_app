import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

final logger = Logger();
final ImagePicker _picker = ImagePicker();

class AnimalSubmit extends StatefulWidget {
  const AnimalSubmit({Key? key}) : super(key: key);

  @override
  State<AnimalSubmit> createState() => _AnimalSubmitState();
}

class _AnimalSubmitState extends State<AnimalSubmit> {
  String _formName = "";
  String _formDescription = "";
  String _formNewTag = "";
  List<String> _formTags = [];

  final newTagField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> tags = _formTags
        .map((tag) => TextButton(
            onPressed: () {
              var oldTags = _formTags;
              oldTags.remove(tag);
              setState(() {
                _formTags = oldTags;
              });
            },
            child: Text("#$tag")))
        .toList();

    return Scaffold(
        appBar: AppBar(title: const Text("Post an animal")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Find animals their forever home",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _formName = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Animal Name",
                    hintText: "Enter the animal name",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _formDescription = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Animal Description",
                    hintText: "Enter the animal short description",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
                child: TextField(
                  controller: newTagField,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        _formNewTag = value;
                      });
                      return;
                    }

                    const splitChar = " ";
                    final lastChar = value.substring(value.length - 1);
                    if (lastChar == splitChar) {
                      final tag = value.substring(0, value.length - 1);
                      var oldTags = _formTags;
                      oldTags.add(tag);

                      setState(() {
                        _formNewTag = "";
                        _formTags = oldTags;
                      });
                      newTagField.text = "";
                    } else {
                      setState(() {
                        _formNewTag = value;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Animal Tags",
                    hintText: "Add animal tags. Tab space for another tag.",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
                child: Wrap(
                  children: tags,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_photo_alternate_rounded,
                          size: 40.0),
                      color: Colors.amber.shade600,
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_a_photo_rounded, size: 40.0),
                      color: Colors.amber.shade600,
                      onPressed: () {},
                    ),
                    SizedBox(
                      height: 40,
                      // padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        // style: style,
                        onPressed: () {},
                        // style: style,
                        child: const Text("Submit Animal"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
