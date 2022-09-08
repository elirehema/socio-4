
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socio/Authentication.dart';
import 'package:socio/colors.dart';
import 'package:http/http.dart' as http;
import 'package:socio/router.dart';
import 'package:socio/screen_users.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreeState createState()=> _HomeScreeState();
}
class _HomeScreeState extends State<HomeScreen>{
  late SharedPreferences sharedPreferences;
  String _profileImage = "";
  List<Contact> contacts = [];

  _HomeScreeState(){
    _profileUrl().then((value) => {
      _profileImage = value!
    });
    _flutterContacts().then((value) => {
      contacts = value!
    });

  }
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        backgroundColor: CustomColors.blueBackground,
        actions: [
          Container(
              padding: EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child:  FadeInImage.assetNetwork(
                  image: "${_profileImage.trim()}" ,
                  placeholder: 'assets/images/icon.png',
                  fit: BoxFit.contain,
                  width: 45.0,
                  height: 55.0,
                  imageErrorBuilder:  (context, error, stackTrace) {
                    return   Image.asset(
                      'assets/images/icon.png',
                      fit: BoxFit.fitWidth,
                      width: 45.0,
                      height: 55.0,

                    );
                  },),
              )),
        ],
      ),
      body: (contacts) == null ? Center(child: CircularProgressIndicator())
          : ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: contacts.length,
          itemBuilder: (BuildContext context, int index) {
            Uint8List? image = contacts[index].photo;
            String num = (contacts[index].phones.isNotEmpty) ? (contacts[index].phones.first.number) : "0000-000-000";
            return ListTile(
              tileColor: index%2==0?Colors.grey[100]:Colors.white,
              leading: (contacts[index].photo == null)
                  ? const CircleAvatar(child: Icon(Icons.person))
                  : CircleAvatar(backgroundImage: MemoryImage(image!)),
              title: Text('${contacts[index].name.first} ${contacts[index].name.last}'),
              trailing: Text("${contacts[index].emails.length>0 ? contacts[index].emails.first.address : ""}"),
              subtitle: Text(num),
            );
          }
      ),

      floatingActionButton: Wrap( //will break to another line on overflow
        direction: Axis.vertical, //use vertical to show  on vertical axis
        children: <Widget>[
          Container(
              margin:const EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: () async{
                  //action code for button 1
                  pushPageReplacement(context, ScreenUsers());
                },
                child: const Icon(Icons.add),
              )
          ), //button first

          Container(
              margin:EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: (){
                  Share.share('Hello Welcome to Azan Socio app www.azansocio.app/'+getRandomString(15)+"=", subject: 'Welcome Message');
                },
                backgroundColor: Colors.deepPurpleAccent,
                child: Icon(Icons.share),
              )
          ), // button second

          Container(
              margin:EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: (){
                  Authentication.signOut(context: context);
                },
                backgroundColor: CustomColors.redColor,
                child: const Icon(Icons.power_settings_new_outlined),
              )
          ), // button third

          // Add more buttons here
        ],
      ),
      /**floatingActionButton: FloatingActionButton(
        onPressed: () async {
         Authentication.signOut(context: context);
        },
        backgroundColor: CustomColors.redColor,
        child: const Icon(Icons.power_settings_new_outlined),
      ),
      **/
    );
  }

  Future<String?> _profileUrl() async{
    sharedPreferences = await SharedPreferences.getInstance();
    User? user = FirebaseAuth.instance.currentUser;
    bool? isGoogle = sharedPreferences.getBool("ISGOOGLE");
    String? imageUrl = sharedPreferences.getString('PHOTO_URL');
    print(imageUrl!);
    return imageUrl;
  }

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


  /**
  Future<List<Contact>> _fetchAllContacts() async {
    List<Contact> contacts = await ContactsService.getContacts();

    return contacts;
  }
  **/

  Future<List<Contact>?> _flutterContacts() async{
    if (await FlutterContacts.requestPermission()) {
      // Get all contacts (lightly fetched)
      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);

      return contacts;
    }
  }

  Future<http.Response> requestForLogin() async{
    String? accessToken = sharedPreferences.getString("ACCESS_TOKEN");
    Map<String,String> requestHeaders = {
      'Content-Type':'application/json',
      'Accept':'application/json',
      'Authorization':'Bearer '+ accessToken!
    };
    return http.get(Uri.parse("http://192.168.43.214:8080/auth-api/users"), headers: requestHeaders);
  }

}