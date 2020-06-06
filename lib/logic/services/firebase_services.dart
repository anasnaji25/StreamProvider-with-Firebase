import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';

class FirebaseServices {
  Firestore _fireStoreDataBase = Firestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


}
