import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:zagel/screens/options.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add any initialization code or navigate to the main screen after a delay
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 2500)); // Wait for 30 seconds
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OptionsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double imageSize =
                constraints.maxWidth * 0.8; // 80% of screen width

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/pigeonlogo.png',
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: 250,
                  child: DefaultTextStyle(
                    style: GoogleFonts.rubikStorm(
                      fontSize: 0.2 * constraints.maxWidth,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.blue,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          'Zagel',
                          speed: const Duration(milliseconds: 160),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 100.0),
                Text(
                  'Developed By',
                  style: GoogleFonts.roboto(
                    fontSize: 0.03 * constraints.maxWidth,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'DezignArena',
                  style: GoogleFonts.roboto(
                    fontSize: 0.04 * constraints.maxWidth,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const AnimatedText({Key? key, required this.text, required this.style})
      : super(key: key);

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Wait for 30 seconds before starting the animation
    Future.delayed(Duration(seconds: 30), () {
      // Initialize the animation controller
      _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
      );

      // Create a size animation
      _animation = Tween<double>(begin: 1.5, end: 1.0).animate(_controller);

      // Start the animation when the widget is inserted into the widget tree
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Text(
            widget.text,
            style: widget.style,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Dispose the animation controller to free up resources
    _controller.dispose();
    super.dispose();
  }
}
