import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String? _uid;

  String? get uid => _uid;

  Future<void> fetchUid() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _uid = user.uid;
      notifyListeners();
    }
  }

  void setUid(String uid) {
    _uid = uid;
    notifyListeners();
  }
}
