import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'account/account_page.dart';
import 'books/books_page.dart';
import 'formations/formations_page.dart';
import 'home/home_page.dart';
import 'library/library_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    HomePage(),
    BooksPage(),
    FormationsPage(),
    LibraryPage(),
    AccountPage(),
  ];

  final List<Color> buttonColors = [
    Color(0xFFE6FFDE),
    Color(0xFFD6F0FF),
    Color(0xFFFFF7D6),
    Color(0xFFFFE5D6),
    Color(0xFFFFE6E6),
  ];

  final List<Color> activeIconColors = [
    Color(0xFF388E3C), // Accueil (vert foncé)
    Color(0xFF1976D2), // Livres (bleu foncé)
    Color(0xFFF57C00), // Formations (orange vif)
    Color(0xFF7B5E57), // Bibliothèque (marron)
    Color(0xFFD32F2F), // Compte (rouge vif)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        items: List.generate(
          5,
          (i) => _NavBarIcon(
            icon: [
              Icons.home,
              Icons.menu_book,
              Icons.school,
              Icons.library_books,
              Icons.person,
            ][i],
            index: i,
            isActive: selectedIndex == i,
            activeColor: buttonColors[i],
            activeIconColor: activeIconColors[i],
          ),
        ),
        color: Colors.white,
        buttonBackgroundColor: buttonColors[selectedIndex],
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOutExpo,
        animationDuration: Duration(milliseconds: 500),
        onTap: (i) => setState(() => selectedIndex = i),
        height: 65,
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final IconData icon;
  final int index;
  final bool isActive;
  final Color activeColor;
  final Color activeIconColor;
  const _NavBarIcon({
    required this.icon,
    required this.index,
    required this.isActive,
    required this.activeColor,
    required this.activeIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      decoration: isActive
          ? BoxDecoration(
              color: activeColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: activeColor.withOpacity(0.18), blurRadius: 16),
              ],
            )
          : null,
      padding: EdgeInsets.all(isActive ? 8 : 0),
      child: Icon(
        icon,
        size: 30,
        color: isActive ? activeIconColor : Color(0xFF222222),
      ),
    );
  }
}
