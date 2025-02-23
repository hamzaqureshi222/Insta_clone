// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDjSb4QrEgoaCco4A-uD6l74Or2ehskQig',
    appId: '1:477936732281:web:69457c913f9f10b2a06ca8',
    messagingSenderId: '477936732281',
    projectId: 'insta-clone-f18cf',
    authDomain: 'insta-clone-f18cf.firebaseapp.com',
    storageBucket: 'insta-clone-f18cf.appspot.com',
    measurementId: 'G-DNZECN8YCH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD2VDgXIhVb3_1OWH1d0Eu_wpAZPqZfoI8',
    appId: '1:477936732281:android:5405c2299825c4c4a06ca8',
    messagingSenderId: '477936732281',
    projectId: 'insta-clone-f18cf',
    storageBucket: 'insta-clone-f18cf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBovsIc-_zJayQzmwUv8Xk76ixd624Jfec',
    appId: '1:477936732281:ios:cb3affab5060a954a06ca8',
    messagingSenderId: '477936732281',
    projectId: 'insta-clone-f18cf',
    storageBucket: 'insta-clone-f18cf.appspot.com',
    iosBundleId: 'com.example.instaClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBovsIc-_zJayQzmwUv8Xk76ixd624Jfec',
    appId: '1:477936732281:ios:cb3affab5060a954a06ca8',
    messagingSenderId: '477936732281',
    projectId: 'insta-clone-f18cf',
    storageBucket: 'insta-clone-f18cf.appspot.com',
    iosBundleId: 'com.example.instaClone',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDjSb4QrEgoaCco4A-uD6l74Or2ehskQig',
    appId: '1:477936732281:web:a7a592fab2ace098a06ca8',
    messagingSenderId: '477936732281',
    projectId: 'insta-clone-f18cf',
    authDomain: 'insta-clone-f18cf.firebaseapp.com',
    storageBucket: 'insta-clone-f18cf.appspot.com',
    measurementId: 'G-K00E8QLEG2',
  );
}
