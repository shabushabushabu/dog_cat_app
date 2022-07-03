import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  XFile? _formImage;

  final newTagField = TextEditingController();

  void navigateBack() {
    Navigator.pop(context);
  }

  void handleSubmit() async {
    logger.d("Sending request to POST /api/animal");

    final response = await http.post(
        Uri.parse("http://127.0.0.1:4000/api/animal"),
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "name": _formName,
          "description": _formDescription,
          "tags": _formTags
        }));
    if (response.statusCode == 200) {
      logger.d("Received request from POST /api/animal");

      final res = json.decode(response.body);
      final animalId = res["id"];

      if (_formImage != null) {
        var photoBytes = await _formImage?.readAsBytes();

        var uploadRequest = http.MultipartRequest(
            "POST", Uri.parse("http://127.0.0.1:4000/api/uploadPhoto"));
        uploadRequest.fields["id"] = animalId;
        uploadRequest.files
            .add(http.MultipartFile.fromBytes("photo", photoBytes!));

        logger.d("Sending upload photo request to POST /api/uploadPhoto");
        var uploadResponse = await uploadRequest.send();

        if (uploadResponse.statusCode == 201) {
          logger.d("Received success response from POST /api/uploadPhoto");
          navigateBack();
        } else {
          logger.d("Error response: ${uploadResponse.statusCode}");
          navigateBack();
        }
      } else {
        logger.d("No image sent");
        navigateBack();
      }
    } else {
      logger.d("Error response: ${response.statusCode}");
    }
  }

  void handleSelectPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _formImage = image;
    });
    logger.d("Upload an image");
  }

  void handleTakePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _formImage = image;
    });
    logger.d("Take an image");
  }

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
                      onPressed: handleSelectPhoto,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_a_photo_rounded, size: 40.0),
                      color: Colors.amber.shade600,
                      onPressed: handleTakePhoto,
                    ),
                    SizedBox(
                      height: 40,
                      // padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        // style: style,
                        onPressed: handleSubmit,
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
