// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:developer' as dev;

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
                    child: ExpansionTile(
                      leading: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(temp['profile']),
                        ),
                      ),
                      title: Text(temp['name']),
                      trailing: IconButton(
                          onPressed: () {
                            deleteUser(temp.id);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users/${temp.id}/address')
                              .snapshots(),
                          builder: (context, snap) {
                            var address = snap.data!.docs.toList()[0].data()
                                as Map<String, dynamic>;

                            if (snap.hasError)
                              return const Center(
                                child: Icon(
                                  Icons.info,
                                  color: Colors.red,
                                ),
                              );
                            else if (snap.connectionState ==
                                ConnectionState.waiting)
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            else {
                              if (snap.data != null) {
                                dev.log(snap.data!.docs.first.id.toString());
                                return Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: const CircleAvatar(
                                            child: Icon(Icons.location_city)),
                                        title: Text('City'.toUpperCase()),
                                        trailing:
                                            Text(address['city'].toString()),
                                      ),
                                      ListTile(
                                        leading: const CircleAvatar(
                                            child: Icon(Icons.streetview)),
                                        title: Text('Street'.toUpperCase()),
                                        trailing:
                                            Text(address['street'].toString()),
                                      ),
                                      ListTile(
                                        leading: const CircleAvatar(
                                            child: Icon(Icons.local_activity)),
                                        title: Text('Zipcode'.toUpperCase()),
                                        trailing:
                                            Text(address['zipcode'].toString()),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                const Center(
                                  child: SizedBox(),
                                );
                              }
                            }
                            return const CircularProgressIndicator();
                          },
                        )
                      ],
                    ),
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addUserData(UserModel(
              id: DateTime.now().microsecond,
              name: 'Sokny',
              age: 23,
              profile:
                  'https://imgs.search.brave.com/M6LO9DyazaKnTvmh9gfoVwy7bScd0C99UY9o5HFVq7I/rs:fit:1200:801:1/g:ce/aHR0cHM6Ly9zbS5t/YXNoYWJsZS5jb20v/dC9tYXNoYWJsZV9p/bi9uZXdzL2MvY29u/c3RhbnRseS9jb25z/dGFudGx5LXN0cmVz/c2VkLWF0LXdvcmst/aXQtbWlnaHQtYWN0/dWFsbHktYmUtY2hh/bmdpbmcteW9fY3F2/My4xMjAwLmpwZw',
              address: Address.fromJson(
                  {'city': 'Phnom Penh', 'street': 'Lek5', 'zipcode': 32365})));
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
