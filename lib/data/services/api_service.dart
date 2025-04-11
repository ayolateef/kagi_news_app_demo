import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class ApiService {
  static const String _baseUrl = 'https://kite.kagi.com';
  Future<CategoryModel> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/kite.json'));
    if (response.statusCode == 200) {
      return CategoryModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<NewsClusterResponse> fetchArticles(String categoryFile) async {
    final response = await http.get(Uri.parse('$_baseUrl/$categoryFile'));
    if (response.statusCode == 200) {
      return NewsClusterResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
