import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/auth_services.dart';
import 'package:learningdart/views/login_view.dart';
import 'package:learningdart/views/notes_view.dart';
import 'package:learningdart/views/register_view.dart';
import 'package:learningdart/views/verify_email_view.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtools show log;

void main() async {
  // There is issue that if we want to use firebase in our app then we need to initialize it first
  // So it would be kind of redundant to initialize it in every page, hence we initialize it in the main function
  // using binding technique => WidgetsBinding acts as glue between the widgets layer and the Flutter engine.
  WidgetsFlutterBinding.ensureInitialized();
  // Now after the it is binded, then only our widget should build, for it we use FutureBuilder, which kind of
  // gives callback when the future is completed, and after getting its result we can build our widget accordingly
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: ((context) => const NotesView()),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                devtools.log("You are verified");
                return const NotesView();
              } else {
                devtools.log("You are not verified");
                return const VerifyEmailView();
              }
            } else {
              devtools.log("You are not logged in");
              return const LoginView();
            }
          // We can't push something in the future builder, that's why error is coming
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => const VerifyEmailView(),
          //   ),
          // );
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
