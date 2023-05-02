import 'package:flutter/material.dart';
import 'package:insta_clone_firebase/models/user.dart';
import 'package:insta_clone_firebase/resources/auth_methods.dart';

import '../models/user.dart';
import '../models/user.dart';
import '../models/user.dart';
import '../models/user.dart';

// class UserProvider with ChangeNotifier{
//   final AuthMethods _authMethods = AuthMethods();
//   User? _user;

//   User get getUser => _user!;

//   Future<void> refreshUser() async {
//     User user = await _authMethods.getUserDetails();
//     _user = user;
//     notifyListeners();
//   }
// }

class UserProvider with ChangeNotifier {
   User? _user ;
   // User get getUser => _user!;
   // User? get getUser => _user;
  final AuthMethods _authMethods = AuthMethods();

   User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}