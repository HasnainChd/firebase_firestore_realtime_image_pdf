import 'package:firebase_1/UI/Auth/login_screen.dart';
import 'package:firebase_1/UI/add_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../Utils/toast_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final reference = FirebaseDatabase.instance.ref('Post');

  final searchFilterController = TextEditingController();
  final editDataController = TextEditingController();

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
        title: const Text('Posts'),
      ),
      body: Column(
        children: [
          //search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
            child: TextField(
              controller: searchFilterController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'search'),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            //showing data from realtime database
            child: FirebaseAnimatedList(
              query: reference,
              itemBuilder: (context, snapshot, animation, int index) {
                final title = snapshot
                    .child('Name')
                    .value
                    .toString();
                if (searchFilterController.text.isEmpty) {
                  return Card(
                    color: Colors.purple.shade100,
                    child: ListTile(
                      title: Text(snapshot
                          .child('Name')
                          .value
                          .toString()),
                      subtitle: Text(snapshot
                          .child('id')
                          .value
                          .toString()),
                      trailing: PopupMenuButton(
                          itemBuilder: (BuildContext context) =>
                          [
                            PopupMenuItem(
                              value: 'Edit',
                              child: const Text('Edit'),
                              onTap: () {
                                showMyDialog(
                                  title,
                                  snapshot
                                      .child('id')
                                      .value
                                      .toString(),
                                );
                              },
                            ),
                            PopupMenuItem(
                              value: 'Delete',
                              child: const Text('Delete'),
                              onTap: () {
                                reference
                                    .child(snapshot
                                    .child('id')
                                    .value
                                    .toString())
                                    .remove();
                              },
                            ),
                          ]),
                    ),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(searchFilterController.text.toLowerCase())) {
                  return Card(
                    color: Colors.purple.shade100,
                    child: ListTile(
                      title: Text(snapshot
                          .child('Name')
                          .value
                          .toString(),),
                      subtitle: Text(snapshot
                          .child('id')
                          .value
                          .toString(),),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: const Text('Add'),
      ),
    );
  }

  Future<void> showMyDialog(String name, String id) {
    editDataController.text = name;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: editDataController,
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
                      .child(id)
                      .update(({'Name': editDataController.text}))
                      .then((value) {
                  Utils.toastMessage('Updated Successfully');
                  }).onError((error, stackTrace) {
                  Utils.toastMessage(error.toString());
                  });
                },
                child: const Text('Update'),),
            ],
          );
        });
  }
}

//Search and Stream Builder
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: TextField(
// onChanged: (value) {
// setState(() {});
// },
// controller: searchFilterController,
// decoration: const InputDecoration(
// hintText: 'Search',
// border: OutlineInputBorder(),
// ),
// ),
// ),
// Expanded(
// child: StreamBuilder(
// stream: reference.onValue,
// builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
// if (!snapshot.hasData) {
// return const Center(
// child: Text('No Data Found'),
// );
// } else {
// Map<dynamic, dynamic> map =
// snapshot.data!.snapshot.value as dynamic;
// List<dynamic> list = [];
// list.clear();
// list = map.values.toList();
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context, index) {
// final title = list[index]['Name'];
// if (searchFilterController.text.isEmpty) {
// return Card(
// color: Colors.limeAccent,
// child: ListTile(
// title: Text(list[index]['Name']),
// subtitle: Text(list[index]['id'].toString()),
// ),
// );
// } else if (title.toString().toLowerCase().contains(
// searchFilterController.text.toLowerCase())) {
// return Card(
// color: Colors.limeAccent,
// child: ListTile(
// title: Text(list[index]['Name']),
// subtitle: Text(list[index]['id'].toString()),
// ),
// );
// } else {
// return const SizedBox();
// }
// });
// }
// },
// ),
// )
