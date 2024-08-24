import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Utils{

  static void toastMessage(String message){
     Fluttertoast.showToast(msg: message,
     timeInSecForIosWeb: 2,
     textColor: Colors.white,
     backgroundColor: Colors.red,);
  }
  static void snackBar(BuildContext context,String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.red,
        content: Text(message))

    );
  }
}