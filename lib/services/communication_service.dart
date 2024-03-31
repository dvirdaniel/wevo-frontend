import 'dart:async';
import 'package:http/http.dart';

const SERVER_URL = 'http://localhost:8080';

class CommunicationService {

  Future<String> fetchData(String value) async {
    var result;
    final response = await get(Uri.parse("$SERVER_URL/feed/$value"));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      result = response.body;
    }
    return result;
  }

  Future<String> fetchSuggestions() async {
    var result;
    final response = await get(Uri.parse("$SERVER_URL/suggestions"));
    if (response.statusCode == 200) {
      result = response.body;
    }
    return result;
  }

}