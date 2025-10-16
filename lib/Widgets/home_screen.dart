import 'package:flutter/material.dart';
import 'dart:math';

import 'package:lover/Shared/modern_bottom_nav.dart';
import 'package:lover/Widgets/actions/calendar_screen.dart';
import 'package:lover/Widgets/actions/chat_screen.dart';
import 'package:lover/Widgets/actions/notes_screen.dart';
import 'package:lover/Widgets/actions/photos_screen.dart';
import 'package:lover/Widgets/settings_and_more/SettingsScreen.dart';

class HomeScreen extends StatefulWidget {
  final String? userName;
  HomeScreen({this.userName});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController? _heartsController;
  AnimationController? _pulseController;
  final Random _random = Random();
  List<_Heart> _hearts = [];

  @override
  void initState() {
    super.initState();

    // Floating hearts animation
    _heartsController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    )..repeat();

    // Pulse animation for stats
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    for (int i = 0; i < 25; i++) {
      _hearts.add(_Heart(
        x: _random.nextDouble(),
        size: 12 + _random.nextDouble() * 20,
        opacity: 0.15 + _random.nextDouble() * 0.4,
        delay: _random.nextDouble(),
      ));
    }
  }

  @override
  void dispose() {
    _heartsController?.dispose();
    _pulseController?.dispose();
    super.dispose();
  }

  Widget _buildFloatingHeart(_Heart heart) {
    return AnimatedBuilder(
      animation: _heartsController!,
      builder: (context, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final progress = (_heartsController!.value + heart.delay) % 1.0;
        final top = screenHeight - (progress * (screenHeight + 100));

        return Positioned(
          left: heart.x * MediaQuery.of(context).size.width - heart.size / 2,
          top: top,
          child: Transform.rotate(
            angle: sin(progress * pi * 4) * 0.2,
            child: Opacity(
              opacity: heart.opacity * (1 - progress),
              child: Icon(
                Icons.favorite,
                color: Colors.pinkAccent,
                size: heart.size,
              ),
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
    final purple = Color(0xFFBA68C8);

    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      drawer: _buildDrawer(context, pink, blue, navy, purple, orange),
      body: Stack(
        children: [
          // Animated gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink.shade50.withOpacity(0.3),
                  Colors.blue.shade50.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Floating hearts
          ..._hearts.map(_buildFloatingHeart),

          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enhanced Greeting with icon
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$greeting",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "${widget.userName ?? 'Love'} 💖",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: navy,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [pink, Colors.pink.shade300],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: pink.withOpacity(0.4),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(Icons.favorite, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                  SizedBox(height: 28),

                  // Enhanced Couple Stats with pulse animation
                  AnimatedBuilder(
                    animation: _pulseController!,
                    builder: (context, child) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.white.withOpacity(0.95)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: pink.withOpacity(0.2),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: pink.withOpacity(0.15),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: _enhancedStatColumn(
                                "Days Together",
                                "120",
                                pink,
                                Icons.calendar_today_rounded,
                                _pulseController!.value,
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 1,
                              color: Colors.grey[300],
                            ),
                            Expanded(
                              child: _enhancedStatColumn(
                                "Love Notes",
                                "58",
                                purple,
                                Icons.edit_note_rounded,
                                _pulseController!.value,
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 1,
                              color: Colors.grey[300],
                            ),
                            Expanded(
                              child: _enhancedStatColumn(
                                "Photos",
                                "34",
                                orange,
                                Icons.photo_camera_rounded,
                                _pulseController!.value,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 28),

                  // Enhanced Daily Love Quote
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          pink.withOpacity(0.8),
                          Colors.pink.shade400.withOpacity(0.8)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: pink.withOpacity(0.4),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.format_quote_rounded,
                          color: Colors.white.withOpacity(0.9),
                          size: 32,
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Daily Love Quote",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Love is not about how many days, weeks, or months you've been together, it's about how much you love each other every single day.",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28),

                  // Enhanced Quick Action Cards
                  Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _enhancedActionCard(
                          Icons.note_alt_rounded,
                          "Notes",
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
                        child: _enhancedActionCard(
                          Icons.photo_library_rounded,
                          "Photos",
                          blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PhotosScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _enhancedActionCard(
                          Icons.favorite_rounded,
                          "Calendar",
                          purple,
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
                        child: _enhancedActionCard(
                          Icons.chat_bubble_rounded,
                          "Chat",
                          orange,
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
                  SizedBox(height: 28),

                  // Enhanced Love Challenges
                  Text(
                    "🌸 Love Challenges",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final colors = [pink, blue, purple, orange];
                        final icons = [
                          Icons.restaurant_rounded,
                          Icons.mail_rounded,
                          Icons.camera_alt_rounded,
                          Icons.card_giftcard_rounded,
                        ];
                        final titles = [
                          "Plan Date Night",
                          "Send a Note",
                          "Share a Photo",
                          "Surprise Gift"
                        ];
                        return Container(
                          width: 160,
                          margin: EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              colors: [
                                colors[index],
                                colors[index].withOpacity(0.7)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colors[index].withOpacity(0.4),
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -20,
                                top: -20,
                                child: Icon(
                                  icons[index],
                                  size: 100,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        icons[index],
                                        color: Colors.white,
                                        size: 36,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        titles[index],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 28),

                  // Enhanced Shared Memories
                  Text(
                    "💕 Shared Memories",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 160,
                          margin: EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.grey[200],
                            image: DecorationImage(
                              image: AssetImage("assets/images/mem${index + 1}.jpg"),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            alignment: Alignment.bottomCenter,
                            padding: EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Memory ${index + 1}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
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

  // Beautiful Drawer/Sidebar
  Widget _buildDrawer(BuildContext context, Color pink, Color blue, Color navy, Color purple, Color orange) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [pink.withOpacity(0.1), blue.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Drawer Header
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [pink, Colors.pink.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Menu",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close_rounded, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.favorite, color: pink, size: 50),
                    ),
                    SizedBox(height: 12),
                    Text(
                      widget.userName ?? "Love",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Together Forever 💕",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Menu Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _drawerItem(
                      Icons.home_rounded,
                      "Home",
                      pink,
                          () {
                        Navigator.pop(context);
                      },
                    ),
                    _drawerItem(
                      Icons.note_alt_rounded,
                      "Love Notes",
                      purple,
                          () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NotesScreen()),
                        );
                      },
                    ),
                    _drawerItem(
                      Icons.photo_library_rounded,
                      "Photo Gallery",
                      blue,
                          () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PhotosScreen()),
                        );
                      },
                    ),
                    _drawerItem(
                      Icons.favorite_rounded,
                      "Special Dates",
                      pink,
                          () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CalendarScreen()),
                        );
                      },
                    ),
                    _drawerItem(
                      Icons.chat_bubble_rounded,
                      "Chat",
                      orange,
                          () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatScreen()),
                        );
                      },
                    ),
                    Divider(height: 32, thickness: 1),
                    _drawerItem(
                      Icons.settings_rounded,
                      "Settings",
                      Colors.grey[600]!,
                          () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SettingsScreen()),
                        );
                      },
                    ),
                    _drawerItem(
                      Icons.info_rounded,
                      "About Us",
                      Colors.grey[600]!,
                          () {
                        Navigator.pop(context);
                        // Add about navigation
                      },
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Made for me and you",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Drawer Item
  Widget _drawerItem(IconData icon, String title, Color color, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF1C1C2E),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400], size: 16),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // Stat Column
  Widget _enhancedStatColumn(
      String label, String value, Color color, IconData icon, double pulse) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color.withOpacity(0.8 + pulse * 0.2),
          size: 20,
        ),
        SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            color: color,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Enhanced Action Card
  Widget _enhancedActionCard(
      IconData icon,
      String title,
      Color color, {
        required VoidCallback onTap,
      }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.95)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1C1C2E),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
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
  final double delay;
  double y = 0;
  _Heart({
    required this.x,
    required this.size,
    required this.opacity,
    required this.delay,
  });
}