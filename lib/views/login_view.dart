import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import '../constants/routes.dart';
import '../utilities/show_error_dialog.dart';

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
                devtools.log('Credential: $credential');
                final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false) {
                  // user's email is verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  // email is not verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on FirebaseAuthException catch (e) {
                // FirebaseAuthException is runtime type of e
                if (e.code == 'user-not-found') {
                  await showErrorDialog(
                    context,
                    'No user found for that email',
                  );
                } else if (e.code == 'wrong-password') {
                  await showErrorDialog(
                    context,
                    'Wrong password provided',
                  );
                } else {
                  await showErrorDialog(
                    context,
                    'Error : ${e.code}',
                  );
                }
              } catch (e) {
                await showErrorDialog(
                  context,
                  'Some other Error, contact Developer',
                );
                devtools.log(e.toString());
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Not registered? Register here!')),
        ],
      ),
    );
  }
}
