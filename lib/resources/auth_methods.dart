import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone_firebase/models/user.dart' as model;
import 'package:insta_clone_firebase/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = await _auth.currentUser! ;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //sign up user method
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //register the users
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );

        //add user to our database by set method
        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        //different methods to add users deatails by add method
        // await _firestore.collection('users').add({
        //   'username':username,
        //   'uid':cred.user!.uid,
        //   'email': email,
        //   'bio':bio,
        //   'followers': [],
        //   'following': [],
        //
        // });
        res = "success";
      }
    }
    // this can be used to make error commands to users
    // on FirebaseAuthException catch(err){
    // //   if(err.code=='invalid-emial'){
    // //     res  = 'the email is badly formatted';
    // //   }else if(err.code=='weak password'){
    // //     res = 'Your password should be atleast 6 characters';
    // //   }
    // // }

    catch (err) {
      res = err.toString();
    }
    return res;
  }

  //logging in user authentication
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "please enter all the file";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //signout methods

 Future<void> signOut() async{
    await _auth.signOut();
 }
}
