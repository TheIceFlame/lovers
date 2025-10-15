import 'package:flutter/material.dart';
import 'dart:math';

import 'package:lover/Shared/modern_bottom_nav.dart';
import 'package:lover/Widgets/actions/calendar_screen.dart';
import 'package:lover/Widgets/actions/chat_screen.dart';
import 'package:lover/Widgets/actions/notes_screen.dart';
import 'package:lover/Widgets/actions/photos_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? userName;
  HomeScreen({this.userName});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _heartsController;
  final Random _random = Random();
  List<_Heart> _hearts = [];

  @override
  void initState() {
    super.initState();

    // Initialize floating hearts
    _heartsController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    )..repeat();

    for (int i = 0; i < 20; i++) {
      _hearts.add(_Heart(
        x: _random.nextDouble(),
        size: 15 + _random.nextDouble() * 25,
        opacity: 0.2 + _random.nextDouble() * 0.6,
      ));
    }
  }

  @override
  void dispose() {
    _heartsController.dispose();
    super.dispose();
  }

  Widget _buildFloatingHeart(_Heart heart) {
    return AnimatedBuilder(
      animation: _heartsController,
      builder: (context, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final top = (screenHeight + 50) *
            ((1 - heart.y) - _heartsController.value) %
            screenHeight;
        return Positioned(
          left: heart.x * MediaQuery.of(context).size.width,
          top: top,
          child: Opacity(
            opacity: heart.opacity,
            child: Icon(
              Icons.favorite,
              color: Colors.pinkAccent.withOpacity(heart.opacity),
              size: heart.size,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pink = Color(0xFFFF6F91);
    final blue = Color(0xFF4FC3F7);
    final navy = Color(0xFF1C1C2E);
    final orange = Color(0xFFFFA726);

    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Floating hearts
          ..._hearts.map(_buildFloatingHeart),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  Text(
                    "$greeting, ${widget.userName ?? 'Love'} ❤️",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: navy),
                  ),
                  SizedBox(height: 24),

                  // Couple Stats
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [pink.withOpacity(0.1), blue.withOpacity(0.1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statColumn("Days Together", "120", pink),
                        _statColumn("Love Notes Sent", "58", blue),
                        _statColumn("Photos Shared", "34", orange),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),

                  // Daily Love Quote
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [pink.withOpacity(0.4), pink.withOpacity(0.4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: navy.withOpacity(0.1),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Daily Love Quote",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: pink),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "\"Love is not about how many days, weeks, or months you’ve been together, it’s about how much you love each other every single day.\"",
                          style: TextStyle(
                              fontSize: 16,
                              color: navy,
                              fontStyle: FontStyle.italic,
                              height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),

                  // Quick Action Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _actionCard(
                          Icons.note_alt,
                          "Notes",
                          pink.withOpacity(0.2),
                          pink,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NotesScreen()),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _actionCard(
                          Icons.photo,
                          "Photos",
                          blue.withOpacity(0.2),
                          blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PhotosScreen()),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _actionCard(
                          Icons.favorite,
                          "Calendar",
                          pink.withOpacity(0.2),
                          pink,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CalendarScreen()),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _actionCard(
                          Icons.chat_bubble,
                          "Chat",
                          blue.withOpacity(0.2),
                          blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChatScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // Love Challenges / Events
                  Text(
                    "🌸 Love Challenges & Events",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: navy),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final colors = [Colors.pink, blue, orange, Colors.pink.shade200];                        final titles = [
                          "Plan Date Night",
                          "Send a Note",
                          "Share a Photo",
                          "Surprise Gift"
                        ];
                        return Container(
                          width: 150,
                          margin: EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                colors: [colors[index].withOpacity(0.4), colors[index].withOpacity(0.2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            boxShadow: [
                              BoxShadow(
                                color: colors[index].withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              titles[index],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 32),

                  // Shared Memories
                  Text(
                    "💕 Shared Memories 💕",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: navy),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 150,
                          margin: EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey[200],
                            image: DecorationImage(
                              image: AssetImage("assets/images/mem${index + 1}.jpg"),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Stat Column
  Widget _statColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 20, color: color, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.black54)),
      ],
    );
  }

  // Quick Action Card
  Widget _actionCard(
      IconData icon,
      String title,
      Color bgColor,
      Color iconColor, {
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: iconColor.withOpacity(0.2),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 70,
        height: 90,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: iconColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 18) return "Good Afternoon";
    return "Good Evening";
  }
}

// Heart model
class _Heart {
  final double x;
  final double size;
  final double opacity;
  double y = 0;
  _Heart({required this.x, required this.size, required this.opacity});
}
