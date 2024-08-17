import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_clone/data/firebase_service/firebase_auth.dart';
import 'package:insta_clone/util/dialog.dart';
import 'package:insta_clone/util/exeption.dart';
import 'package:insta_clone/util/imagepicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback show;
  SignupScreen(this.show, {super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final email = TextEditingController();
  FocusNode email_F = FocusNode();
  final password = TextEditingController();
  FocusNode password_F = FocusNode();
  final passwordConfirme = TextEditingController();
  FocusNode passwordConfirme_F = FocusNode();
  final username = TextEditingController();
  FocusNode username_F = FocusNode();
  final bio = TextEditingController();
  FocusNode bio_F = FocusNode();
  File? _imageFile;

  bool _isPasswordVisible = false; // State variable to toggle password visibility
  bool _isConfirmPasswordVisible = false; // State variable to toggle confirm password visibility
  bool _isLoading = false; // State variable to show loading indicator

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    passwordConfirme.dispose();
    username.dispose();
    bio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(width: 96.w, height: 10.h),
              Center(
                child: Image.asset('images/logo.jpg'),
              ),
              SizedBox(width: 96.w, height: 70.h),
              InkWell(
                onTap: () async {
                  File _imagefilee = await ImagePickerr().uploadImage('gallery');
                  setState(() {
                    _imageFile = _imagefilee;
                  });
                },
                child: CircleAvatar(
                  radius: 36.r,
                  backgroundColor: Colors.grey,
                  child: _imageFile == null
                      ? CircleAvatar(
                    radius: 34.r,
                    backgroundImage: AssetImage('images/person.png'),
                    backgroundColor: Colors.grey.shade200,
                  )
                      : CircleAvatar(
                    radius: 34.r,
                    backgroundImage: Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                    ).image,
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              Textfild(email, email_F, 'Email', Icons.email),
              SizedBox(height: 15.h),
              Textfild(username, username_F, 'username', Icons.person),
              SizedBox(height: 15.h),
              Textfild(bio, bio_F, 'bio', Icons.abc),
              SizedBox(height: 15.h),
              Textfild(password, password_F, 'Password', Icons.lock,
                  isPassword: true),
              SizedBox(height: 15.h),
              Textfild(passwordConfirme, passwordConfirme_F,
                  'Confirm Password', Icons.lock, isPassword: true),
              SizedBox(height: 15.h),
              Signup(),
              SizedBox(height: 15.h),
              Have()
            ],
          ),
        ),
      ),
    );
  }

  Widget Have() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Don you have account?  ",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              "Login ",
              style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget Signup() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: InkWell(
        onTap: _isLoading ? null : _handleSignup, // Disable button when loading
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: _isLoading
              ? CircularProgressIndicator(
            color: Colors.white,
          )
              : Text(
            'Sign up',
            style: TextStyle(
              fontSize: 23.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Authentication().signup(
        email: email.text,
        password: password.text,
        passwordConfirme: passwordConfirme.text,
        username: username.text,
        bio: bio.text,
        profile: _imageFile ?? File(''),
      );
    } on exceptions catch (e) {
      dialogBuilder(context, e.message);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Padding Textfild(TextEditingController controll, FocusNode focusNode,
      String typename, IconData icon, {bool isPassword = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: TextField(
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
          controller: controll,
          focusNode: focusNode,
          obscureText: isPassword
              ? (typename == 'Password'
              ? !_isPasswordVisible
              : !_isConfirmPasswordVisible)
              : false, // Toggle visibility
          decoration: InputDecoration(
            hintText: typename,
            prefixIcon: Icon(
              icon,
              color: focusNode.hasFocus ? Colors.black : Colors.grey[600],
            ),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                (typename == 'Password'
                    ? _isPasswordVisible
                    : _isConfirmPasswordVisible)
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: focusNode.hasFocus
                    ? Colors.black
                    : Colors.grey[600],
              ),
              onPressed: () {
                setState(() {
                  if (typename == 'Password') {
                    _isPasswordVisible = !_isPasswordVisible;
                  } else {
                    _isConfirmPasswordVisible =
                    !_isConfirmPasswordVisible;
                  }
                });
              },
            )
                : null,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(
                width: 2.w,
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(
                width: 2.w,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
