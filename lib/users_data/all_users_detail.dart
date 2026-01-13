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
  // Removed docIds list as we will use FutureBuilder's snapshot directly.

  // get DocIds... This now returns the list of IDs.
  Future<List<String>> getDocIds() async {
    final List<String> ids = [];
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then(
          (snapshot) => {
            for (var document in snapshot.docs)
              {ids.add(document.reference.id)},
          },
        );
    return ids;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Users", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<String>>(
                  future: getDocIds(),
                  builder: (context, snapshot) {
                    // Show loading indicator while fetching data
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Show error if any
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    
                    // Check if data is available
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No users found."));
                    }

                    // Build the list with data from snapshot
                    final docIds = snapshot.data!;
                    return ListView.builder(
                      itemCount: docIds.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: GetUserData(docId: docIds[index]),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}