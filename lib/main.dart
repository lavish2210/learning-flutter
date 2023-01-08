import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/views/login_view.dart';
import 'package:learningdart/views/register_view.dart';
import 'package:learningdart/views/verify_email_view.dart';
import 'firebase_options.dart';

void main() async {
  // There is issue that if we want to use firebase in our app then we need to initialize it first
  // So it would be kind of redundant to initialize it in every page, hence we initialize it in the main function
  // using binding technique => WidgetsBinding acts as glue between the widgets layer and the Flutter engine.
  WidgetsFlutterBinding.ensureInitialized();
  // Now after the it is binded, then only our widget should build, for it we use FutureBuilder, which kind of
  // gives callback when the future is completed, and after getting its result we can build our widget accordingly
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                print("You are verified");
              } else {
                print("You are not verified");
                return const VerifyEmailView();
              }
            } else {
              print("You are not logged in");
              return const LoginView();
            }
            return Scaffold(
              appBar: AppBar(
                title: const Text('Aise Hi Page'),
              ),
              body: const Center(
                child: Text('Done'),
              ),
            );
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
