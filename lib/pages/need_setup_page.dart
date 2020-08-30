import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class NeedSetupPage extends StatefulWidget {
  NeedSetupPage({Key key}) : super(key: key);

  @override
  _NeedSetupPageState createState() => _NeedSetupPageState();
}

class _NeedSetupPageState extends State<NeedSetupPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkErrorColor,
      body: Stack(
        children: [
          Positioned(
            top: -MediaQuery.of(context).size.width * .75,
            right: -MediaQuery.of(context).size.width / 2,
            child: Container(
              width: MediaQuery.of(context).size.width * 2,
              height: MediaQuery.of(context).size.width * 2,
              decoration: new BoxDecoration(
                color: errorColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 10,
                        left: MediaQuery.of(context).size.width / 10,
                        bottom: MediaQuery.of(context).size.width / 20),
                    child: Text(
                      "We need it to know where to search your products.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width / 13,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 10,
                        right: MediaQuery.of(context).size.width / 10),
                    child: Text(
                      "Download the Too Good To Go app and setup everything.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width / 13,
                      ),
                    ),
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 5),
                  Padding(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(45)),
                      ),
                      color: blackColor,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10, right: 10.0),
                            child: Text(
                              "I do it and I come back",
                              style: TextStyle(
                                  color: errorColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 15),
                            ),
                          ),
                          Icon(Icons.close, size: 45, color: errorColor),
                        ],
                      ),
                      onPressed: () {
                        SystemChannels.platform
                            .invokeMethod<void>('SystemNavigator.pop', true);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: 10,
                        left: 10,
                        top: MediaQuery.of(context).size.height / 20),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(45)),
                      ),
                      color: blackColor,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10, right: 10.0),
                            child: Text(
                              "I did it!",
                              style: TextStyle(
                                  color: lightColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 15),
                            ),
                          ),
                          Icon(Icons.check_circle, size: 45, color: lightColor),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
