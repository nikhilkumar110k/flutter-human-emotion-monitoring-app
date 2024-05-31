import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final messageTextController = TextEditingController();
  String text = '';
  late User firebaseUser;
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    try {
      if (user != null) {
        firebaseUser = user;
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
              }),
        ],
        title: const Text('⚡️ Chat'),
        backgroundColor: const Color(0xFFFFD073),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder(
              stream:
                  _db.collection('messages').orderBy('Timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('Loading'),
                  );
                } else {
                  final messages = snapshot.data!.docs.reversed;
                  List<Bubble> messageWidget = [];
                  for (var message in messages) {
                    final String text = message.data()['text'];
                    final String email = message.data()['email'];
                    messageWidget.add(Bubble(
                      email: email,
                      text: text,
                      cEmail: firebaseUser.email ?? '',
                    ));
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: const EdgeInsets.all(8),
                      children: messageWidget,
                    ),
                  );
                }
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        text = value;
                      },
                      controller: messageTextController,
                      decoration: kMessageTextFieldDecoration,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xFFFFD073))),
                      onPressed: () async {
                        messageTextController.clear();
                        await _db.collection('messages').add({
                          'text': text,
                          'email': firebaseUser.email,
                          'Timestamp': FieldValue.serverTimestamp(),
                        });
                      },
                      child: const Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final String email, text, cEmail;
  const Bubble(
      {super.key,
      required this.email,
      required this.text,
      required this.cEmail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment:
            cEmail == email ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
              elevation: 5,
              color: email == cEmail ? Colors.black : Colors.white,
              borderRadius: cEmail == email
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))
                  : const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: cEmail == email ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
