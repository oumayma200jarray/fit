import 'dart:convert';

import 'package:fit/ExerciseVideo.dart';
import 'package:http/http.dart' as http;
class Apiservice {
  static const String baseUrl = "http://localhost:1337/api";

  Future<List<ExerciseVideo>> fetchDebutants() async {
    return _fetchVideosFromEndpoint('exercicesdebutants');
  }

  Future<List<ExerciseVideo>> fetchIntermediaires() async {
    return _fetchVideosFromEndpoint('exercicesintermediaires');
  }

  Future<List<ExerciseVideo>> fetchAvances() async {
    return _fetchVideosFromEndpoint('exercicesavancees');
  }

  Future<List<ExerciseVideo>> _fetchVideosFromEndpoint(String endpoint) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$endpoint?populate=*"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> jsonList = responseData['data'] ?? [];
        return jsonList.map((json) => ExerciseVideo.fromJson(json)).toList();
      } else {
        throw Exception("Erreur HTTP ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur fetch $endpoint: $e");
      return []; // retourne liste vide si erreur
    }
  }
}
