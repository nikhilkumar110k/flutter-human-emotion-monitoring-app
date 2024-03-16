import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlycode/User/UserModel.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'SignUp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel? usermodel;
  final User? firebaseUser;
  const CompleteProfile({Key? key, this.usermodel, this.firebaseUser})
      : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  late File imageFile;
  TextEditingController fullNameController = TextEditingController();
  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    File? croppedImage = ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20) as File?;
    if (croppedImage != null) {
      setState(() {
        imageFile = croppedImage;
      });
    }
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("upload the profile picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("upload from gallery"),
                  onTap: () {
                    selectImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("Take the photo"),
                  onTap: () {
                    selectImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  void checkValues() {
    String fullname = fullNameController.text.trim();
    if (fullname == "" || imageFile == null) {
      const snackbar = SnackBar(content: Text("Please fill all the values"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.usermodel!.uid.toString())
        .putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullname = fullNameController.text.trim();
    widget.usermodel?.fullname = fullname;
    widget.usermodel?.profilepic = imageUrl;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.usermodel!.uid)
        .set(widget.usermodel!.toMap())
        .then((value) {
      const snackbar = SnackBar(content: Text("Please fill all the values"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Profile"),
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              CupertinoButton(
                onPressed: () {
                  showPhotoOptions();
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      (imageFile != null) ? FileImage(imageFile!) : null,
                  child: (imageFile == null)
                      ? Icon(
                          Icons.person,
                          size: 60,
                        )
                      : null,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: "Full Name",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(
                  child: const Text("Submit"),
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
      ),
    );
  }
}
