import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ruvu/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ruvu/screens/home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ruvu App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                return const HomePage();
              } else {
                return LoginScreen();
              }
            }
          },
        ),
    );
  }
}
