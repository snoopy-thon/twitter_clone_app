import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String username;
  final String bio;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.username,
    required this.bio,
  });

  // firebase -> app
  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
      uid: doc['uid'],
      name: doc['name'],
      email: doc['email'],
      username: doc['username'],
      bio: doc['bio'],
    );
  }

  // app -> firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'username': username,
      'bio': bio,
    };
  }
}
