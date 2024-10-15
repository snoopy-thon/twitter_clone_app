import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_clone_app/models/user.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> saveUserInfoFirebase(
      {required String name, required String email}) async {
    String uid = _auth.currentUser!.uid;
    String username = email.split('@')[0];

    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '',
    );

    // convert user into a map sothat we can store in firebase
    final userMap = user.toMap();
    // save user Info in firebase
    await _db.collection("Users").doc(uid).set(userMap);
  }
}
