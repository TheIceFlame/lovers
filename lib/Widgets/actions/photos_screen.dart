import 'package:flutter/material.dart';
import 'dart:math';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({Key? key}) : super(key: key);

  @override
  _PhotosScreenState createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> with TickerProviderStateMixin {
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
        title: const Text("Shared Photos", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          ..._hearts.map(_buildFloatingHeart),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                itemCount: 8,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage("assets/images/mem${(index % 5) + 1}.jpg"),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: pink.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
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
