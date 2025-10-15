import 'package:flutter/material.dart';
import 'dart:math';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with TickerProviderStateMixin {
  final List<String> _notes = [];
  final TextEditingController _controller = TextEditingController();
  late AnimationController _heartsController;
  final Random _random = Random();
  List<_Heart> _hearts = [];

  final Color pink = const Color(0xFFFF6F91);
  final Color blue = const Color(0xFF4FC3F7);
  final Color navy = const Color(0xFF1C1C2E);
  final Color orange = const Color(0xFFFFA726);

  @override
  void initState() {
    super.initState();

    // Floating hearts animation
    _heartsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    for (int i = 0; i < 20; i++) {
      _hearts.add(
        _Heart(
          x: _random.nextDouble(),
          size: 15 + _random.nextDouble() * 25,
          opacity: 0.2 + _random.nextDouble() * 0.6,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _heartsController.dispose();
    super.dispose();
  }

  Widget _buildFloatingHeart(_Heart heart) {
    return AnimatedBuilder(
      animation: _heartsController,
      builder: (context, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        final progress = (_heartsController.value + heart.x) % 1.0;
        final top = screenHeight * (1 - progress);
        final drift = sin(progress * 2 * pi) * 30.0;

        return Positioned(
          left: (heart.x * screenWidth) + drift,
          top: top,
          child: Opacity(
            opacity: (1 - progress) * heart.opacity,
            child: Transform.rotate(
              angle: progress * 2 * pi,
              child: Icon(
                Icons.favorite,
                color: Colors.pinkAccent.withOpacity(heart.opacity),
                size: heart.size,
              ),
            ),
          ),
        );
      },
    );
  }

  void _addNote() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _notes.insert(0, text);
      });
      _controller.clear();
    }
  }

  void _deleteNoteAt(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: pink,
        title: const Text(
          "Love Notes",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Floating hearts
          ..._hearts.map(_buildFloatingHeart),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Input field
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [pink.withOpacity(0.1), blue.withOpacity(0.1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: pink.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: TextStyle(color: navy),
                            decoration: InputDecoration(
                              hintText: "Write a love note...",
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: pink),
                          onPressed: _addNote,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Notes list
                  Expanded(
                    child: _notes.isEmpty
                        ? Center(
                      child: Text(
                        "No notes yet 💕\nWrite something sweet!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: navy.withOpacity(0.6),
                          fontSize: 16,
                        ),
                      ),
                    )
                        : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(_notes[index]),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => _deleteNoteAt(index),
                          background: Container(
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  pink.withOpacity(0.3),
                                  blue.withOpacity(0.2)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: pink.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              _notes[index],
                              style: TextStyle(
                                color: navy,
                                fontSize: 16,
                                height: 1.4,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Floating Heart Model ---
class _Heart {
  final double x;
  final double size;
  final double opacity;
  double y = 0;
  _Heart({required this.x, required this.size, required this.opacity});
}
