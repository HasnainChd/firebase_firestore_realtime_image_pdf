import 'package:firebase_1/FirebaseServices/splash_services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices= SplashServices();
  @override
  void initState() {
    splashServices.login(context);// TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const  Scaffold(
      body: Center(child: Text('Splash Screen')),
    );
  }
}




