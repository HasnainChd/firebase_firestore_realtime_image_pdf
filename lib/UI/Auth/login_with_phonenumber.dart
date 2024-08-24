import 'package:firebase_1/UI/verify_screen.dart';
import 'package:firebase_1/Utils/toast_screen.dart';
import 'package:firebase_1/Widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  final phoneNumberController = TextEditingController();

  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.phone,
              controller: phoneNumberController,
              decoration: const InputDecoration(
                hintText: '+92 123 456 789',
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
                text: 'Send OTP',
                isLoading: isLoading,
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  auth.verifyPhoneNumber(
                      phoneNumber: phoneNumberController.text,
                      verificationCompleted: (_) {},
                      verificationFailed: (e) {
                        Utils.toastMessage(e.toString());
                        setState(() {
                          isLoading = false;
                        });
                      },
                      codeSent: (String verificationId, int? token) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VerificationScreen(
                              verificationId: verificationId,
                            ),
                          ),
                        );
                      },
                      codeAutoRetrievalTimeout: (e) {
                        Utils.toastMessage(e.toString());
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
