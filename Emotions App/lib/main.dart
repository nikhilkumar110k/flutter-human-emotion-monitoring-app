import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onlycode/pages/Chat.dart';
import 'package:onlycode/pages/CompleteProfile.dart';
import 'package:onlycode/pages/LoginPage.dart';
import 'package:onlycode/pages/MoodsPage.dart';
import 'package:onlycode/pages/SignUp.dart';
import 'package:onlycode/pages/diary.dart';
import 'package:onlycode/pages/HomePage.dart';
import 'package:onlycode/pages/welcome_screens/screen1.dart';
import 'package:onlycode/pages/welcome_screens/screen2.dart';
import 'package:onlycode/pages/welcome_screens/screen3.dart';
import 'package:onlycode/pages/welcome_screens/screen4.dart';

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
      initialRoute: WelcomeScreen1.id,
      routes: {
        WelcomeScreen1.id: (context) => WelcomeScreen1(),
        WelcomeScreen2.id: (context) => WelcomeScreen2(),
        WelcomeScreen3.id: (context) => WelcomeScreen3(),
        WelcomeScreen4.id: (context) => WelcomeScreen4(),
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => HomePage(detectedEmotion: '-', detectedPercentage: 50),
        '/profile': (context) => const CompleteProfile(),
        '/chat': (context) => const ChatScreen(),
        '/diary': (context) =>  DiaryPage(),
        '/mood': (context) => const MoodsPage(
            barValues: [
              0.8,
              0.5,
              0.3,
              0.7
            ], detectedEmotion: '-', detectedPercentage: 50, )
      },
    );
  }
}
