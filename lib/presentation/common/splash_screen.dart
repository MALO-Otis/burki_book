import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:burki_book/onboarding/onboarding_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Get.off(OnboardingPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 180, child: Image.asset('assets/logo_animer.gif')),
            const SizedBox(height: 32),
            Text(
              'Burki Book',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF388E3C),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'La plateforme du savoir et de la culture',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
