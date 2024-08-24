import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_1/Utils/toast_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String,dynamic>> pdfData=[];

  Future<void> pickFile() async {
    try {
      final pickFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc'],
      );

      if (pickFile != null) {
        String fileName = pickFile.files[0].name;
        File file = File(pickFile.files[0].path!);

        final downloadLink = await uploadPdf(fileName, file);

        await _firestore.collection('pdfs').add({
          'name': fileName,
          'url': downloadLink,
        }).then((value) {

          Utils.toastMessage('Uploaded Successfully');

        }).onError((error, stack) {

          Utils.toastMessage(error.toString());
          print('error ${error.toString()}');

        });
      }
    }catch(e){
      print(e.toString());
    }
  }


  Future<String> uploadPdf(String fileName, File file) async {
    final reference =
    FirebaseStorage.instance.ref().child('pdfs/$fileName.pdf');

    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {});

    final downloadLink = await reference.getDownloadURL();
    return downloadLink;
  }

 void  getPdf() async{
    final results = await _firestore.collection('pdfs').get();
    pdfData=results.docs.map((e)=>e.data()).toList();

  }
  
}
