import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lover/Widgets/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();

    // Heartbeat effect
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Floating animation
    _floatController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    )..repeat();

    // Navigate after delay
    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => OnboardingScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 600),
        ),
      );
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pink = Color(0xFFFF6F91);
    final blue = Color(0xFF4FC3F7);
    final navy = Color(0xFF1C1C2E);

    return Scaffold(
      body: Stack(
        children: [
          // floating background hearts
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _FloatingHeartsPainter(_floatController.value),
                );
              },
            ),
          ),

          // main content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      // You can add a background color or image here if needed
                      // color: Colors.grey,
                    ),
                    clipBehavior: Clip.hardEdge, // Needed to make the borderRadius work with the image
                    child: Image.asset(
                      "assets/images/img.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // SizedBox(height: 18),
                // Text(
                //   'Your Private Couple Space',
                //   style: TextStyle(
                //     color: navy,
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter for floating hearts
class _FloatingHeartsPainter extends CustomPainter {
  final double progress;

  _FloatingHeartsPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final pink = Paint()..color = Color(0xFFFF6F91).withOpacity(0.2);
    final blue = Paint()..color = Color(0xFF4FC3F7).withOpacity(0.2);

    final hearts = 6;
    for (int i = 0; i < hearts; i++) {
      final t = (progress + i / hearts) % 1.0;
      final dx = size.width * (0.2 + 0.6 * i / hearts);
      final dy = size.height * (1 - t);
      final radius = 8 + 6 * sin(t * pi);
      canvas.drawCircle(Offset(dx, dy), radius, i.isEven ? pink : blue);
    }
  }

  @override
  bool shouldRepaint(covariant _FloatingHeartsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
