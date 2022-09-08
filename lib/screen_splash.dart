import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socio/colors.dart';
import 'package:socio/login.dart';
import 'package:socio/router.dart';
import 'package:socio/screen_home.dart';
import 'package:socio/shared_common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Authentication.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  User? user;

  timerToGo(){
    return Timer(const Duration(seconds: 5), changePage);
  }


  void changePage(){
    if (kDebugMode) {
      print('Changing page');
    }
    prefLoad().then((value) {
      setState(() {
        if (value != null) {
          pushAndRemove(context, HomeScreen());
        } else if(user != null){
          pushAndRemove(context, HomeScreen());
        } else{
          pushPage(context, LoginScreen());
        }
      });
    });

  }

  @override
  void initState() {
    super.initState();
   // user  = FirebaseAuth.instance.currentUser;
    Authentication.initializeFirebase(context: context);
    timerToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: Stack(
        children: [
         Align(
           alignment: Alignment.center,
           child: Image.asset(
               'assets/images/icon.png',
               width: 50.0,
               height: 50.0,
             ),

         ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 50.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Socio', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, ),),
                  const SizedBox(width: 5.0,),
                  Image.asset(
                    'assets/images/icon.png',
                    width: 20.0,
                    height: 20.0,
                  ),
                ],
              ),
            )
          )
        ],
      )
    );
  }
}
