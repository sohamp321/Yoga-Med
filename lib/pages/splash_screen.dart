import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'audio_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds:  3) , () async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? existingUser = prefs.getString('selectedFolder');

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AudioPlayer(),
          ));

      if (existingUser != null && existingUser.isNotEmpty) {

      } else {
        print("This app is unpopulated");
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => const CreateProfile()),
        // );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff1A1A26),
        child: Image(image: AssetImage('assets/images/splash-screen.png')),
        height: MediaQuery.of(context).size.height ,
      ),
    );
  }
}