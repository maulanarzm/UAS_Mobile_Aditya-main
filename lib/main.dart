import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/app.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase App
  LocalStorage();
  await DatabaseConfig.init(StoreRef<dynamic, dynamic>.main());
  runApp(
    ProviderScope(
      observers: [RiverpodObserver()],
      child: MyApp(),
    ),
  );
}
