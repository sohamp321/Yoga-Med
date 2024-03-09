import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:yoga_med/pages/audio_player.dart';

Future<String> createFolder(String folderName, String name, String age,
    String gender, String nurseName) async {
  // 1. Check if we can get broad external storage access (Android 11+)
  bool hasBroadAccess = await _manageExternalStoragePermission();

  Directory? dir;

  if (hasBroadAccess) {
    // Ideal if broad access is granted
    dir = await getExternalStorageDirectory();
  } else {
    // No broad access? Use app-specific storage
    dir = await getApplicationDocumentsDirectory();
  }

  // Create your subfolder within the chosen directory
  final subDir = Directory('${dir!.path}/$folderName');
  if (await subDir.exists()) {
    // File writing logic if the subfolder already exists
    final file = File('${subDir.path}/profile.json');
    final profileData = {
      'name': name,
      'age': age,
      'gender': gender,
      'nurseName': nurseName,
    };
    file.writeAsStringSync(jsonEncode(profileData));

    return subDir.path;
  } else {
    await subDir.create();

    // File writing logic after creating the subfolder
    final file = File('${subDir.path}/profile.json');
    final profileData = {
      'name': name,
      'age': age,
      'gender': gender,
      'nurseName': nurseName,
    };
    file.writeAsStringSync(jsonEncode(profileData));

    return subDir.path;
  }
}

// Helper function for requesting storage permissions
Future<bool> _manageExternalStoragePermission() async {
  if (Platform.isAndroid) {
    if (await Permission.manageExternalStorage.request().isGranted) {
      return true;
    } else {
      return await Permission.storage.request().isGranted;
    }
  } else {
    // Permissions aren't a concern on other platforms
    return true;
  }
}

TextFormField textFieldFunction(BuildContext context, final fieldController,
    String _hintText, String _labelText, String errMsg) {
  return TextFormField(
    style: TextStyle(color: Colors.white, fontSize: 20),
    controller: fieldController,
    decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        floatingLabelStyle: TextStyle(color: Colors.white),
        hintText: _hintText,
        hintStyle: TextStyle(color: Colors.white38),
        labelText: _labelText,
        labelStyle: TextStyle(color: Colors.white), // For the label
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xff58c9b0)),
        ),
        errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error, fontSize: 15)),
    validator: (value) {
      if (value!.trim().isEmpty) {
        return errMsg;
      }
    },
  );
}

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<StatefulWidget> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final nurseController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    genderController.dispose();
    nurseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff1a1a26),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                "Create a New Profile",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
              Lottie.asset('assets/jsons/hii-animation.json',
                  animate: true, height: 250),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          textFieldFunction(
                              context,
                              nameController,
                              "Please enter your name",
                              "Name",
                              "Please enter your name"),
                          textFieldFunction(
                              context,
                              ageController,
                              "Please enter your age",
                              "Age",
                              "Please enter your age"),
                          textFieldFunction(
                              context,
                              genderController,
                              "Please enter your gender",
                              "Gender",
                              "Please enter your gender"),
                          textFieldFunction(
                              context,
                              nurseController,
                              "Please enter your Nurse name",
                              "Nurse name",
                              "Please enter your nurse name"),
                          const Padding(padding: EdgeInsets.all(10)),
                          SizedBox(
                            height: 50,
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  textStyle: const TextStyle(fontSize: 18)),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  String folderName = nameController.text;
                                  String folderPath = await createFolder(
                                      folderName,
                                      nameController.text,
                                      ageController.text,
                                      genderController.text,
                                      nurseController.text);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text("Profile Created")));
                                  // Navigator.of(context).pushReplacement(
                                  //   MaterialPageRoute(
                                  //       builder: (context) => AudioPlayerPage()),
                                  // );
                                }
                              },
                              child: const Text(
                                "Create Profile",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ))),
            ],
          ),
        ));
  }
}
