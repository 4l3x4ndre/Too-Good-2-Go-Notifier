import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:global_configuration/global_configuration.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifier {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> showNotification(String textTitle, String textMessage) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, textTitle, textMessage, platformChannelSpecifics,
        payload: 'item x');
  }

  String filterBusinnessesbyid(businessesList) {
    final decoded = jsonDecode(businessesList);
    final businessesToShow = [];

    for (var i = 0; i < decoded['items'].toList().length; i++) {
      Map<String, dynamic> previous = {"items_available": 0};

      // Get the current store from the list
      final current = decoded['items'].toList()[i];

      // The hasInterestingChange function is based on the original Github repo,
      // but in my case I'm not currently using it.
      if (hasInterestingChange(current, previous) ||
          current['items_available'] >= 1) {
        businessesToShow.add(current['display_name']);
      }
    }

    // If there is/are stores with available items, launch a new notification and
    // setup the text to show in the app.
    String msg = '';
    if (businessesToShow.length > 0) {
      showNotification("Go on Too Good To Go now!",
          "We found some cool products for you, check them out on Too Good To Go!");

      msg = 'We find this that might be good for you:\n';
      for (var b in businessesToShow) {
        msg += '- ' + b.toString();
        if (b != businessesToShow[businessesToShow.length - 1]) {
          msg += ', ' + '\n\n';
        } else {
          msg += '.';
        }
      }
    } else {
      msg = 'Nothing in sight yet.';
    }

    return msg;
  }

  // The hasInterestingChange function is based on the original Github repo,
  // but in my case I'm not currently using it.
  // The goal was to keep trace of the previous call and check if the stocks were
  // increasing or not.
  bool hasInterestingChange(current, previous) {
    int currentStock = current[6];
    int previousStock = previous[6];

    updateBusinessesinConfig(current);

    if (previousStock == 0 && currentStock > 0) {
      return true;
    } else {
      return false;
    }
  }

  // This was meant to store the previous config according to hasInterestingChanges' goal
  void updateBusinessesinConfig(current) async {
    String previousConfig =
        GlobalConfiguration().getString("businessesbyid_old");

    return GlobalConfiguration()
        .updateValue("businessesbyid_old", jsonEncode(current));
  }

  // I keep this function that way in case some debug where necessary.
  Future<String> fromJsontoList({dynamic json}) async {
    if (json != null) {
      return filterBusinnessesbyid(json);
    } else {
      final String _json =
          await rootBundle.loadString('assets/businessbyid.json');
      return filterBusinnessesbyid(_json);
    }
  }
}
