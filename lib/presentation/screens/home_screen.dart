import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';

import '../widgets/aircle_card.dart';
import '../widgets/category_selector.dart';


import 'article_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Aggregator'),
        actions: [
          IconButton(
            icon: Icon(newsProvider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => newsProvider.setTheme(
              newsProvider.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
            ),
          ),
        ],
      ),
      body: newsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : newsProvider.articles.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No articles found.'),
            ElevatedButton(
              onPressed: () => newsProvider.fetchArticles(newsProvider.selectedCategoryFile ?? ''),
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : Column(
        children: [
          SizedBox(
            height: 60.h,
            child: CategorySelector(
              categories: newsProvider.categories,
              selectedCategoryFile: newsProvider.selectedCategoryFile,
              onCategorySelected: (categoryFile) => newsProvider.fetchArticles(categoryFile),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: newsProvider.articles.length,
              itemBuilder: (context, index) {
                final article = newsProvider.articles[index];
                return ArticleCard(
                  article: article,
                  onTap: () => ArticleDetailScreen.show(context, article),
                  onFavoriteToggle: () => newsProvider.toggleFavorite(article),
                  isFavorite: newsProvider.isFavorite(article),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}