import 'package:flutter/foundation.dart';
import 'package:twitter_clone_app/models/user.dart';
import 'package:twitter_clone_app/services/auth/auth_service.dart';
import 'package:twitter_clone_app/services/database/database_service.dart';

import '../../models/comment.dart';
import '../../models/post.dart';

class DatabaseProvider extends ChangeNotifier {
  final _db = DatabaseService();
  final _auth = AuthService();

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

    // update local data
    _allPosts = allPosts;

    // initalize local like data
    initializeLikeMap();

    // update UI
    notifyListeners();
  }

  List<Post> filterUserPosts(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  Future<void> deletePost(String postId) async {
    await _db.deletePostFromFirebase(postId);

    await loadAllPosts();
  }

  // Likes
  // Local map to track like counts for each post
  Map<String, int> _likeCounts = {};

  // Local list to track posts liked by current user
  List<String> _likedPosts = [];

  bool isPostLikedByCurrentUser(String postId) => _likedPosts.contains(postId);

  int getLikeCount(String postId) => _likeCounts[postId] ?? 0;

  // initialize like map locally
  void initializeLikeMap() {
    // get current uid
    final currentUserID = _auth.getCurrentUid();

    // 새로운 유저가 로그인 했을 때, 로컬 데이터 clear
    _likedPosts.clear();

    // for each post get like data
    for (var post in _allPosts) {
      // update like count map
      _likeCounts[post.id] = post.likeCount;

      // if the current user already likes this post
      if (post.likedBy.contains(currentUserID)) {
        // add this post id to local list of liked posts
        _likedPosts.add(post.id);
      }
    }
  }

// toggle like
  Future<void> toggleLike(String postId) async {
    // database에 접근하는데 시간이 걸리니, User 에게 빠르게 보여주기 위해서 db접근 전에 UI를 먼저 업데이트 해주기

    // DB 저장에 실패했을때를 대비하여 원래 값 저장하기
    final likedPostsOriginal = _likedPosts;
    final likeCountsOriginal = _likeCounts;

    if (_likedPosts.contains(postId)) {
      _likedPosts.remove(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) - 1;
    } else {
      _likedPosts.add(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) + 1;
    }
    // 로컬에서 UI 업데이트
    notifyListeners();

    // 데이터베이스에서 업데이트하기
    try {
      await _db.toggleLikeInFirebase(postId);
    } catch (e) {
      // DB 저장 실패했을경우 원래대로 되돌리기
      _likedPosts = likedPostsOriginal;
      _likeCounts = likeCountsOriginal;

      notifyListeners();
    }
  }

  // COMMENTS
  // postId1: [comment1, comment2, ..],
  // postId2: [comment1, comment2, ..],

  // comments의 로컬 리스트
  final Map<String, List<Comment>> _comments = {};

  // 로컬에서 comments get 하기
  List<Comment> getComments(String postId) => _comments[postId] ?? [];

  // DB에서 해당 포스트의 comments 접근하기
  Future<void> loadComments(String postId) async {
    final allComments = await _db.getCommentsFromFirebase(postId);

    _comments[postId] = allComments;

    notifyListeners();
  }

  // add a comment
  Future<void> addComment(String postId, message) async {
    await _db.addCommentInFirebase(postId, message);
    await loadComments(postId);
  }

  // delete a comment
  Future<void> deleteComment(String commentId, postId) async {
    await _db.deleteCommentInFirebase(commentId);
    await loadComments(commentId);
  }
}
