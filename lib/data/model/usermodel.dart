import 'package:cloud_firestore/cloud_firestore.dart';

class Usermodel {
  String email;
  String username;
  String bio;
  String profile;
  List following;
  List followers;

  Usermodel(this.bio, this.email, this.followers, this.following, this.profile, this.username);

  factory Usermodel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Usermodel(
      data['bio'],
      data['email'],
      List<String>.from(data['followers']),
      List<String>.from(data['following']),
      data['profile'],
      data['username'],
    );
  }
}
