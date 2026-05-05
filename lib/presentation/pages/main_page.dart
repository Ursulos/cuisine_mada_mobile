import 'package:flutter/material.dart';
import 'package:cuisine_mada/presentation/pages/home/home_page.dart';
import 'package:cuisine_mada/presentation/pages/explore/explore_page.dart';
import 'package:cuisine_mada/presentation/pages/history/history_page.dart';
import 'package:cuisine_mada/presentation/pages/preferences/preferences_page.dart';
import 'package:cuisine_mada/presentation/pages/add_recipe/add_recipe_page.dart';
import 'package:cuisine_mada/presentation/widgets/navigation/bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ExplorePage(),
    SizedBox(),
    HistoryPage(),
    PreferencesPage(),
  ];

  void _onNavTap(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AddRecipePage(),
        ),
      );
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}