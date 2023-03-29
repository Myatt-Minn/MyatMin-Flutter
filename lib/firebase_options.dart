// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDGBpikndv-qG-mknwAdbjigENHaKO-9eA',
    appId: '1:252095997769:web:c2219c793d3d80057e9c98',
    messagingSenderId: '252095997769',
    projectId: 'ggnotes-lol-project',
    authDomain: 'ggnotes-lol-project.firebaseapp.com',
    storageBucket: 'ggnotes-lol-project.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB-OKRn-yARR8uvj3IgmB1p6MsqoWCy5Xs',
    appId: '1:252095997769:android:37f962bab81be27b7e9c98',
    messagingSenderId: '252095997769',
    projectId: 'ggnotes-lol-project',
    storageBucket: 'ggnotes-lol-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCTPww9FOfh6h6iOHGGGKxmgI0cYRkjrEA',
    appId: '1:252095997769:ios:e24eccbdce74b8257e9c98',
    messagingSenderId: '252095997769',
    projectId: 'ggnotes-lol-project',
    storageBucket: 'ggnotes-lol-project.appspot.com',
    iosClientId: '252095997769-dc96mad63fdcpotbacj5ehkoc4jep5qb.apps.googleusercontent.com',
    iosBundleId: 'myat.com.ggnotes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCTPww9FOfh6h6iOHGGGKxmgI0cYRkjrEA',
    appId: '1:252095997769:ios:e24eccbdce74b8257e9c98',
    messagingSenderId: '252095997769',
    projectId: 'ggnotes-lol-project',
    storageBucket: 'ggnotes-lol-project.appspot.com',
    iosClientId: '252095997769-dc96mad63fdcpotbacj5ehkoc4jep5qb.apps.googleusercontent.com',
    iosBundleId: 'myat.com.ggnotes',
  );
}
