import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final String uid;
  User({ this.uid });
}

class FirebaseAuthenticationServices {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /*create user obj based on firebase user*/
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  /*auth change user stream*/
  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  /*register with email and password*/
  Future registerWithEmailAndPassword(String name,String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      /*create a new document for the user with the uid*/
      await DatabaseService(uid: user.uid).updateUserData(name,email,password);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final CollectionReference userCollection = Firestore.instance.collection('MyUsers');

  Future<void> updateUserData(String name, String email, String password) async {
    return await userCollection.document(uid).setData({
      'name': name,
      'email': email,
      'password': password,
    });
  }
}