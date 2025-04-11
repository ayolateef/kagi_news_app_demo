import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kagi_news_app_demo/presentation/screens/favorite_screen.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/news_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/explore_screen.dart';

void main() {
  runApp(const NewsAggregatorApp());
}

class NewsAggregatorApp extends StatelessWidget {
  const NewsAggregatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'News Aggregator',
            theme: ThemeData.light(useMaterial3: true).copyWith(
              primaryColor: const Color(0xFF1976D2),
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF1976D2),
                onPrimary: Colors.black87,
                secondary: Color(0xFFCE93D8),
                onSecondary: Colors.black87,
                surface: Color(0xFFFAFAFA),
                onSurface: Colors.black87,
                error: Colors.redAccent,
                onError: Colors.white,
              ),
              scaffoldBackgroundColor: const Color(0xFFFAFAFA),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  backgroundColor: const Color(0xFFCE93D8),
                ),
              ),
            ),
            darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFCE93D8),
                onPrimary: Colors.white,
                secondary: Color(0xFFFFF9C4),
                onSecondary: Colors.black87,
                surface: Color(0xFF212121),
                onSurface: Colors.white,
                error: Colors.redAccent,
                onError: Colors.black,
              ),
              scaffoldBackgroundColor: const Color(0xFF212121),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFCE93D8),
                ),
              ),
            ),
            themeMode: Provider.of<NewsProvider>(context).themeMode,
            home: const MainScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    FavoritesScreen(),
    ExploreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    return Scaffold(
      body: _screens[newsProvider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        ],
        currentIndex: newsProvider.currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: (index) => newsProvider.setCurrentIndex(index),
      ),
    );
  }
}