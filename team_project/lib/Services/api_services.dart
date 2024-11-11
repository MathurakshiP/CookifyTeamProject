import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  // Base URL stored in the .env file for better flexibility
  final String _baseUrl = dotenv.env['SPOONACULAR_BASE_URL'] ?? 'https://api.spoonacular.com/recipes/complexSearch';
  final String _apiKey = dotenv.env['SPOONACULAR_API_KEY'] ?? '';

  // Fetch recipes based on search query
  Future<List<dynamic>> fetchRecipes(String query) async {
    if (query.isEmpty) {
      throw Exception('Query cannot be empty');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl?query=$query&apiKey=$_apiKey'),
    );

    // Improved error handling for different status codes
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'] ?? [];
    } else {
      _handleError(response);
      return [];  // Return an empty list in case of error
    }
  }

  // Fetch details for a specific recipe by ID
  Future<Map<String, dynamic>> fetchRecipeDetails(int id) async {
    if (id <= 0) {
      throw Exception('Invalid recipe ID');
    }

    final response = await http.get(
      Uri.parse('https://api.spoonacular.com/recipes/$id/information?apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      _handleError(response);
      return {};  // Return empty map in case of error
    }
  }

  // Generic error handling based on HTTP status code
  void _handleError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        throw Exception('Bad request: ${response.body}');
      case 401:
        throw Exception('Unauthorized: Check your API key');
      case 404:
        throw Exception('Not found: The requested resource does not exist');
      case 500:
        throw Exception('Server error: Please try again later');
      default:
        throw Exception('Unexpected error: ${response.statusCode}');
    }
  }
}
