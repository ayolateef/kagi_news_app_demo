import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/aircle_card.dart';


import 'article_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text('Favorites', style: Theme.of(context).textTheme.headlineSmall),
            ),
            Expanded(
              child: newsProvider.favorites.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 64.sp, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text(
                      'No favorites yet',
                      style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Add articles by tapping the heart icon',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: newsProvider.favorites.length,
                itemBuilder: (context, index) {
                  final article = newsProvider.favorites[index];
                  return ArticleCard(
                    article: article,
                    onTap: () => ArticleDetailScreen.show(context, article),
                    onFavoriteToggle: () => newsProvider.toggleFavorite(article),
                    isFavorite: true, // Always true in FavoritesScreen
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}