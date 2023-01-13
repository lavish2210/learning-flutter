import 'package:flutter/material.dart';
import 'package:learningdart/services/auth/auth_exceptions.dart';
import 'package:learningdart/services/auth/auth_services.dart';
import 'package:learningdart/utilities/show_error_dialog.dart';
import '../constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
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
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Password provided is too weak',
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  'Account already exists for that email',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'Invalid Email Address',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Failed to register',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Already have an account? Login here')),
        ],
      ),
    );
  }
}
