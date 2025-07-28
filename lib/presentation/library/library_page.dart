import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Bibliothèque',
        style: TextStyle(
          fontSize: 28,
          color: Color(0xFF7B5E57),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
