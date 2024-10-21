import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_clone_app/models/comment.dart';
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
  Future<void> deletePostFromFirebase(String postId) async {
    try {
      await _db.collection("Posts").doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

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
  // Like a post
  Future<void> toggleLikeInFirebase(String postId) async {
    try {
      // get current uid
      String uid = _auth.currentUser!.uid;

      // go to doc for this post
      DocumentReference postDoc = _db.collection("Posts").doc(postId);

      // execute like
      await _db.runTransaction(
        (transaction) async {
          // get post data
          DocumentSnapshot postSnapshot = await transaction.get(postDoc);

          // get like of users who like this post
          List<String> likedBy =
              List<String>.from(postSnapshot['likedBy'] ?? []);

          // get like count
          int currentLikeCount = postSnapshot['likes'];

          // if user has not liked this post yet -> then like
          if (!likedBy.contains(uid)) {
            likedBy.add(uid);

            // increment like count
            currentLikeCount++;
          }

          // if user has already liked this post -> then unlike
          else {
            // remove user from like list
            likedBy.remove(uid);

            // decrement like count
            currentLikeCount--;
          }

          // update in firebase
          transaction.update(postDoc, {
            'likes': currentLikeCount,
            'likedBy': likedBy,
          });
        },
      );
    } catch (e) {
      print(e);
    }
  }

  // COMMENTS
  // Add a comment to a post
  Future<void> addCommentInFirebase(String postId, message) async {
    try {
      String uid = _auth.currentUser!.uid;

      UserProfile? user = await getUserFromFirebase(uid);

      Comment newComment = Comment(
        id: '',
        postId: postId,
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
      );

      Map<String, dynamic> newCommentMap = newComment.toMap();

      await _db.collection('Comments').add(newCommentMap);
    } catch (e) {
      print(e);
    }
  }

  // Delete a comment for a post
  Future<void> deleteCommentInFirebase(String commentId) async {
    try {
      await _db.collection('Comments').doc(commentId).delete();
    } catch (e) {
      print(e);
    }
  }

  // fetch comments for a post
  Future<List<Comment>> getCommentsFromFirebase(String postId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('Comments')
          .where('postId', isEqualTo: postId)
          .get();

      return snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
  // FOLLOW
}
