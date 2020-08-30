/**
 * WARNING:
 * This file is not use anymore and was meant to test and debug more easly.
 * As a lot of modifications were made, this file is no longer used.
 * But it still here to remind me how it was done, and in case I need to debug
 * each function individually.
 */

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:workmanager/workmanager.dart';

import '../watcher/api.dart' as api;
import '../watcher/poller.dart' as poller;
import '../watcher/notifier.dart' as notifier;

enum _Platform { android, ios }

class PlatformEnabledButton extends RaisedButton {
  final _Platform platform;

  PlatformEnabledButton({
    this.platform,
    @required Widget child,
    @required VoidCallback onPressed,
  })  : assert(child != null, onPressed != null),
        super(
            child: child,
            onPressed: (Platform.isAndroid && platform == _Platform.android ||
                    Platform.isIOS && platform == _Platform.ios)
                ? onPressed
                : null);
}

class StartPage extends StatefulWidget {
  StartPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StartPageState createState() => _StartPageState();
}

const simpleTaskKey = "simpleTask";
const simplePeriodicTask = "periodicTask";

void printPeriodic() {
  print("hey");
}

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) async {
    switch (taskName) {
      case simpleTaskKey:
        print("$simpleTaskKey was executed. inputData = $inputData");
        break;
      case simplePeriodicTask:
        print("#####################################");
        print("$simplePeriodicTask was executed. inputData = $inputData");
        break;
    }

    return Future.value(true);
  });
}

class _StartPageState extends State<StartPage> {
  Future<api.Api> futureApiData;
  Timer timer;

  @override
  void initState() {
    super.initState();
    // futureApiData = api.fetchBusinesses();
  }

  void stopTimer() {
    print("Timer has stopped");
    timer?.cancel();
  }

  void launchTimer() {
    timer = Timer.periodic(Duration(seconds: 300), (Timer t) => endOfTimer());
  }

  void endOfTimer() {
    // notifier.Notifier().fetchList();
    print("Start fetching...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[500],
      body: Center(
        child: Container(
          child: FutureBuilder<api.Api>(
            future: futureApiData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /*
                    Text("Plugin initialization",
                        style: Theme.of(context).textTheme.headline5),
                    RaisedButton(
                        child: Text("Start the Flutter background service"),
                        onPressed: () {
                          Workmanager.initialize(
                            callbackDispatcher,
                            isInDebugMode: true,
                          );
                        }),
                    Text("Periodic Tasks (Android only)",
                        style: Theme.of(context).textTheme.headline5),
                    //This task runs periodically
                    //It will wait at least 10 seconds before its first launch
                    //Since we have not provided a frequency it will be the default 15 minutes
                    PlatformEnabledButton(
                        platform: _Platform.android,
                        child: Text("Register Periodic Task"),
                        onPressed: () {
                          Workmanager.registerPeriodicTask(
                              "3", simplePeriodicTask,
                              inputData: <String, dynamic>{
                                'int': 1,
                                'bool': true,
                                'double': 1.0,
                                'string': 'string',
                                'array': [1, 2, 3],
                              },
                              initialDelay: Duration(seconds: 10),
                              frequency: Duration(minutes: 15));
                        }),
                    PlatformEnabledButton(
                      platform: _Platform.android,
                      child: Text("Cancel All"),
                      onPressed: () async {
                        await Workmanager.cancelAll();
                        print('Cancel all tasks completed');
                      },
                    ),*/
                    Text(snapshot.data.body),
                    MaterialButton(
                        child: Text("API LOGIN"),
                        onPressed: () {
                          //api.Api().login();
                          poller.Poller().pollFavoriteBusinesses();
                        },
                        color: Colors.amberAccent),
                    MaterialButton(
                        child: Text("GET JSON"),
                        onPressed: () {
                          notifier.Notifier().fromJsontoList();
                        },
                        color: Colors.amberAccent),
                    MaterialButton(
                        child: Text("SEND NOTIFICATION"),
                        onPressed: () {
                          notifier.Notifier()
                              .showNotification("moan titre", "mon corps");
                        },
                        color: Colors.amberAccent),
                    MaterialButton(
                        child: Text("SEND REPEAT NOTIFICATIONs"),
                        onPressed: () {
                          // poller.Poller().startRepeatAction();
                        },
                        color: Colors.amberAccent),
                    MaterialButton(
                        child: Text("START TIMER"),
                        onPressed: () {
                          launchTimer();
                        },
                        color: Colors.amberAccent),
                    MaterialButton(
                      child: Text("STOP TIMER"),
                      onPressed: () {
                        stopTimer();
                      },
                      color: Colors.amberAccent,
                    ),
                    MaterialButton(
                      child: Text("MANUAL FETCH"),
                      onPressed: () {
                        stopTimer();
                      },
                      color: Colors.amberAccent,
                    )
                  ],
                ));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
