import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id; // comment의 id
  final String postId; // comment가 속해있는 post의 id
  final String uid; // comment를 작성한 user의 id
  final String name; // comment를 작성한 user의 이름
  final String username; // comment를 작성한 user의 username
  final String message;
  final Timestamp timestamp;

  Comment({
    required this.id,
    required this.postId,
    required this.uid,
    required this.name,
    required this.username,
    required this.message,
    required this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      id: doc.id,
      postId: doc['postId'],
      uid: doc['uid'],
      name: doc['name'],
      username: doc['username'],
      message: doc['message'],
      timestamp: doc['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'uid': uid,
      'name': name,
      'username': username,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
