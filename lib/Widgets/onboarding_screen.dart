import 'package:flutter/material.dart';
import 'package:lover/Widgets/GalleryPermissionScreen.dart';
import 'package:lover/Widgets/LoginScreen.dart';
import 'package:lover/Widgets/home_screen.dart';
import 'package:lover/Widgets/splash_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      "icon": Icons.favorite,
      "color": Color(0xFFFF6F91), // pink
      "title": "Welcome to SY Love",
      "subtitle": "Your private couple space where love lives digitally."
    },
    {
      "icon": Icons.photo_camera,
      "color": Color(0xFF4FC3F7), // blue
      "title": "Celebrate Memories",
      "subtitle": "Save photos, notes, and special moments in one place."
    },
    {
      "icon": Icons.local_florist,
      "color": Color(0xFFFF6F91), // pink
      "title": "Grow Together",
      "subtitle": "Take challenges, plan events, and build stronger bonds."
    },
  ];

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _controller.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => GalleryPermissionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final navy = Color(0xFF1C1C2E);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemCount: _pages.length,
                itemBuilder: (_, index) {
                  final page = _pages[index];
                  final Color color = page["color"] as Color;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: color.withOpacity(0.15),
                        child: Icon(
                          page["icon"],
                          color: color,
                          size: 80,
                        ),
                      ),
                      SizedBox(height: 32),
                      Text(
                        page["title"],
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: navy,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          page["subtitle"],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                    (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? _pages[index]["color"]
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            SizedBox(height: 24),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(color: Color(0xFF4FC3F7), fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pages[_currentIndex]["color"],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      _currentIndex == _pages.length - 1
                          ? "Get Started"
                          : "Next",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
