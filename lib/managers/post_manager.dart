import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familicious/services/file_upload_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PostManager with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  final FileUploadServices _fileUploadServices = FileUploadServices();

  final CollectionReference<Map<String, dynamic>> _userCollection =
      _firebaseFirestore.collection("users");

  final CollectionReference<Map<String, dynamic>> _postCollection =
      _firebaseFirestore.collection('posts');

  String _message = '';
  bool _isLoading = false;
  String get message => _message;
  bool get isLoading => _isLoading;

  setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  setIsLoading(bool loading) {
    _isLoading = isLoading;
    notifyListeners();
  }



  Future<bool> submitPost(
      {String? description, required File postImage}) async {
    bool isSubmited = false;
    String userUid = _firebaseAuth.currentUser!.uid;
    FieldValue timeStamp = FieldValue.serverTimestamp();
    String? photoUrl =
        await _fileUploadServices.uploadPostFile(file: postImage);

    if (photoUrl != null) {
      await _postCollection.doc().set({
        "description": description,
        "picture": photoUrl,
        "createdAt": timeStamp,
        "user_id": userUid
      }).then((_) {
        isSubmited = true;
        setMessage('Post successfully submitted');
      }).catchError((onError) {
        isSubmited = false;
        setMessage('### $onError');
      }).timeout(const Duration(seconds: 60), onTimeout: () {
        isSubmited = false;
        setMessage('Please check your connection');
      });
    } else {
      isSubmited = false;
      setMessage('Image not found');
    }

    return isSubmited;
  }

   Stream<QuerySnapshot<Map<String, dynamic>?>> getAllPosts() {
    return _postCollection.orderBy('createdAt',descending: true).snapshots();
  }

   ///get user info from db
  Future<Map<String, dynamic>?> getUserInfo(String userUid) async {
    Map<String, dynamic>? userData;
    await _userCollection
        .doc(userUid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> doc) {
      if (doc.exists) {
        userData = doc.data();
      } else {
        userData = null;
      }
    });
    return userData;
  }
}
