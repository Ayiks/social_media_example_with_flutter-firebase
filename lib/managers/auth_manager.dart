import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familicious/services/file_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthManager with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
  final FileUploadServices _fileUploadServices = FileUploadServices();
  String _message = '';
  bool _isLoading = false;

  CollectionReference userCollection = _firebaseFirestore.collection('users');

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

  Future<bool> createNewUser(
      {required String name,
      required String email,
      required String password,
      required File imageFile}) async {
    setIsLoading(true);
    bool isCreated = false;
    setIsLoading(true);
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((UserCredential) async {
      String? photoUrl = await _fileUploadServices.uploadFile(
          file: imageFile, userUid: UserCredential.user!.uid);
      if (photoUrl != null) {
        //add user to firebaser (name,email,photo,uid,createdAt)
        userCollection.doc(UserCredential.user!.uid).set({
          "name": name,
          "email": email,
          "picture": photoUrl,
          "createdAt": FieldValue.serverTimestamp(),
          "user_id": UserCredential.user!.uid
        });
        isCreated = true;
      } else {
        setMessage('Image upload failed');
        isCreated = false;
        setIsLoading(false);
      }
    }).catchError((onError) {
      setMessage('$onError');
      isCreated = false;
      setIsLoading(false);
    }).timeout(const Duration(seconds: 30), onTimeout: () {
      setMessage('Please check your internet connection');
      isCreated = false;
      setIsLoading(false);
    });
    return isCreated;
  }

  Future<bool> loginUser(
      {required String email, required String password}) async {
    bool isSuccessful = false;
    await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      if (userCredential.user != null) {
        isSuccessful = true;
      } else {
        isSuccessful = false;
        setMessage('something went wrong');
      }
    }).catchError((onError) {
      setMessage('$onError');
      isSuccessful = false;
    }).timeout(const Duration(seconds: 30), onTimeout: () {
      setMessage('Please check your internet connection');
      isSuccessful = false;
      setIsLoading(false);
    });
    return isSuccessful;
  }

  Future<bool> sendResetLink(String email) async {
    bool isSent = false;
    await _firebaseAuth
        .sendPasswordResetEmail(email: email)
        .then((_) {
          isSent = true;
        })
        .catchError((error) {
          isSent = false;
          setMessage('$error');
          print('##**##$error');
        })
        
        .timeout(const Duration(seconds: 30), onTimeout: () {
          setMessage('Please check your internet connection');
          isSent = false;
        });
    return isSent;
  }
}
