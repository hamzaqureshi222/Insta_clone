import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/data/firebase_service/firestore.dart';
import 'package:insta_clone/data/model/usermodel.dart';
import 'package:insta_clone/screen/post_screen.dart';
import 'package:insta_clone/util/image_cached.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class ProfileScreen extends StatefulWidget {
  String Uid;
  ProfileScreen({super.key, required this.Uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int post_lenght = 0;
  int reels_length = 0;
  bool yours = false;
  List following = [];
  bool follow = false;

  @override
  void initState() {
    super.initState();
    getdata();
    if (widget.Uid == _auth.currentUser!.uid) {
      setState(() {
        yours = true;
      });
    }
  }

  getdata() async {
    DocumentSnapshot snap = await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    following = (snap.data()! as dynamic)['following'];
    if (following.contains(widget.Uid)) {
      setState(() {
        follow = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: _firebaseFirestore
                      .collection('users')
                      .doc(widget.Uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    Usermodel user = Usermodel.fromSnapshot(snapshot.data!);
                    return Head(user);
                  },
                ),
              ),
              StreamBuilder(
                stream: _firebaseFirestore
                    .collection('posts')
                    .where('uid', isEqualTo: widget.Uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  post_lenght = snapshot.data!.docs.length;
                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final snap = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PostScreen(snap.data())));
                        },
                        child: CachedImage(
                          snap['postImage'],
                        ),
                      );
                    }, childCount: post_lenght),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Head(Usermodel user) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
                child: ClipOval(
                  child: SizedBox(
                    width: 80.w,
                    height: 80.h,
                    child: CachedImage(user.profile),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 35.w),
                      Text(
                        post_lenght.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 53.w),
                      Text(
                        user.followers.length.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 70.w),
                      Text(
                        user.following.length.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 30.w),
                      Text(
                        'Posts',
                        style: TextStyle(
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(width: 25.w),
                      Text(
                        'Followers',
                        style: TextStyle(
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(width: 19.w),
                      Text(
                        'Following',
                        style: TextStyle(
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  user.bio,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Visibility(
            visible: !follow,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: GestureDetector(
                onTap: () {
                  if (!yours) {
                    Firebase_Firestor().follow(uid: widget.Uid);
                    setState(() {
                      follow = true;
                    });
                  } else {
                    FirebaseAuth.instance.signOut();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 30.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: yours ? Colors.white : Colors.blue,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                        color: yours ? Colors.grey.shade400 : Colors.blue),
                  ),
                  child: yours
                      ? const Text('Sign out')
                      : const Text(
                    'Follow',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: follow,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Firebase_Firestor().follow(uid: widget.Uid);
                        setState(() {
                          follow = false;
                        });
                      },
                      child: Container(
                          alignment: Alignment.center,
                          height: 30.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: const Text('Unfollow')),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: 30.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Text(
                        'Message',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5.h),
          SizedBox(
            width: double.infinity,
            height: 30.h,
            child: const TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: [
                Icon(Icons.grid_on),
                Icon(Icons.video_collection),
                Icon(Icons.person),
              ],
            ),
          ),
          SizedBox(
            height: 5.h,
          )
        ],
      ),
    );
  }
}
