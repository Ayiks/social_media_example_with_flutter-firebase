import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FileUploadServices {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Future<String?> uploadFile(
      {required File file, required String userUid}) async {
    try {
      Reference storageRef = _firebaseStorage
          .ref()
          .child('profile_pictures')
          .child('$userUid.jpg');

      UploadTask storageUploadTask = storageRef.putFile(file);

      TaskSnapshot snapshot = await storageUploadTask
          .whenComplete(() => storageRef.getDownloadURL());

      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print('####### $e');
      return null;
    }
  }
}
