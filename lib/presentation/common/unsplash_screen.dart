import 'package:flutter/material.dart';

class UnsplashScreen extends StatefulWidget {
  const UnsplashScreen({Key? key}) : super(key: key);

  @override
  State<UnsplashScreen> createState() => _UnsplashScreenState();
}

class _UnsplashScreenState extends State<UnsplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.asset(
                'assets/burki_book.jpg',
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}
