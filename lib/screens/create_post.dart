import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatePost extends StatefulWidget {
  static const String id = "create_post";

  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String _description="";


  Future<void>_submit({required File image}) async{

    FocusScope.of(context).unfocus();

    if(_description.trim().isNotEmpty){

      late String imageURL;

      FirebaseStorage storage = FirebaseStorage.instance;

      await storage.ref("image/${UniqueKey().toString()}.png").putFile(image).then((taskSnapshot) async{
        imageURL= await taskSnapshot.ref.getDownloadURL();
      });
      FirebaseFirestore.instance.collection("posts").add({
        "timestamp":Timestamp.now(),
        "userId" : FirebaseAuth.instance.currentUser!.uid,
        "userName" : FirebaseAuth.instance.currentUser!.displayName,
        "description" : _description,
        "imageURL" : imageURL,
      }).then((docRef) => docRef.update({"postId": docRef.id}));
    }


  }

  @override
  Widget build(BuildContext context) {
    final File imageFile = ModalRoute.of(context)!.settings.arguments as File;
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                    image: FileImage(imageFile),
                    fit: BoxFit.cover,
                  )),
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "Enter a description"),
                  textInputAction: TextInputAction.go,
                  inputFormatters: [LengthLimitingTextInputFormatter(150)],
                  onChanged: (value) {
                    _description=value;
                  },
                  onEditingComplete:() {
                    _submit(image:imageFile);
                    Navigator.of(context).pop(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
