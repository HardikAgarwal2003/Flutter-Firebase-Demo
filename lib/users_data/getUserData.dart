import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserData extends StatelessWidget {
  const GetUserData({super.key, required this.docId});

  final String docId;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder(
      future: users.doc(docId).get(),
      builder: ((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data= snapshot.data!.data() as Map<String, dynamic>;
          return Text(" ${data["First Name"]}");
        }
        return Text("Loading...");
      }),
    );
  }
}
