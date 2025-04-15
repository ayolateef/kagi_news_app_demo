import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

// class ApiService {
//   static const String _baseUrl = 'https://kite.kagi.com';
//   Future<CategoryModel> fetchCategories() async {
//     final response = await http.get(Uri.parse('$_baseUrl/kite.json'));
//     if (response.statusCode == 200) {
//       return CategoryModel.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to load categories');
//     }
//   }
//
//   Future<NewsClusterResponse> fetchArticles(String categoryFile) async {
//     final response = await http.get(Uri.parse('$_baseUrl/$categoryFile'));
//     if (response.statusCode == 200) {
//       return NewsClusterResponse.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to load articles');
//     }
//   }
// }

class ApiService {
  static const String _baseUrl = 'https://kite.kagi.com';
  static const String _newsApiBaseUrl = 'https://newsapi.org/v2';
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<CategoryModel> fetchCategories() async {
    final response = await _client.get(Uri.parse('$_baseUrl/kite.json'));
    if (response.statusCode == 200) {
      return CategoryModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<NewsClusterResponse> fetchArticles(String categoryFile) async {
    final response = await _client.get(Uri.parse('$_baseUrl/$categoryFile'));
    if (response.statusCode == 200) {
      return NewsClusterResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<List<Article>> fetchNewsApiArticles(String category) async {
    final newsApiCategory = category.toLowerCase() == 'all' ? 'general' : category.toLowerCase();
    final response = await _client.get(
      Uri.parse('$_newsApiBaseUrl/top-headlines?category=$newsApiCategory&apiKey=6eb54da6f92744cb81ed409976bcd044'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] != 'ok') {
        throw Exception('NewsAPI error: ${data['message']}');
      }
      return (data['articles'] as List).map((e) => Article(
        title: e['title'] ?? '',
        link: e['url'] ?? '',
        domain: e['source']['name'] ?? '',
        date: e['publishedAt'] ?? '',
        image: e['urlToImage'],
        imageCaption: e['description'],
        videoUrl: e['videoUrl'],
        source: 'NewsAPI',
      )).toList();
    } else {
      throw Exception('Failed to load NewsAPI articles');
    }
  }
}