import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:burki_book/presentation/auth/pages/signup_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      title: 'Découvrez des livres pour tous',
      description:
          'Accédez à une large bibliothèque de livres numériques (PDF, ePub, audio) adaptés à vos besoins.',
      lottieAsset: 'assets/onboarding_animations/reading.json',
      bgColor: Color(0xFFFFF3E0), // Or pâle
      accentColor: Color(0xFF388E3C), // Vert Burkina
    ),
    _OnboardingData(
      title: 'Formez-vous en ligne',
      description:
          'Suivez des formations variées, interactives et certifiantes, accessibles à tout moment.',
      lottieAsset: 'assets/onboarding_animations/learning.json',
      bgColor: Color(0xFFE8F5E9), // Vert très clair
      accentColor: Color(0xFFD32F2F), // Rouge Burkina
    ),
    _OnboardingData(
      title: 'Sécurité & Confidentialité',
      description:
          'Vos données et achats sont protégés. Profitez d’une expérience fiable et sécurisée.',
      lottieAsset: 'assets/onboarding_animations/data_protection.json',
      bgColor: Color(0xFFF5F5F5), // Blanc/gris clair
      accentColor: Color(0xFFFFD600), // Jaune Burkina
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Get.off(() => SignUpPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: _pages[_currentPage].bgColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final data = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 32.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(data.lottieAsset, height: 250),
                          SizedBox(height: 32),
                          Text(
                            data.title,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: data.accentColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 18),
                          Text(
                            data.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _buildDot(index),
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pages[_currentPage].accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? 'Commencer'
                          : 'Suivant',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 6),
      width: _currentPage == index ? 18 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? _pages[index].accentColor
            : Colors.grey[400],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String description;
  final String lottieAsset;
  final Color bgColor;
  final Color accentColor;

  _OnboardingData({
    required this.title,
    required this.description,
    required this.lottieAsset,
    required this.bgColor,
    required this.accentColor,
  });
}
