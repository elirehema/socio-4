import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socio/router.dart';

import 'login.dart';

prefLogin({required var id, required var name, required var email, required var photo, required var language, required var langCode}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var _id = id;
  var _name = name;
  var _email = email;
  var _photo = photo;
  var _language = language;
  var _langCode = langCode;
  await preferences.setStringList('login', [_id, _name, _email, _photo, _language, _langCode]);
}

/* Save PIN ID after successful PIN request */
prefPinId(String key, String value) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString(key,value);
}

Future prefLoad() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getStringList('login');
}

saveAutoPlay({required bool autoPlay}) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var _videoAutoPlay = autoPlay;
  await preferences.setBool('autoPlay', _videoAutoPlay);
}

loadAutoPlay(String values) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  dynamic data = preferences.get(values);
  return data;
}

saveAutoLoop({required bool autoLoop}) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var _videoAutoPlay = autoLoop;
  await preferences.setBool('autoLoop', _videoAutoPlay);
}

loadAutoLoop(String values) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  dynamic data = preferences.get(values);
  return data;
}

saveIdCourse(String idCourse) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var _videoAutoPlay = idCourse;
  await preferences.setString('idCourse', _videoAutoPlay);
}

saveFavoritesCourse(String fav) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString('saveFavorite', fav);
}

Future loadFavoriteCourse() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('saveFavorite');
}


Future loadVerificationPinCodeId()async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('PIN_ID');
}
Future loadVerificationPhoneNumber()async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('PHONE_NUMBER');
}
Future loadVerificationEmail()async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('VERIFICATION_EMAIL');
}

void clearAndLogout(BuildContext context)async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();
  pushPage(context, LoginScreen());
}
