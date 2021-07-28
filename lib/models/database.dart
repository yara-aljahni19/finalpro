

import 'package:cloud_firestore/cloud_firestore.dart';

class database {

  final CollectionReference List = FirebaseFirestore.instance.collection('User_Info');
  Future<void> createUserData(
      String name, String email, String password,String uid) async {

    return await List.doc(uid).set({'name': name, 'email':email, 'password':password});

  }




}