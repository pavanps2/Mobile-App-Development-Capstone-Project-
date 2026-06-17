import 'dart:convert';

import 'package:http/http.dart' as http;

/// A motivational quote fetched from an external API.
class Quote {
  final String text;
  final String author;
  const Quote({required this.text, required this.author});
}

/// External API integration for Habitt.
///
/// Calls the public DummyJSON quotes endpoint over HTTPS and decodes the
/// JSON response into a [Quote]. This is the app's API-integration layer;
/// the fetched data is displayed on the Settings screen ("Daily Quote")
/// and used as the motivational banner.
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  static const String _baseUrl = 'https://dummyjson.com';

  /// Fetches a single random motivational quote from the API.
  Future<Quote> fetchRandomQuote() async {
    final uri = Uri.parse('$_baseUrl/quotes/random');
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Quote(
        text: (data['quote'] ?? '') as String,
        author: (data['author'] ?? 'Unknown') as String,
      );
    } else {
      throw Exception(
          'Failed to load quote (HTTP ${response.statusCode}).');
    }
  }
}
