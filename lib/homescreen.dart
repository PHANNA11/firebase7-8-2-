// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase1/login_screen.dart';
import 'package:firebase1/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference usersdata =
      FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(children: [
            ListTile(
              title: const Text('LogOut'),
              trailing: IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false);
                    });
                  },
                  icon: const Icon(Icons.logout_outlined)),
            )
          ]),
        ),
      ),
      appBar: AppBar(title: const Text('HomeScreen')),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersdata.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // ignore: prefer_const_constructors
            return Center(
              child: const Icon(
                Icons.info,
                color: Colors.red,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(
              child: CircularProgressIndicator(),
            );
          else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var temp = snapshot.data!.docs[index];
                  return Card(
                    child: ListTile(
                      title: Text(temp['name']),
                      trailing: IconButton(
                          onPressed: () {
                            deleteUser(temp.id);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ),
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addUserData(UserModel(
              id: DateTime.now().microsecond, name: 'Sokny', age: 23));
        },
        child: const Text('Add+'),
      ),
    );
  }

  Future<void> updateUser(String docId, UserModel userUpdate) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .set(userUpdate.toJson());
  }

  Future<void> deleteUser(String docId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .delete()
        .then((value) {
      setState(() {
        print('Delete success');
      });
    });
  }

  Future<void> addUserData(UserModel userModel) async {
    await FirebaseFirestore.instance
        .collection('users')
        .add(userModel.toJson())
        .then((value) => print('Add User Success'));
  }
}
