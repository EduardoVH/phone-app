import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../shared/constants.dart';

class StarWarsService {
  Future<List<dynamic>> fetchStarWarsCharacters() async {
    final url = Uri.parse(Constants.starWarsApiUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load characters');
    }
  }
}
