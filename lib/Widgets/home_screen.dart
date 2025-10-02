import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  final String? userName;
  HomeScreen({this.userName});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartsController;
  final Random _random = Random();
  List<double> _heartPositions = [];

  @override
  void initState() {
    super.initState();
    // _heartsController =
    // AnimationController(vsync: this, duration: Duration(seconds: 15))
    //   ..repeat();
    //
    // for (int i = 0; i < 15; i++) {
    //   _heartPositions.add(_random.nextDouble());
    // }
  }

  @override
  void dispose() {
    _heartsController.dispose();
    super.dispose();
  }

  Widget _buildFloatingHeart(double position, double size, double opacity) {
    return AnimatedBuilder(
      animation: _heartsController,
      builder: (context, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final top =
            (screenHeight + 50) * ((1 - position) - _heartsController.value) %
                screenHeight;
        return Positioned(
          left: _random.nextDouble() * MediaQuery.of(context).size.width,
          top: top,
          child: Opacity(
            opacity: opacity,
            child: Icon(
              Icons.favorite,
              color: Colors.pinkAccent.withOpacity(opacity),
              size: size,
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

    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Floating hearts
          ..._heartPositions.map((pos) =>
              _buildFloatingHeart(pos, 20 + _random.nextInt(20).toDouble(),
                  0.2 + _random.nextDouble() * 0.5)),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statColumn("Days Together", "120", pink),
                        _statColumn("Love Notes Sent", "58", blue),
                        _statColumn("Photos Shared", "34", Colors.orange),
                      ],
                    ),
                  ),

                  SizedBox(height: 32),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: pink.withOpacity(0.1), // soft pink background
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white, // white border
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Daily Love Quote",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: pink,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 14),
                        Text(
                          "\"Love is composed of a single soul inhabiting two bodies.\"",
                          style: TextStyle(
                            fontSize: 16,
                            color: blue.withOpacity(1),
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32),

                  // Quick action cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _actionCard(Icons.note_alt, "Notes", pink.withOpacity(0.2), pink)),
                      SizedBox(width: 12),
                      Expanded(child: _actionCard(Icons.photo, "Photos", blue.withOpacity(0.2), blue)),
                      SizedBox(width: 12),
                      Expanded(child: _actionCard(Icons.favorite, "Calendar", pink.withOpacity(0.2), pink)),
                      SizedBox(width: 12),
                      Expanded(child: _actionCard(Icons.chat_bubble, "Chat", blue.withOpacity(0.2), blue)),
                    ],
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
                              image:
                              AssetImage("assets/images/mem${index + 1}.jpg"),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              )
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


  // Quick Action Card with gradient
  Widget _actionCard(IconData icon, String title, Color bgColor, Color iconColor) {
    return Container(
      width: 70,
      height: 90,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.25),
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
    );
  }


  // Stat Column with colored value
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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 18) return "Good Afternoon";
    return "Good Evening";
  }
}
