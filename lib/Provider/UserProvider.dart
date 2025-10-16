import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _email;
  String? _id; // user ID
  String? _name;
  List<String> _images = [];

  // Individual getters
  String? get email => _email;
  String? get id => _id; // legacy getter
  String? get userId => _id; // new convenience getter for calendar/Supabase
  String? get name => _name;
  List<String> get images => _images;

  // Combined getter for convenience
  Map<String, dynamic> get user => {
    'email': _email,
    'id': _id,
    'name': _name,
    'images': _images,
  };

  // Set user data
  void setUser({
    required String email,
    required String id,
    String? name,
    List<String>? images,
  }) {
    _email = email;
    _id = id;
    _name = name;
    _images = images ?? [];
    notifyListeners();
  }

  // Update images list separately
  void setImages(List<String> images) {
    _images = images;
    notifyListeners();
  }

  // Clear user data (logout)
  void clearUser() {
    _email = null;
    _id = null;
    _name = null;
    _images = [];
    notifyListeners();
  }

  // Check if user is logged in
  bool get isLoggedIn => _id != null;

  // Optional: convenience methods to check if a field is set
  bool hasEmail() => _email != null;
  bool hasName() => _name != null;
  bool hasImages() => _images.isNotEmpty;
}