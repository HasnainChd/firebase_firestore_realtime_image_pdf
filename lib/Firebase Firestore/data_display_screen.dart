import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_1/UI/Auth/login_screen.dart';
import 'package:firebase_1/Utils/toast_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'data_adding_screen.dart';

class DataDisplayScreen extends StatefulWidget {
  const DataDisplayScreen({super.key});

  @override
  State<DataDisplayScreen> createState() => _DataDisplayScreenState();
}

class _DataDisplayScreenState extends State<DataDisplayScreen> {
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();

  CollectionReference reference =
      FirebaseFirestore.instance.collection('users');
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                });
              },
              icon: const Icon(Icons.logout)),
        ],
        title: const Text('FireStore Data'),
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream: fireStore,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Text('something went wrong');
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.purpleAccent,
                        child: ListTile(
                          title: Text(snapshot.data!.docs[index]['title']),
                          subtitle:
                              Text(snapshot.data!.docs[index]['id'].toString()),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) {
                              final title = snapshot.data!.docs[index]['title'];
                              final id =
                                  snapshot.data!.docs[index]['id'].toString();
                              return [
                                PopupMenuItem(
                                  value: 'Edit',
                                  child: const Text('Edit'),
                                  onTap: () {
                                    showMyDialog(title, id);
                                  },
                                ),
                                PopupMenuItem(
                                  value: 'Delete',
                                  child: const Text('Delete'),
                                  onTap: () {
                                    reference.doc(id).delete();
                                  },
                                )
                              ];
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddFireStoreDataScreen()));
        },
        child: const Text('Add'),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: editController,
            ),
            title: const Text('Update'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    reference
                        .doc(id)
                        .update(({
                          'title': editController.text,
                        }))
                        .then((value) {
                      Utils.toastMessage('Updated successfully');
                    }).onError((error, stack) {
                      Utils.toastMessage(error.toString());
                    });
                  },
                  child: const Text('Update')),
            ],
          );
        });
  }
}
