import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class ProfileView extends StatelessWidget {
   ProfileView({ Key? key }) : super(key: key);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(onPressed: (){
             _firebaseAuth.signOut();
          }, icon: Icon(Icons.logout_outlined), label: Text('Logout'))
        ],
      ),
    );
  }
}