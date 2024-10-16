import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_clone_app/models/user.dart';

import '../../models/post.dart';
import '../auth/auth_service.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // USER PROFILE
  // Save user Info
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

  // Get user Info
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      // retrieve user doc from firebase
      DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();

      // convert doc to user profile
      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Update user bio
  Future<void> updateUserBioFirebase(String bio) async {
    String uid = AuthService().getCurrentUid();
    try {
      await _db.collection("Users").doc(uid).update({'bio': bio});
    } catch (e) {
      print(e);
    }
  }

  // POST MESSAGE
  // - Post a message
  Future<void> postMessageInFirebase(String message) async {
    try {
      String uid = _auth.currentUser!.uid;

      UserProfile? user = await getUserFromFirebase(uid);
      Post newPost = Post(
        id: '', // Firebase post id 자동 생성해줌
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
        likeCount: 0,
        likedBy: [],
      );

      //convert post object -> map
      Map<String, dynamic> newPostMap = newPost.toMap();

      // add to firebase
      await _db.collection("Posts").add(newPostMap);
    } catch (e) {
      print(e);
    }
  }

  // - Delete a post

  // - Get all posts
  Future<List<Post>> getAllPostsFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _db
          // go to collection -> Posts
          .collection("Posts")
          // 시간순 정렬
          .orderBy('timestamp', descending: true)
          // get this data
          .get();

      // return as a list of posts
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      print("게시물 가져오는 데 오류가 났어요 !${e.toString()}");
      return [];
    }
  }

  // Get individual post

  // LIKES

  // FOLLOW
}
