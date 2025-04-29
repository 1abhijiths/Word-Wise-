import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ww/View/pages/badges.dart';
import 'package:ww/View/pages/home.dart';
import 'package:ww/View/pages/login.dart';
import 'package:ww/View/pages/splashscreen.dart';
import 'package:ww/theme.dart';
import 'package:ww/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      theme:Apptheme.thememode ,
      home:  splashscrn()
    );
  }
}
