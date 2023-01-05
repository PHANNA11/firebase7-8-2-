// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase1/login_screen.dart';
import 'package:firebase1/update_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> docsId = [];
  void getDocumentID() async {
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          docsId.add(element.reference.id);
          print(element.reference.id);
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocumentID();
    //  print(docsId);
  }

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
      body: ListView.builder(
        itemCount: docsId.length,
        itemBuilder: (context, index) {
          CollectionReference usersdata =
              FirebaseFirestore.instance.collection('users');
          return FutureBuilder<DocumentSnapshot>(
            future: usersdata.doc(docsId[index]).get(),
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
                var data = snapshot.data;
                return data == null
                    ? const Center(
                        child: Text('No data...'),
                      )
                    : Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateScreen(user: {
                                    'id': data['id'],
                                    'name': data['name'],
                                    'age': data['age']
                                  }),
                                ));
                          },
                          onLongPress: () {
                            updateUser(docsId[index], {
                              'id': data['id'],
                              'name': 'Dalin',
                              'age': data['age']
                            });
                          },
                          title: Text(data['name'].toString()),
                          trailing: IconButton(
                              onPressed: () {
                                deleteUser(docsId[index]);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ),
                      );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addUserData(
              {'id': DateTime.now().microsecond, 'name': 'Sokny', 'age': 23});
        },
        child: const Text('Add+'),
      ),
    );
  }

  Future<void> updateUser(String docId, Map<String, dynamic> userUpdate) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .set(userUpdate);
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

  Future<void> addUserData(Map<String, dynamic> userData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .add(userData)
        .then((value) => print('Add User Success'));
  }
}
