import 'package:flutter/foundation.dart';
import 'package:twitter_clone_app/models/user.dart';
import 'package:twitter_clone_app/services/database/database_service.dart';

import '../../models/post.dart';

class DatabaseProvider extends ChangeNotifier {
  final _db = DatabaseService();

  // get user profile given uid
  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);

  // update user bio
  Future<void> updateBio(String bio) => _db.updateUserBioFirebase(bio);

  // POSTS
  // local list of posts
  List<Post> _allPosts = [];

  // get post
  List<Post> get allPosts => _allPosts;

  // post message
  Future<void> postMessage(String message) async {
    await _db.postMessageInFirebase(message);

    // reload data from firebase
    await loadAllPosts();
  }

  Future<void> loadAllPosts() async {
    final allPosts = await _db.getAllPostsFromFirebase();

    _allPosts = allPosts;

    notifyListeners();
  }
}
