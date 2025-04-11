import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';


class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _interactionCount = 0;

  void _incrementInteraction() {
    setState(() {
      _interactionCount++;
      if (_interactionCount == 3) {
        _showSignupPrompt(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Explore', style: Theme.of(context).textTheme.headlineSmall),
                    ElevatedButton(
                      onPressed: _incrementInteraction,
                      child: Text(
                        'Try Feature',
                        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text('Categories', style: Theme.of(context).textTheme.titleMedium),
              ),
              SizedBox(
                height: 120.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: newsProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = newsProvider.categories[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                      child: GestureDetector(
                        onTap: () {
                          newsProvider.fetchArticles(category.file!);
                          _incrementInteraction(); // Count interaction
                        },
                        child: Container(
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              category.name ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text('Trending (Mock)', style: Theme.of(context).textTheme.titleMedium),
              ),
              SizedBox(
                height: 200.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildTrendingCard('Global News', context),
                    _buildTrendingCard('Tech Updates', context),
                    _buildTrendingCard('Health Tips', context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingCard(String title, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Container(
        width: 150.w,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.trending_up, size: 40.sp),
            SizedBox(height: 8.h),
            Text(title, style: TextStyle(fontSize: 16.sp)),
            SizedBox(height: 4.h),
            Text('Mock Data', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  void _showSignupPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Love the News?'),
        content: const Text('Sign up to save your favorites and get updates on new stories!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signup coming soon!')),
              );
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}