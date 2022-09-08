import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socio/colors.dart';
import 'package:socio/screen_home.dart';
import 'package:socio/shared_common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Authentication.dart';
import 'router.dart';
import 'package:http/http.dart' as http;
import 'model/model_google_auth.dart';


class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  late SharedPreferences preferences;

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 70,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(CustomColors.googleBackground),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 10.0)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          onPressed: () async {
            setState(() {
              _isSigningIn = true;
            });

            User? user =
                await Authentication.signInWithGoogle(context: context);

            if (user != null) {
              preferences = await SharedPreferences.getInstance();
              preferences.setBool('ISAUTHENICATED', true);
              preferences.setBool('ISGOOGLE', true);
              preferences.setBool('ISFB', false);
              preferences.setString('PHOTO_URL', user.photoURL!);
              String token = await FirebaseAuth.instance.currentUser!.getIdToken();

            //printWrapped(token);

              //print(user);
              var _googleAuthentication = {
                "displayName": user.displayName,
                "email": user.email,
                "emailVerified": true,
                "isAnonymous": false,
                "phoneNumber": null,
                "photoURL": user.photoURL
              };

              var _tokenRequest = {
                "token": token
              };

             var response = await requestAccessToken(_tokenRequest);
              var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
              print(decodedResponse);
             var accessToken = decodedResponse["accessToken"];
              preferences.setString('ACCESS_TOKEN', accessToken);

              GoogleAuthentication go = GoogleAuthentication.fromJson(_googleAuthentication);

              prefLogin(
                  id: user.uid,
                  name: user.displayName,
                  email: user.email,
                  photo: user.photoURL,
                  language: go.language,
                  langCode: go.languageCode);
              pushAndRemove(context, HomeScreen());
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: _isSigningIn
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Image(
                        image: AssetImage("assets/images/google_logo.png"),
                        height: 25.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}


Future<http.Response> requestAccessToken(Map<String, String> body){
  Map<String,String> requestHeaders = {
    'Content-Type':'application/json',
    'Accept':'application/json',
  };
  return http.post(Uri.parse("http://192.168.43.214:8081/auth-api/firebasetoken"),
      body: jsonEncode(body),
      headers: requestHeaders
  );
}
