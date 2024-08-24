import 'package:firebase_1/UI/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Utils/toast_screen.dart';
import '../Widgets/custom_button.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId;

  const VerificationScreen({super.key, required this.verificationId});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final verificationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: verificationController,
              decoration: const InputDecoration(
                hintText: 'Enter 6 digit code',
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
                text: 'Verify',
                isLoading: isLoading,
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });

                  final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: verificationController.text,
                  );

                  try {
                    await auth.signInWithCredential(credential).then((value) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    }).onError((error, stackTrace) {
                      Utils.toastMessage(error.toString());
                      setState(() {
                        isLoading = false;
                      });
                    });
                  } catch (e) {
                    Utils.toastMessage(e.toString());
                    setState(() {
                      isLoading = false;
                    });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
