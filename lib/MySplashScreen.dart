import 'package:dog_breed_recognizer/HomePage.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
//import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      navigator: HomeScreen(),
      title: Text(
        'Dog Breed Identifier',
        style: TextStyle(
            fontSize: 40, fontWeight: FontWeight.bold, color: Colors.pink),
      ),
      durationInSeconds: 5,
      logo: Image.asset('assets/dog.png'),
      logoSize: 180,
      loadingText: Text(
        "From Sathush",
        style: TextStyle(fontSize: 16, color: Colors.deepPurple),
      ),
      loaderColor: Colors.yellowAccent,
      backgroundColor: Colors.white,
      showLoader: true,
    );
  }
}
