import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:game_on/screens/welcome.dart';
import 'package:game_on/screens/login.dart';
import 'package:game_on/screens/registration.dart';
import 'package:game_on/screens/chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  runApp(GameOn());
}

class GameOn extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game On',
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: Welcome.route,
      routes: {
        Welcome.route: (context)=>Welcome(),
        Login.route : (context)=>Login(),
        Registration.route : (context)=>Registration(),
        Chat.route : (context)=>Chat()
      }
    );
  }
}

