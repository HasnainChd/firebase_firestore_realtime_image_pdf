import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_1/Widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../Utils/toast_screen.dart';

class AddFireStoreDataScreen extends StatefulWidget {
  const AddFireStoreDataScreen({super.key});

  @override
  State<AddFireStoreDataScreen> createState() => _AddFireStoreDataScreenState();
}

class _AddFireStoreDataScreenState extends State<AddFireStoreDataScreen> {
  bool isLoading = false;
  final dataController = TextEditingController();

  final fireStore = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to FireStore'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: dataController,
              maxLines: 5,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter whats in your mind'),
            ),
            const SizedBox(height: 30),
            CustomButton(
                text: 'Submit Data',
                isLoading: isLoading,
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  final id = DateTime.now().millisecondsSinceEpoch.toString();
                  fireStore.doc(id).set({
                    'title': dataController.text,
                    'id': id,
                  }).then((value) {
                    Utils.toastMessage('Data Added');
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
