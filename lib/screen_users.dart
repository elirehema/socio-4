import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'model/model_user.dart';

class ScreenUsers extends StatefulWidget{

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<ScreenUsers>{

  late Future<List<UserResponse>> users;
  @override
  void initState() {
      users =  fetchUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        elevation: 0,
      ),
      body: Container(
        child: FutureBuilder<List<UserResponse>>(
          future: users,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return  ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    UserResponse u = snapshot.data![index];
                   return ListTile(
                      tileColor: index%2==0?Colors.grey[100]:Colors.white,
                      leading:   Icon(Icons.person),
                      title: Text('${u.firstName} ${u.lastName}'),
                      trailing: Text("${u.email}"),
                      subtitle: Text('${u.type}'),
                    );
                  }
              );
            }else if(snapshot.hasError){
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        )
      )
      );
  }


}

Future<List<UserResponse>> fetchUsers() async{
  var sharedPreferences = await SharedPreferences.getInstance();
  String? accessToken = sharedPreferences.getString("ACCESS_TOKEN");
  Map<String,String> requestHeaders = {
    'Content-Type':'application/json',
    'Accept':'application/json',
    'Authorization':'Bearer '+ accessToken!
  };
  final response = await http.get(Uri.parse("http://192.168.43.214:8081/auth-api/users"), headers: requestHeaders);
  print(response.body);
  List<UserResponse> list = json.decode(response.body).map<UserResponse>((data)=> UserResponse.fromJson(data)).toList();

  return list;
}