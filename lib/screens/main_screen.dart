import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'report_screen.dart';
import 'profile_screen.dart';
import '../theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const ReportScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],
          
          // Floating Dock Navigation
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowest.withOpacity(0.85),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.onSurface.withOpacity(0.08),
                    blurRadius: 32,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedItemColor: AppTheme.primary,
                  unselectedItemColor: AppTheme.outlineVariant,
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
                    BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: "Reports"),
                    BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profile"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
