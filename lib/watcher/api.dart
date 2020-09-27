// The api is based on a GitHub repository available here:
// https://github.com/marklagendijk/node-toogoodtogo-watcher
//
// I have done some changes because of dart compatibility but
// it is not the best "fluterrest" way to do things.

import 'dart:convert';

import 'package:http/http.dart' as http;
import './config.dart';

class Api {
  String url = 'https://apptoogoodtogo.com/api';
  final String body;
  final Config config = Config();

  Api({this.body});

  Future<http.Response> request(_url, _headers, _json) async {
    return await http.post(url + _url, headers: _headers, body: _json);
  }

  Future<bool> login() async {
    // Get user's information from GlobalConf plugin
    final session = {
      "userId": await getSession("session-userId"),
      "accessToken": await getSession("session-accessToken"),
      "refreshToken": await getSession("session-refreshToken"),
    };

    // Return a different function according to whether or not the user
    // already login once.
    if (session['refreshToken'] != null && session['refreshToken'] != '') {
      return await refreshToken();
    } else {
      return await loginByEmail();
    }
  }

  Future<bool> loginByEmail() async {
    // Get user's information from GlobalConf plugin
    String email = await config.getValue("email");
    String password = await config.getValue("password");

    http.Response response = await http.post(
      url + '/auth/v1/loginByEmail',
      headers: <String, String>{
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Content-type": "application/json",
        "Accept-Language": "en-US"
      },
      body: jsonEncode(<String, String>{
        "device_type": "UNKNOWN",
        "email": email,
        "password": password
      }),
    );

    // Return if we got reponse
    bool success = createSession(response.body);
    if (!success) {
      return false;
    }

    return true;
  }

  Future<bool> refreshToken() async {
    // Get user's information from GlobalConf plugin
    final sessionRToken = await config.getValue("session-refreshToken");

    http.Response response = await http.post(
      url + '/auth/v1/token/refresh',
      headers: <String, String>{
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Content-type": "application/json",
        "Accept-Language": "en-US"
      },
      body: jsonEncode(<String, String>{'refresh_token': sessionRToken}),
    );

    updateSession(response.body);
    return true;
  }

  // Get the shops wich are listed favorite in the Too Good To Go app.
  Future<http.Response> listFavoriteBusinesses() async {
    // Get user's information from GlobalConf plugin
    final String sessionToken = await getSession("session-accessToken");
    final String sessionUserId = await getSession("session-userId");

    http.Response response = await http.post(
      url + '/item/v5/',
      headers: <String, String>{
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Accept-Language": "en-US",
        'Authorization': 'Bearer ' + sessionToken
      },
      body: jsonEncode(<String, dynamic>{
        'favorites_only': true,
        'origin': {'latitude': 52.5170365, 'longitude': 13.3888599},
        'radius': 200,
        'user_id': int.parse(sessionUserId)
      }),
    );
    updateSession(response.body);
    return response;
  }

  Future<String> getSession(value) async {
    // Get value from GlobalConf plugin
    return await config.getValue(value);
  }

  bool createSession(login) {
    final loginjson = jsonDecode(login);

    if (jsonEncode(loginjson) == '{"errors":[{"code":"FAILED_LOGIN"}]}') {
      return false;
    }

    // Set user's information from storage plugin
    config.setConfig('session-userId',
        loginjson["startup_data"]["user"]["user_id"].toString());
    config.setConfig('session-accessToken', loginjson['access_token']);
    config.setConfig('session-refreshToken', loginjson['refresh_token']);

    return true;
  }

  void updateSession(token) {
    if (jsonDecode(token)['access_token'] == null) return;
    // Update user's information from GlobalConf plugin
    config.setConfig('session-accessToken', jsonDecode(token)['access_token']);
    return token;
  }

  factory Api.fromJson(Map<String, dynamic> json) {
    return Api(body: json.toString());
  }
}
