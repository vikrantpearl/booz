import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:s2_classes/screens/webview_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 1),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => MyWebViewApp())));

    return Scaffold(

      body: SafeArea(
        child: Center(
          child: Image.asset("assets/logo.png"),
        ),
      ),
    );
  }
}
