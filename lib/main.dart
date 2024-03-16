import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onlycode/pages/Chat.dart';
import 'package:onlycode/pages/CompleteProfile.dart';
import 'package:onlycode/pages/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAdwHQSdtirv2JIvK1Ty8b5dNt7DTrfngw",
          appId: "1:197122844512:android:1e37905c72146e40e06005",
          messagingSenderId: "197122844512",
          projectId: "hackathon-hacked2"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/emotions',
      routes: {
        '/': (context) => const LoginPage(),
        '/profile': (context) => const CompleteProfile(),
        '/chat': (context) => const ChatScreen(),
      },
    );
  }
}
