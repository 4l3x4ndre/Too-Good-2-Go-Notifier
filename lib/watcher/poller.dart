import './api.dart' as api;
import './notifier.dart' as notifier;
import 'package:http/http.dart' as http;

class Poller {
  Future<String> pollFavoriteBusinesses() async {
    // Await to log the user in.
    await api.Api().login();

    // Get the api response.
    http.Response responseBusinesses = await api.Api().listFavoriteBusinesses();

    // Return the message to show in the app
    return notifier.Notifier().fromJsontoList(json: responseBusinesses.body);
  }
}
