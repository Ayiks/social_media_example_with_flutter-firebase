import 'dart:io';

import 'package:familicious/services/file_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthManager with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FileUploadServices _fileUploadServices = FileUploadServices();
  String _message = '';
  bool _isLoading = false;

  String get massage => _message;
  bool get isLoading => _isLoading;

  setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  setIsLoading(bool loading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  createNewUser(
      {required String name,
      required String email,
      required String password,
      required File imageFile}) async {
    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((UserCredential) async {
          String? photoUrl = await _fileUploadServices.uploadFile(
              file: imageFile, userUid: UserCredential.user!.uid);
              if (photoUrl !=null) {
                //add user to firebaser (name,email,photo,uid,createdAt)
              } else {
                setMessage('Image upload failed');
              }
        })
        .catchError((onError) {
          setMessage('$onError');
        })
        .timeout(Duration(seconds: 30), onTimeout: () {
          setMessage('Please check your internet connection');
        });
  }
}
