import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/data/firebase_service/firestore.dart';
import 'package:insta_clone/util/image_cached.dart';
import 'package:insta_clone/widgets/comment.dart';
import 'package:insta_clone/widgets/like_animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostWidget extends StatefulWidget {
  final snapshot;
  PostWidget(this.snapshot, {super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  bool isAnimating = false;
  String user = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = _auth.currentUser!.uid;
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375.w,
          height: 60.h,
          color: Colors.white,
          child: Center(
            child: ListTile(
              leading: ClipOval(
                child: SizedBox(
                  width: 35.w,
                  height: 35.h,
                  child: CachedImage(widget.snapshot['profileImage']),
                ),
              ),
              title: Text(
                widget.snapshot['username'],
                style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.snapshot['location'],
                style: TextStyle(fontSize: 13.sp),
              ),
              trailing: PopupMenuButton<int>(
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<int>>[
                    const PopupMenuItem<int>(
                      value: 1,
                      child: ListTile(
                        leading: Icon(Icons.delete,color: Colors.black,),
                        title: Text('Delete post'),

                      ),
                    ),
                  ];
                },
            onSelected: (int value) {
              Firebase_Firestor().deletepost(widget.snapshot['postId']);
          },
            icon: const Icon(Icons.more_horiz),
          ),
    ),
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            Firebase_Firestor().commentsno(widget.snapshot['postId']);
            Firebase_Firestor().like(
                like: widget.snapshot['like'],
                type: 'posts',
                uid: user,
                postId: widget.snapshot['postId']);
            setState(() {
              isAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 375.w,
                height: 375.h,
                child: CachedImage(
                  widget.snapshot['postImage'],
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isAnimating ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: isAnimating,
                  duration: const Duration(milliseconds: 400),
                  iconlike: false,
                  End: () {
                    setState(() {
                      isAnimating = false;
                    });
                  },
                  child: Icon(
                    Icons.favorite,
                    size: 100.w,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5.h),
              Row(
                children: [
                  SizedBox(width: 5.w),
                  LikeAnimation(
                    isAnimating: widget.snapshot['like'].contains(user),
                    child: IconButton(
                      onPressed: () {
                        Firebase_Firestor().like(
                            like: widget.snapshot['like'],
                            type: 'posts',
                            uid: user,
                            postId: widget.snapshot['postId']);
                      },
                      icon: Icon(
                        widget.snapshot['like'].contains(user)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.snapshot['like'].contains(user)
                            ? Colors.red
                            : Colors.black,
                        size: 24.w,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: DraggableScrollableSheet(
                              maxChildSize: 0.6,
                              initialChildSize: 0.6,
                              minChildSize: 0.2,
                              builder: (context, scrollController) {
                                return Comment(
                                    'posts', widget.snapshot['postId']);
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'images/comment.webp',
                          height: 30.h,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Image.asset('images/send.png',width: 23,),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: const Icon(Icons.bookmark_outline,size: 27)
                  ),
                ],
              ),
             Row(
               children: [
               Padding(
                 padding: EdgeInsets.only(
                   left: 25.w,
                   bottom: 4.h,
                 ),
                 child: Text(
                   widget.snapshot['like'].length.toString(),
                   style: TextStyle(
                     fontSize: 15.sp,
                     fontWeight: FontWeight.w500,
                   ),
                 ),
               ),
               Padding(
                 padding:  EdgeInsets.only(
                   left: 33.w,
                 ),
                 child: StreamBuilder<int>(
                   stream: Firebase_Firestor().commentsno(widget.snapshot['postId']),
                   builder: (context, snapshot) {
                     return Text(
                       snapshot.data?.toString() ?? '0',
                       style: TextStyle(
                         fontSize: 15.sp,
                         fontWeight: FontWeight.w500,
                       ),
                     );
                   },
                 ),
               ),
             ],),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.snapshot['username'] +
                            ' :  ' +
                            widget.snapshot['caption'],
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.w, top: 10.h, bottom: 8.h),
                child: Text(
                  formatDate(widget.snapshot['time'].toDate(),
                      [yyyy, '-', mm, '-', dd]),
                  style: TextStyle(fontSize: 11.sp, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
