import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pdf_maker_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInLogo;
  late Animation<double> _fadeInText;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeInLogo = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _fadeInText = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => HomeScreen());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 30),
            FadeTransition(
              opacity: _fadeInLogo,
              child: Center(
                child: SvgPicture.asset(
                  "assets/svgs/pdf.svg",
                  height: Get.height * 0.25,  // Increased size for a modern look
                ),
              ),
            ),
            const Spacer(flex: 5),
            FadeTransition(
              opacity: _fadeInText,
              child: const Text(
                "PDFMaker",
                style: TextStyle(
                    fontSize: 32,  // Slightly larger for a bolder look
                    fontWeight: FontWeight.bold,
                    color: Colors.white,  // White text for contrast
                    letterSpacing: 1.5),
              ),
            ),
            const Spacer(flex: 50),
            FadeTransition(
              opacity: _fadeInText,
              child: const Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Designed by Rensith Udara Gonalagoda",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70),  // Softer white for subtitle text
                ),
              ),
            ),
            const Spacer(flex: 6),
          ],
        ),
      ),
    );
  }
}
