import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/users_data/getUserData.dart';

class AllUsersDetail extends StatefulWidget {
  const AllUsersDetail({super.key});

  @override
  State<AllUsersDetail> createState() {
    return _AllUsersDetailsState();
  }
}

class _AllUsersDetailsState extends State<AllUsersDetail> {
  // Document Ids....
  final List<String> docIds = [];

  // get DocIds...
  Future getDocIds() async {
    docIds.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then(
          (snapshot) => {
            for (var document in snapshot.docs)
              {docIds.add(document.reference.id)},
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Users", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: docIds.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: GetUserData(docId: docIds[index]),
                        );
                      },
                    );
                  },
                  future: getDocIds(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}