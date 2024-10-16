import 'package:flutter/foundation.dart';
import 'package:twitter_clone_app/models/user.dart';
import 'package:twitter_clone_app/services/database/database_service.dart';

class DatabaseProvider extends ChangeNotifier {
  final _db = DatabaseService();

  // get user profile given uid
  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);

  // update user bio
  Future<void> updateBio(String bio) => _db.updateUserBioFirebase(bio);
}
