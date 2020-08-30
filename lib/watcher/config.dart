// Here I use two different configuration. I could go with one, but as
// I store personal user information wich are related to an private
// account with precious data, I use the Flutter Secure Storage plugin
// to ensure their protection.

import 'package:global_configuration/global_configuration.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Config {
  getValue(key) async {
    String value = '';

    // Check if the value needed is one from the Flutter Secure Storage plugin
    if (key == "email" ||
        key == "password" ||
        key == "timer_seconds" ||
        key == "timer_minutes") {
      final storage = new FlutterSecureStorage();
      value = await storage.read(key: key);
    } else {
      value = GlobalConfiguration().getString(key);
    }
    return value;
  }

  setConfig(key, value) async {
    GlobalConfiguration().updateValue(key, value);

    // Check if the value needed is one from the Flutter Secure Storage plugin
    if (key == "email" ||
        key == "password" ||
        key == "timer_seconds" ||
        key == "timer_minutes") {
      final storage = new FlutterSecureStorage();
      await storage.write(key: key, value: value);
    }
  }
}
