import 'package:flutter/material.dart';
import 'dart:math';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  late AnimationController _heartsController;
  final Random _random = Random();
  List<_Heart> _hearts = [];

  final Color pink = const Color(0xFFFF6F91);
  final Color blue = const Color(0xFF4FC3F7);
  final Color navy = const Color(0xFF1C1C2E);

  @override
  void initState() {
    super.initState();
    _heartsController = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat();
    for (int i = 0; i < 20; i++) {
      _hearts.add(_Heart(x: _random.nextDouble(), size: 15 + _random.nextDouble() * 25, opacity: 0.2 + _random.nextDouble() * 0.6));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _heartsController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({"sender": "You", "text": text});
    });
    _controller.clear();
  }

  Widget _buildFloatingHeart(_Heart heart) {
    return AnimatedBuilder(
      animation: _heartsController,
      builder: (context, child) {
        final h = MediaQuery.of(context).size.height;
        final w = MediaQuery.of(context).size.width;
        final p = (_heartsController.value + heart.x) % 1.0;
        final top = h * (1 - p);
        final drift = sin(p * 2 * pi) * 30.0;
        return Positioned(
          left: (heart.x * w) + drift,
          top: top,
          child: Opacity(
            opacity: (1 - p) * heart.opacity,
            child: Transform.rotate(
              angle: p * 2 * pi,
              child: Icon(Icons.favorite, color: Colors.pinkAccent.withOpacity(heart.opacity), size: heart.size),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: pink,
        title: const Text("Chat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          ..._hearts.map(_buildFloatingHeart),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isMe = msg["sender"] == "You";
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? pink.withOpacity(0.3) : blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          msg["text"]!,
                          style: TextStyle(color: navy, fontSize: 15),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: pink.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, -3))],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Send a sweet message...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: pink),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Heart {
  final double x;
  final double size;
  final double opacity;
  _Heart({required this.x, required this.size, required this.opacity});
}
