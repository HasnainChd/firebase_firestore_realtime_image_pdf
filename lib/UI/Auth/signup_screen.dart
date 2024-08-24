import 'package:firebase_1/UI/Auth/login_screen.dart';
import 'package:firebase_1/UI/home_screen.dart';
import 'package:firebase_1/Utils/toast_screen.dart';
import 'package:firebase_1/Widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void signUp(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return Utils.toastMessage('please enter required fields');
    } else {
      try {
        auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          Utils.toastMessage('Congrats Account Created Successfully');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }).onError((error, stackTrace) {
          Utils.toastMessage(error.toString());
        });
      } catch (e) {
        Utils.toastMessage(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline),
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: 'Password',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
                color: Colors.deepPurple,
                text: 'Login',
                onTap: () {
                  signUp(emailController.text, passwordController.text);
                }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Login'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
