import 'package:flutter/material.dart';
import 'package:tgtg_tracker/pages/first_page.dart';
import 'package:tgtg_tracker/pages/timer_page.dart';
import 'package:tgtg_tracker/watcher/config.dart';
import 'dart:async';

import '../constants.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // Delayed loadNextScreen call to ensuire every info are ready
    Future.delayed(const Duration(milliseconds: 2500), () {
      loadNextScreen();
    });
    super.initState();
  }

  void loadNextScreen() async {
    Config config = Config();
    String email = await config.getValue('email');
    String password = await config.getValue('password');

    if (email != null && password != null && email != '' && password != '') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => TimerPage()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => FirstPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkColor,
      body: Center(
        child: Image.asset('assets/images/toogoodtogologo.png',
            width: MediaQuery.of(context).size.width / 2, fit: BoxFit.fitWidth),
      ),
    );
  }
}
