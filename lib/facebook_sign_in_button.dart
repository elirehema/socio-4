import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:socio/model/model_facebook_auth.dart';
import 'package:socio/screen_home.dart';
import 'package:socio/shared_common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Authentication.dart';
import 'router.dart';
import 'model/model_google_auth.dart';
import 'package:http/http.dart' as http;

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

class FacebookSignInButton extends StatefulWidget {
  @override
  _FacebookSignInButtonState createState() => _FacebookSignInButtonState();
}

class _FacebookSignInButtonState extends State<FacebookSignInButton> {
  bool _isSigningIn = false;
  late SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 70,
        child:  SignInButton(
          Buttons.Facebook,
          text: 'Login with Facebook',

          onPressed: () async {
            setState(() {
              _isSigningIn = true;
            });

            UserCredential ? user =
            await Authentication.signInWithFacebook();

            if (user != null) {
              preferences = await SharedPreferences.getInstance();


              //print(user);
              LinkedHashMap<Object?,Object?> profileImage = user.additionalUserInfo!.profile!['picture'];
               Object? data = profileImage["data"];
              Map<String, dynamic> stringfied = jsonDecode(jsonEncode(data));
              FacebookAuthentication authentication = FacebookAuthentication.fromJson(stringfied);
              String token = await FirebaseAuth.instance.currentUser!.getIdToken();

              printWrapped(token);

              print(authentication.toString());
              var _googleAuthentication = {
                "displayName": user.user?.displayName,
                "email": user.user?.email,
                "emailVerified": true,
                "isAnonymous": false,
                "phoneNumber": null,
                "photoURL": authentication.url
              };
              var _tokenRequest = {
                "token": token
              };
              var response = await requestAccessToken(_tokenRequest);
              var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
              var accessToken = decodedResponse["accessToken"];
              preferences.setString('ACCESS_TOKEN', accessToken);

              preferences.setBool('ISAUTHENICATED', true);
              preferences.setBool('ISGOOGLE', false);
              preferences.setBool('ISFB', true);
              preferences.setString('PHOTO_URL', authentication.url);



              GoogleAuthentication go = GoogleAuthentication.fromJson(_googleAuthentication);

              prefLogin(
                  id: user.user?.uid,
                  name: user.user?.displayName,
                  email: user.user?.email,
                  photo: authentication.url,
                  language: go.language,
                  langCode: go.languageCode);
              pushAndRemove(context, HomeScreen());
            }
          },
        )
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
      body:  jsonEncode(body),
      headers: requestHeaders
  );
}
