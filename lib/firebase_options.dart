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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC4ZcLHZaQZNtgFcVfBv8iD9w2FepbYxLU',
    appId: '1:15453283707:android:ce1c8eba57aaf3376749de',
    messagingSenderId: '15453283707',
    projectId: 'okstich-5d411',
    storageBucket: 'okstich-5d411.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcI2mPewamGg8bSTwZFAD0QNaXLgb84Cc',
    appId: '1:15453283707:ios:bb192175343d6ecc6749de',
    messagingSenderId: '15453283707',
    projectId: 'okstich-5d411',
    storageBucket: 'okstich-5d411.appspot.com',
    androidClientId: '15453283707-or2err5862ei0nuubd0fdsop7gs6qomt.apps.googleusercontent.com',
    iosClientId: '15453283707-6n00btonruisajeaskkkn3a4cpf1hgmr.apps.googleusercontent.com',
    iosBundleId: 'com.okstitch.okstitch',
  );
}