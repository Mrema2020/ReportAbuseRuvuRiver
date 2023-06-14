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
    apiKey: 'AIzaSyBchFtLKoKtAxgoy3BlV6_KCytXqGzfS2w',
    appId: '1:329277104561:web:9ccfbcadb361c73e7c9d90',
    messagingSenderId: '329277104561',
    projectId: 'ruvu-reporting-application',
    authDomain: 'ruvu-reporting-application.firebaseapp.com',
    databaseURL: 'https://ruvu-reporting-application-default-rtdb.firebaseio.com',
    storageBucket: 'ruvu-reporting-application.appspot.com',
    measurementId: 'G-DRPF5NXQFW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCpiVsrFcBQujEqsncwZcwniXUlLuu2sQM',
    appId: '1:329277104561:android:94d518551d3dae6b7c9d90',
    messagingSenderId: '329277104561',
    projectId: 'ruvu-reporting-application',
    databaseURL: 'https://ruvu-reporting-application-default-rtdb.firebaseio.com',
    storageBucket: 'ruvu-reporting-application.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBFFl7Bp99TYxmTL4REFxz7HL4-36PfMuA',
    appId: '1:329277104561:ios:df78ce3e5860c8177c9d90',
    messagingSenderId: '329277104561',
    projectId: 'ruvu-reporting-application',
    databaseURL: 'https://ruvu-reporting-application-default-rtdb.firebaseio.com',
    storageBucket: 'ruvu-reporting-application.appspot.com',
    iosClientId: '329277104561-nud5b6ucn6qav9th4g0jvmnnkdn63af7.apps.googleusercontent.com',
    iosBundleId: 'com.example.ruvu',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBFFl7Bp99TYxmTL4REFxz7HL4-36PfMuA',
    appId: '1:329277104561:ios:b2e874627a79359f7c9d90',
    messagingSenderId: '329277104561',
    projectId: 'ruvu-reporting-application',
    databaseURL: 'https://ruvu-reporting-application-default-rtdb.firebaseio.com',
    storageBucket: 'ruvu-reporting-application.appspot.com',
    iosClientId: '329277104561-k0a8dunem34h4ig9l3ajdu7fusqknmkd.apps.googleusercontent.com',
    iosBundleId: 'com.example.ruvu.RunnerTests',
  );
}
