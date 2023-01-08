import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // late keyword is when currently variable is not having any value but I promise that we will assign value to it later
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter Email Here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter Password Here',
            ),
          ),
          TextButton(
            onPressed: () async {
              // We need to use text editing controllers to get the text from the text fields
              // We can use the TextEditingController class to create a controller

              final email = _email.text;
              final password = _password.text;
              try {
                final credential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                print(credential);
              } on FirebaseAuthException catch (e) {
                // FirebaseAuthException is runtime type of e
                if (e.code == 'user-not-found') {
                  print('No user found for that email');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user');
                }
              } catch (e) {
                print('Some other Error');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/register',
                  (route) => false,
                );
              },
              child: const Text('Not registered? Register here!')),
        ],
      ),
    );
  }
}
