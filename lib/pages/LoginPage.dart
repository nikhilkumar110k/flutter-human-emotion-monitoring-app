import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlycode/pages/CompleteProfile.dart';
import 'package:onlycode/pages/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onlycode/User/UserModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email == "" || password == "") {
      const snackbar = SnackBar(content: Text("Please fill all the values"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      const snackbar = SnackBar(content: Text("Signup successful!"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      logiIn(email, password);
    }
  }

  logiIn(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      var snackbar = SnackBar(content: Text(ex.message.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
    if (credential != null) {
      String uid = credential.user!.uid;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);
      var snackbar = SnackBar(content: Text("Sucessfully made the login!"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Health Monitoring",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Enter the email",
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: "Enter the Password",
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    CircularProgressIndicator;
                    checkValues();
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Dont' have an account?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            CupertinoButton(
                child: const Text("Sign Up"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const SignUpPage();
                    }),
                  );
                })
          ],
        ),
      ),
    );
  }
}
