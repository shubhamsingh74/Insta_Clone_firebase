import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone_firebase/Screens/add_post_screen.dart';
import 'package:insta_clone_firebase/Screens/feed_screen.dart';

import '../Screens/profile_screen.dart';
import '../Screens/search_screen.dart';

const webScreenSize = 600;

 List<Widget> homeScreenItems = [
  const FeedScreen(),
 const SearchScreen(),
 const AddPostScreen(),
 const  Text('notify'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];