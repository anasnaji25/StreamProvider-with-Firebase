import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterstreamprovider/logic/model/image_model.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthenticateUser extends StatefulWidget {
  @override
  _AuthenticateUserState createState() => _AuthenticateUserState();
}

class _AuthenticateUserState extends State<AuthenticateUser> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Firebase Auth'),
      ),
      body: Container(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 7,
                  right: MediaQuery.of(context).size.width / 3,
                ),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 4.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 7,
                  right: MediaQuery.of(context).size.width / 3,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'enter password',
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.indigo,
                        width: 4.0,
                      ),
                    ),
                  ),
                  controller: passwordController,
                  keyboardType: TextInputType.number,
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    registerUser();
                  }
                },
                color: Colors.grey[500],
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerUser() async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ))
        .user;
    if (user != null) {
      setState(() {
        print(user.uid);
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ViewImage(),
        ),
      );
    }
  }
}

class ViewImage extends StatefulWidget {
  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {


  CollectionReference collectionReference;
  List<DocumentSnapshot> imageList;
  StreamSubscription<QuerySnapshot> subscription;

  @override
  void initState() {
    super.initState();
    collectionReference = Firestore.instance.collection('images');
    subscription = collectionReference.snapshots().listen((data) {
      setState(() {
        imageList = data.documents;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: imageList == null ? CircularProgressIndicator() :  ListView.builder(
        itemCount: imageList.length,
        itemBuilder: (_, int index) => Padding(
          padding: EdgeInsets.all(10.0),
          child: Image.network(imageList[index]['download_url']),
        ),
      ),
    );
  }
}