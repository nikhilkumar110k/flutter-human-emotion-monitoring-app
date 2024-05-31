import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../User/UserModel.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email == "" || password == "") {
      const snackbar = SnackBar(content: Text("Please fill all the values"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      const snackbar = SnackBar(content: Text("Signup successful!"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      var snackbar = SnackBar(content: Text(ex.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newuser =
          UserModel(uid: uid, email: email, fullname: "", profilepic: "");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newuser.toMap())
          .then((value) => const SnackBar(content: Text("new user created")));
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      checkValues();
                      CircularProgressIndicator;
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Already have an account?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            CupertinoButton(
                child: const Text("Login"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
