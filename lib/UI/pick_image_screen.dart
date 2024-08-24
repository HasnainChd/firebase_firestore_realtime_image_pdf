import 'dart:io';
import 'package:firebase_1/Widgets/custom_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../Utils/toast_screen.dart';

class PickImageScreen extends StatefulWidget {
  const PickImageScreen({super.key});

  @override
  State<PickImageScreen> createState() => _PickImageScreenState();
}

class _PickImageScreenState extends State<PickImageScreen> {
  DatabaseReference reference = FirebaseDatabase.instance.ref('Post');

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  bool isLoading = false;
  File? image;
  final picker = ImagePicker();

  Future<void> getImageFromGallery() async {
    setState(() {
      isLoading = true;
    });
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
      setState(() {
        isLoading = false;
      });
    } else {
      Utils.toastMessage('No image Picked');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('pick Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getImageFromGallery();
                },
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  height: 150,
                  width: 200,
                  child: image != null
                      ? Image.file(image!.absolute)
                      : const Icon(
                          Icons.image,
                          size: 40,
                        ),
                ), //container
              ), //inkWell
            ), //center
            const SizedBox(height: 20),
            CustomButton(
                text: 'Upload',
                isLoading: isLoading,
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  firebase_storage.Reference ref = firebase_storage
                      .FirebaseStorage.instance
                      .ref('/Folder' + '/nain');
                  firebase_storage.UploadTask uploadTask =
                      ref.putFile(image!.absolute);

                  Future.value(uploadTask).then((value) async {
                    final newUrl = await ref.getDownloadURL();
                    reference
                        .child('1')
                        .set(({'id': 'unique', 'title': newUrl.toString()}))
                        .then((value) {
                      Utils.toastMessage('Upload Successful');
                      setState(() {
                        isLoading = false;
                      });
                    }).onError((error, stack) {
                      Utils.toastMessage(error.toString());
                      setState(() {
                        isLoading = false;
                      });
                    });
                  });
                }),
          ],
        ),
      ),
    );
  }
}
