import 'package:firebase_1/UI/Auth/login_with_phonenumber.dart';
import 'package:firebase_1/UI/Auth/signup_screen.dart';
import 'package:firebase_1/UI/home_screen.dart';
import 'package:firebase_1/Widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Utils/toast_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return Utils.snackBar(context, 'Please fill necessary fields');
    } else {
      try {
        setState(() {
          isLoading = true;
        });
        FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()));
          emailController.clear();
          passwordController.clear();
          setState(() {
            isLoading = false;
          });
        }).onError((error, stackTrace) {
          Utils.snackBar(context, error.toString());
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail_outline),
                  hintText: 'Email',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: 'Password',
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                        color: Colors.deepPurple,
                        text: 'Login',
                        isLoading: isLoading,
                        onTap: () {
                          login(emailController.text, passwordController.text);
                        }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginWithPhoneNumber(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.deepPurple),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.phone),
                          Padding(
                            padding: EdgeInsets.all(9.0),
                            child: Text('Login with Phone'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account '),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignUpScreen()));
                    },
                    child: const Text('Signup'),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
