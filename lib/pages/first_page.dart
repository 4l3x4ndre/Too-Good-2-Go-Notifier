import 'package:flutter/material.dart';
import 'package:tgtg_tracker/pages/need_setup_page.dart';

import 'package:tgtg_tracker/pages/second_page.dart';
import '../constants.dart';

class FirstPage extends StatefulWidget {
  FirstPage({Key key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mediumColor,
      body: Stack(
        children: [
          Positioned(
            top: -MediaQuery.of(context).size.width * .75,
            right: -MediaQuery.of(context).size.width / 2,
            child: Container(
              width: MediaQuery.of(context).size.width * 2,
              height: MediaQuery.of(context).size.width * 2,
              decoration: new BoxDecoration(
                color: darkColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
              child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Container(
                              child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 10),
                        child: Text(
                          "First things first, \nDid you create a Too Good To Go account?",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: lightColor,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width / 10,
                          ),
                        ),
                      ))),
                      Center(
                        child: Image.asset('assets/images/toogoodtogologo.png',
                            height: MediaQuery.of(context).size.height / 7,
                            fit: BoxFit.fitWidth),
                      ),
                      SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 10),
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width / 4,
                            left: MediaQuery.of(context).size.width / 4),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(45)),
                          ),
                          color: blackColor,
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(
                                        color: lightColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                10),
                                  ),
                                ),
                                Icon(Icons.check_circle,
                                    size: 45, color: primaryColor),
                              ],
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SecondPage()),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 15),
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width / 4,
                            left: MediaQuery.of(context).size.width / 4),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(45)),
                          ),
                          color: blackColor,
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    "No",
                                    style: TextStyle(
                                        color: errorColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                10),
                                  ),
                                ),
                                Icon(Icons.close, size: 45, color: errorColor),
                              ],
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NeedSetupPage()));
                          },
                        ),
                      )
                    ],
                  ))),
        ],
      ),
    );
  }
}
