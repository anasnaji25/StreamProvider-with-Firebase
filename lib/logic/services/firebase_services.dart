import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';

class FirebaseServices {
  Firestore _fireStoreDataBase = Firestore.instance;

  Stream<List<UserModel>> getUserList() {
    return _fireStoreDataBase.collection('user')
        .snapshots()
        .map((snapShot) => snapShot.documents
        .map((document) => UserModel.fromJson(document.data))
        .toList());
  }

  Stream<List<UserModel>> getImageList() {
    return _fireStoreDataBase.collection('images')
        .snapshots()
        .map((snapShot) => snapShot.documents
        .map((document) => UserModel.fromJson(document.data))
        .toList());
  }

  addUser(){
    var addUserData = Map<String,dynamic>();
    addUserData['name'] = "Andrew Holder";
    addUserData['age'] = "31yrs";
    return _fireStoreDataBase.collection('user').document('user_03').setData(addUserData);
  }
}
