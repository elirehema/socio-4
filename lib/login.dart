
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:socio/facebook_sign_in_button.dart';

import 'Authentication.dart';
import 'google_sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var nameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  bool visibility = false;
  bool _obscureText = true;
  bool _validate = false;

  @override
  void initState() {
    super.initState();
   
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: widgetTheme.themeMode().toggleButtonColorGrey,
     
      body: Container(
        margin: const EdgeInsets.only(top: 40.0),
        padding: const EdgeInsets.symmetric(horizontal: 45.0),
        child:
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/icon.png',
                  width: 100.0,
                  height: 100.0,
                ),

                const SizedBox(
                  height: 20.0,
                ),
                const Spacer(),
                FutureBuilder(
                  future: Authentication.initializeFirebase(context: context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error initializing Firebase');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return GoogleSignInButton();
                    }
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.orange,
                      ),
                    );
                  },
                ),
                FutureBuilder(
                  future: Authentication.initializeFirebase(context: context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error initializing Firebase');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return FacebookSignInButton();
                    }
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blueAccent,
                      ),
                    );
                  },
                ),

                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(right: 15, left: 15, bottom: 32),
                  child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'By signing up to create an account I accept AzanSocio Term of Services and Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blueGrey, fontSize: 14.0),
                    ),
                  ),
                ),
              ],
            ),

      ),
    );
  }
}
