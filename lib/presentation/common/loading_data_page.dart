import 'package:burki_book/presentation/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LoadingDataPage extends StatefulWidget {
  const LoadingDataPage({Key? key}) : super(key: key);

  @override
  State<LoadingDataPage> createState() => _LoadingDataPageState();
}

class _LoadingDataPageState extends State<LoadingDataPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.92,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    Future.delayed(const Duration(seconds: 5), () {
      Get.offAll(() => MainNavigation());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF388E3C), Color(0xFFFFD600)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF388E3C).withOpacity(0.08),
                      blurRadius: 24,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset(
                    'assets/logo_animer.gif',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Bienvenue sur Burki Book',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF388E3C),
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Chargement de votre espace personnalisé...\nProfitez de la culture, de la découverte et de la formation !',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 28),
            LinearProgressIndicator(
              minHeight: 6,
              backgroundColor: Color(0xFFFFD600).withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF388E3C)),
            ),
          ],
        ),
      ),
    );
  }
}
