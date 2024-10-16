import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:twitter_clone_app/pages/profile_page.dart';

import '../models/post.dart';
import '../pages/post_page.dart';

void goUserPage(BuildContext context, String uid) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => ProfilePage(uid: uid)));
}

void goPostPage(BuildContext context, Post post) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostPage(
          post: post,
        ),
      ));
}
