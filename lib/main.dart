import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterstreamprovider/logic/model/user_model.dart';
import 'package:flutterstreamprovider/logic/services/firebase_services.dart';
import 'package:provider/provider.dart';
import 'screen/authenticate_user.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseServices firebaseServices = FirebaseServices();

    return MaterialApp(
      home: StreamProvider(
        create: (BuildContext context) => firebaseServices.getUserList(),
        child: ViewUserPage(),
      ),
    );
  }
}

class ViewUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List userList = Provider.of<List<UserModel>>(context);
    FirebaseServices firebaseServices = FirebaseServices();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Stream Provider'),
      ),
      body: userList == null ? CircularProgressIndicator() :  ListView.builder(
        itemCount: userList.length,
        itemBuilder: (_, int index) => Padding(
          padding: EdgeInsets.all(10.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
            ),
            title: Text(
              userList[index].name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
            subtitle: Text(
              userList[index].age,
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          firebaseServices.addUser();
        },
        backgroundColor: Colors.amber,
      ),
    );
  }
}