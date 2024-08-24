import 'package:firebase_1/Widgets/custom_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Utils/toast_screen.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool isLoading = false;
  final postController = TextEditingController();

  final reference = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: postController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter whats in your mind',
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
                text: 'Add post',
                isLoading: isLoading,
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  reference.child(id).set({
                    "Name": postController.text,
                    'id': id,
                  }).then((value) {
                    Utils.toastMessage('Post Added');
                    postController.clear();
                    setState(() {
                      isLoading = false;
                    });
                  }).onError((error, stackTrace) {
                    Utils.toastMessage(error.toString());
                    setState(() {
                      isLoading = false;
                    });
                  });
                }),
          ],
        ),
      ),
    );
  }
}
