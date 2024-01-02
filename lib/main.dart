import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:s2_classes/screens/splash_screen.dart';
import 'package:s2_classes/screens/webview_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booze Express',
      debugShowCheckedModeBanner: false, // Set this to false
      theme: ThemeData(
        primarySwatch: Colors.blue,

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1DA0E0), // Use your desired color here
        ),
      ),
      home: const Scaffold(
        body: SafeArea(
         child: SplashScreen(),
        ) // Use your webview screen widget
      ),
    );
  }
}
