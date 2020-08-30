import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:tgtg_tracker/constants.dart';
import 'package:tgtg_tracker/watcher/config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../watcher/poller.dart' as poller;

class TimerPage extends StatefulWidget {
  TimerPage({Key key}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer timer;
  String info = '';
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
  Config config = new Config();

  int hours = 0;
  int minutes = 2;
  String h = 'hour';
  String m = 'minute';

  @override
  void initState() {
    setupTimer();
    super.initState();
  }

  void setupTimer() async {
    // Get values from GlobalConf plugin
    String _seconds = await config.getValue('timer_seconds');
    String _minutes = await config.getValue('timer_minutes');

    if (_minutes != null &&
        _seconds != null &&
        _seconds != '' &&
        _minutes != '') {
      setState(() {
        minutes = int.parse(_seconds);
        hours = int.parse(_minutes);
      });
    }
  }

  void stopTimer() {
    // Stop the timer
    setState(() {
      timer?.cancel();
      timer = null;
    });
  }

  void launchTimer() {
    // Set the GlobalConf to store the timer infos and reuse it next time app is launched
    config.setConfig('timer_seconds', minutes.toString());
    config.setConfig('timer_minutes', hours.toString());
    stopTimer();
    setState(() {
      timer = Timer.periodic(
          Duration(seconds: minutes * 60, minutes: hours * 60),
          (Timer t) => fetchAtEndOfTimer());
    });

    // Delayed the first call to ensure everything is setup and ready
    Future.delayed(Duration(seconds: 5), () {
      fetchAtEndOfTimer();
    });
  }

  void fetchAtEndOfTimer() async {
    // Convert the reponse from the api into a text to display
    String s = await poller.Poller().pollFavoriteBusinesses();
    setState(() {
      info = s;
    });
    ;
  }

  // Url used in the drawer
  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Tracker",
            style: style.copyWith(fontSize: 25),
          ),
          backgroundColor: mediumColor,
          shadowColor: blackColor,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'Too Good To Go Tracker',
                  style: style.copyWith(color: lightColor, fontSize: 30),
                ),
                decoration: BoxDecoration(color: darkColor),
              ),
              ListTile(
                leading: Icon(
                  Icons.star,
                  color: Colors.yellow[700],
                ),
                title: Text('Rate the app'),
                onTap: () {
                  _launchURL('https://play.google.com/store');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.free_breakfast,
                  color: Colors.brown,
                ),
                title: Text('Buy me a coffee'),
                onTap: () {
                  _launchURL('https://paypal.me/4l3x4ndre');
                },
              ),
            ],
          ),
        ),
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
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, //MediaQuery.of(context).size.height / 5,
                          bottom: MediaQuery.of(context).size.height / 5),
                      child: pageComponent(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget pageTimeRangeSelection() {
    DateTime _customDate = DateTime.fromMillisecondsSinceEpoch(
        hours * 3600000 + minutes * 60000 - 3600000);
    setState(() {
      h = 'hour';
      m = 'minute';
    });
    if (hours > 1) {
      setState(() {
        h += 's';
      });
    }
    if (minutes > 1) {
      setState(() {
        m += 's';
      });
    }

    // Use the DatePicker plugin to select timer's properties
    return FlatButton(
      child: Text(
        '$hours $h $minutes $m',
        style: style.copyWith(fontSize: 30, color: lightColor),
      ),
      onPressed: () {
        DatePicker.showTimePicker(context,
            showTitleActions: true,
            showSecondsColumn: false, onChanged: (date) {
          print('change $date in time zone ' +
              date.timeZoneOffset.inHours.toString());
        }, onConfirm: (date) {
          print('confirm $date');
          setState(() {
            hours = date.hour;
            minutes = date.minute;
          });
        }, currentTime: _customDate);
      },
    );
  }

  Widget pageComponent() {
    if (timer != null && timer.isActive) {
      return Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  info ?? 'Nothing yet.',
                  style: TextStyle(
                      color: lightColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width / 20),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
              ),
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
                            "Stop",
                            style: TextStyle(
                                color: lightColor,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width / 10),
                          ),
                        ),
                        Icon(Icons.play_circle_filled,
                            size: 45, color: primaryColor),
                      ],
                    ),
                  ),
                  onPressed: () {
                    stopTimer();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Text('Timer',
                style: style.copyWith(color: lightColor, fontSize: 30)),
            pageTimeRangeSelection(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 5,
            ),
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
                          "Start",
                          style: TextStyle(
                              color: lightColor,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width / 10),
                        ),
                      ),
                      Icon(Icons.play_circle_filled,
                          size: 45, color: primaryColor),
                    ],
                  ),
                ),
                onPressed: () {
                  launchTimer();
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
