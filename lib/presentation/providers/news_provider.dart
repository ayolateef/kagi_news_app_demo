import 'package:flutter/material.dart';
import '../../data/models/news_model.dart';
import '../../data/services/api_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



class NewsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Categories> _categories = [];
  List<Article> _articles = [];
  List<Article> _favorites = [];
  String? _selectedCategoryFile;
  bool _isLoading = false;
  int? _timestamp;
  ThemeMode _themeMode = ThemeMode.light;
  int _currentIndex = 0;

  List<Categories> get categories => _categories;
  List<Article> get articles => _articles;
  List<Article> get favorites => _favorites;
  String? get selectedCategoryFile => _selectedCategoryFile;
  bool get isLoading => _isLoading;
  int? get timestamp => _timestamp;
  ThemeMode get themeMode => _themeMode;
  int get currentIndex => _currentIndex;

  NewsProvider() {
    _loadCategories();
    _loadFavorites();
  }

  Future<void> _loadCategories() async {
    _setLoading(true);
    try {
      final categoryModel = await _apiService.fetchCategories();
      _timestamp = categoryModel.timestamp;
      _categories = categoryModel.categories ?? [];
      if (_categories.isNotEmpty) {
        _selectedCategoryFile = _categories.first.file;
        await fetchArticles(_selectedCategoryFile!);
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
    _setLoading(false);
  }

  Future<void> fetchArticles(String categoryFile) async {
    _setLoading(true);
    try {
      final response = await _apiService.fetchArticles(categoryFile);

      _articles = response.clusters?.expand<Article>((cluster) => cluster.articles ?? []).toList() ?? [];
      _selectedCategoryFile = categoryFile;
    } catch (e) {
      debugPrint('Error loading articles: $e');
      _articles = [];
    }
    _setLoading(false);
  }


  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteJson = prefs.getString('favorites');
      if (favoriteJson != null) {
        final List<dynamic> decoded = jsonDecode(favoriteJson);
        _favorites = decoded.map((json) => Article.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteJson = jsonEncode(_favorites.map((article) => article.toJson()).toList());


      await prefs.setString('favorites', favoriteJson);


    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  bool isFavorite(Article article) => _favorites.any((fav) => fav.link == article.link);

  void toggleFavorite(Article article) {
    if (isFavorite(article)) {
      _favorites.removeWhere((fav) => fav.link == article.link);
    } else {
      _favorites.add(article);
    }
    _saveFavorites();
    notifyListeners();
  }

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}