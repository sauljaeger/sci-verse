import 'package:flutter/material.dart';
import 'package:sciverse/components/theme.dart';
import 'package:sciverse/pages/loginpage.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginpage()));
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppData.splash,
      body: Center(
        child: Image.asset('assets/sciverse_logo1.png', width: 300,height: 300,),
      ),
    );
  }
}
