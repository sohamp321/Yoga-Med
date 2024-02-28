import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:lottie/lottie.dart';




class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<StatefulWidget> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailIdController = TextEditingController();
  final genderController = TextEditingController();
  final fieldAController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailIdController.dispose();
    genderController.dispose();
    fieldAController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:const Color(0xff1a1a26),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children:<Widget> [
              const Text(
                  "Create a New Profile",
                  style: TextStyle(color: Color(0xff58c977), fontSize: 30),
                ),
              
              Lottie.asset(
                'jsons/welcome.json',
                animate: true,
                height: 250
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            
                            style:const TextStyle(
                              color: Colors.white,
                              fontSize: 20
                            ),
                            controller: nameController,
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(borderSide:BorderSide(color: Colors.white), ),
                              floatingLabelStyle: TextStyle(color: Colors.white),
                              hintText: "Please enter your name",
                              hintStyle: TextStyle(color: Colors.white38),
                              labelText: "Name",
                              labelStyle:
                                  TextStyle(color: Colors.white), // For the label
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff58c9b0)),
                              ),
                            ),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Please enter your name";
                              }
                            },
                          ),
                          TextFormField(
                            style: const TextStyle(
                              color:  Colors.white,
                              fontSize: 20
                            ),
                            controller: emailIdController,
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(borderSide:BorderSide(color: Colors.white), ),
                              hintText: "Please enter your age",
                              hintStyle: TextStyle(color: Colors.white38),
                              labelText: "Age",
                              labelStyle:
                                  TextStyle(color: Colors.white), // For the label
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff58c9b0)),
                              ),
                            ),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Please enter your age";
                              }
                            },
                          ),
                          TextFormField(
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20
                            ),
                            controller: genderController,
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(borderSide:BorderSide(color: Colors.white), ),
                              hintText: "Please enter your gender",
                              hintStyle: TextStyle(color: Colors.white38),
                              labelText: "Gender",
                              labelStyle:
                                  TextStyle(color: Colors.white), // For the label
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff58c9b0)),
                              ),
                            ),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Please enter your gender";
                              }
                            },
                          ),
                          TextFormField(
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20
                            ),
                            controller: fieldAController,
                            decoration:const InputDecoration(
                              enabledBorder: UnderlineInputBorder(borderSide:BorderSide(color: Colors.white), ),
                              hintText: "Please enter your Nurse's name",
                              hintStyle: TextStyle(color: Colors.white38),
                              labelText: "Nurse Name",
                              labelStyle:
                                  TextStyle(color: Colors.white), // For the label
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff58c9b0)),
                              ),
                            ),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Please enter your Nurse name";
                              }
                            },
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          SizedBox(
                            height: 50,
                            width: 150,
                            child: ElevatedButton(
                              
                              style: ElevatedButton.styleFrom(
                              
                                  backgroundColor: Color(0xff58c9b0),
                                  textStyle: const TextStyle(fontSize: 18)),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  String folderName = nameController.text;
                                  String folderPath = await createFolder(
                                      folderName,
                                      nameController.text,
                                      emailIdController.text,
                                      genderController.text,
                                      fieldAController.text);
                          
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Profile Created")));
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => AudioPlayerPage(
                                            selectedFolder: folderName)),
                                  );
                                }
                              },
                              child:const Text("Create Profile" ,textAlign: TextAlign.center , style: TextStyle(fontSize: 14),),
                            ),
                          ),
                        ],
                      )
                      
                      )
                      ),
            ],
          ),
        
        ));
  }
}
