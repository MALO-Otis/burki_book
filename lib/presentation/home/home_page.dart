import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../book/book_detail_page.dart';
import '../cart/cart_page.dart';
import '../books/books_page.dart';

// SUPPRESSION de la logique de navigation locale et de la BottomNavBar
// HomePage devient un simple écran, sans Scaffold ni bottomNavigationBar
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isMobile = width < 600;
    final headerHeight = isMobile ? height * 0.18 : height * 0.13;
    final headerFont = isMobile ? 24.0 : 32.0;
    final searchHeight = isMobile ? 38.0 : 44.0;
    final searchFont = isMobile ? 15.0 : 17.0;
    final searchRadius = isMobile ? 12.0 : 16.0;
    return SafeArea(
      child: Column(
        children: [
          // Header compact, full width, orange dégradé
          Container(
            width: double.infinity,
            height: headerHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF57C00), Color(0xFFFFA726)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              0,
              isMobile ? 18 : 28,
              0,
              isMobile ? 10 : 16,
            ),
            child: Stack(
              children: [
                // Icône panier à droite, badge bien positionné
                Positioned(
                  right: isMobile ? 16 : 32,
                  top: isMobile ? 8 : 16,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => CartPage());
                        },
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: isMobile ? 30 : 36,
                        ),
                      ),
                      Positioned(
                        top: -7,
                        right: -7,
                        child: Container(
                          width: isMobile ? 22 : 26,
                          height: isMobile ? 22 : 26,
                          decoration: BoxDecoration(
                            color: Color(0xFFD32F2F),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '3', // TODO: lier dynamiquement
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 14 : 16,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Texte et search
                Padding(
                  padding: EdgeInsets.only(
                    left: isMobile ? 18 : 32,
                    right: isMobile ? 70 : 120,
                    top: isMobile ? 8 : 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Bonjour, Marie ! ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: headerFont,
                            letterSpacing: 1.1,
                            shadows: [
                              Shadow(color: Colors.black12, blurRadius: 2),
                            ],
                          ),
                          children: [
                            WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(left: 2),
                                child: Text(
                                  '👋',
                                  style: TextStyle(fontSize: headerFont),
                                ),
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isMobile ? 10 : 14),
                      Container(
                        height: searchHeight,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(searchRadius),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(
                              Icons.search,
                              color: Color(0xFFBDBDBD),
                              size: isMobile ? 20 : 24,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                style: TextStyle(fontSize: searchFont),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Rechercher un livre, formation...',
                                  hintStyle: TextStyle(
                                    color: Color(0xFFBDBDBD),
                                    fontSize: searchFont,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Le reste du contenu scrollable
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12.0 : 32.0,
                vertical: 0,
              ),
              children: [
                SizedBox(height: isMobile ? 18 : 28),
                // Catégories
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Catégories',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 18.0 : 22.0,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => BooksPage());
                      },
                      child: Text(
                        'Voir tout',
                        style: TextStyle(
                          color: Color(0xFF388E3C),
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 13 : 15,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 10 : 16),
                Wrap(
                  spacing: isMobile ? 10 : 18,
                  runSpacing: isMobile ? 10 : 16,
                  children: [
                    _categoryCard(
                      'Roman',
                      Icons.menu_book,
                      isMobile ? 15.0 : 17.0,
                      isMobile ? 22.0 : 26.0,
                      isMobile,
                    ),
                    _categoryCard(
                      'Éducation',
                      Icons.school,
                      isMobile ? 15.0 : 17.0,
                      isMobile ? 22.0 : 26.0,
                      isMobile,
                    ),
                    _categoryCard(
                      'Business',
                      Icons.business_center,
                      isMobile ? 15.0 : 17.0,
                      isMobile ? 22.0 : 26.0,
                      isMobile,
                    ),
                    _categoryCard(
                      'Spiritualité',
                      Icons.auto_awesome,
                      isMobile ? 15.0 : 17.0,
                      isMobile ? 22.0 : 26.0,
                      isMobile,
                    ),
                    _categoryCard(
                      'Développement',
                      Icons.auto_graph,
                      isMobile ? 15.0 : 17.0,
                      isMobile ? 22.0 : 26.0,
                      isMobile,
                    ),
                    _categoryCard(
                      'Autres',
                      Icons.category,
                      isMobile ? 15.0 : 17.0,
                      isMobile ? 22.0 : 26.0,
                      isMobile,
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 18 : 28),
                // Promotions
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isMobile ? 12 : 18),
                  margin: EdgeInsets.only(bottom: isMobile ? 14 : 22),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Color(0xFFFFD600), width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '🔥 ',
                            style: TextStyle(
                              fontSize: isMobile ? 13.0 + 2 : 15.0 + 2,
                            ),
                          ),
                          Text(
                            'Promotions en cours',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 13.0 + 2 : 15.0 + 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Jusqu'à -50% sur une sélection de livres et formations",
                        style: TextStyle(
                          fontSize: isMobile ? 11.0 + 2 : 13.0 + 2,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                // Découvertes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Découvertes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 18.0 : 22.0,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Voir tout',
                        style: TextStyle(
                          color: Color(0xFF388E3C),
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 13 : 15,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 10 : 16),
                SizedBox(
                  height: isMobile ? 250 : 300,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _bookCardV2(
                        width: isMobile ? width * 0.42 : 220.0,
                        imgHeight: isMobile ? 90.0 + 40 : 120.0 + 60,
                        titleFont: isMobile ? 13.0 : 16.0,
                        authorFont: isMobile ? 11.0 : 13.0,
                        isMobile: isMobile,
                        title: 'Leadership Moder',
                        author: 'Jean Dupont',
                        image:
                            'https://images.unsplash.com/photo-1512820790803-83ca734da794',
                        type: 'book',
                        isNew: true,
                        isPromotion: false,
                        rating: 4.5,
                        achats: 3 + (DateTime.now().millisecondsSinceEpoch % 8),
                        price: 15000,
                      ),
                      _bookCardV2(
                        width: isMobile ? width * 0.42 : 220.0,
                        imgHeight: isMobile ? 90.0 + 40 : 120.0 + 60,
                        titleFont: isMobile ? 13.0 : 16.0,
                        authorFont: isMobile ? 11.0 : 13.0,
                        isMobile: isMobile,
                        title: 'Formation Marketing',
                        author: 'Sophie Martin',
                        image:
                            'https://images.unsplash.com/photo-1524985069026-dd778a71c7b4',
                        type: 'course',
                        isNew: false,
                        isPromotion: true,
                        rating: 4.7,
                        achats: 3 + (DateTime.now().millisecondsSinceEpoch % 8),
                        price: 2500,
                      ),
                      _bookCardV2(
                        width: isMobile ? width * 0.42 : 220.0,
                        imgHeight: isMobile ? 90.0 + 40 : 120.0 + 60,
                        titleFont: isMobile ? 13.0 : 16.0,
                        authorFont: isMobile ? 11.0 : 13.0,
                        isMobile: isMobile,
                        title: 'Dév. Personnel',
                        author: 'Marc Zida',
                        image:
                            'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
                        type: 'book',
                        isNew: false,
                        isPromotion: false,
                        rating: 4.3,
                        achats: 3 + (DateTime.now().millisecondsSinceEpoch % 8),
                        price: 2500,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 18 : 28),
                // Formations
                _bigCard(
                  icon: Icons.school,
                  color: Color(0xFF388E3C),
                  title: 'Voir Les Formations Disponibles',
                  desc: 'Accédez à nos formations exclusives',
                  padding: isMobile ? 14.0 : 22.0,
                  iconSize: isMobile ? 32.0 : 40.0,
                  fontSize: isMobile ? 15.0 : 18.0,
                  descFont: isMobile ? 12.0 : 14.0,
                  isPremium: false,
                ),
                // Premium
                _bigCard(
                  icon: Icons.workspace_premium,
                  color: Color(0xFFFFD600),
                  title: 'Abonnement Premium',
                  desc: "Profitez de l'expérience Burki Book sans limite !",
                  padding: isMobile ? 14.0 : 22.0,
                  iconSize: isMobile ? 32.0 : 40.0,
                  fontSize: isMobile ? 15.0 : 18.0,
                  descFont: isMobile ? 12.0 : 14.0,
                  isPremium: true,
                ),
                SizedBox(height: isMobile ? 18 : 28),
                // Sélection Pour Vous
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sélection Pour Vous',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 18.0 : 22.0,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Voir tout',
                        style: TextStyle(
                          color: Color(0xFF388E3C),
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 13 : 15,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 10 : 16),
                SizedBox(
                  height: isMobile ? 250 : 300,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _bookCardV2(
                        width: isMobile ? width * 0.42 : 220.0,
                        imgHeight: isMobile ? 90.0 + 40 : 120.0 + 60,
                        titleFont: isMobile ? 13.0 : 16.0,
                        authorFont: isMobile ? 11.0 : 13.0,
                        isMobile: isMobile,
                        title: 'Le Pouvoir du Savoir',
                        author: 'Fatou Traoré',
                        image:
                            'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                        type: 'book',
                        isNew: false,
                        isPromotion: true,
                        rating: 4.8,
                        achats: 3 + (DateTime.now().millisecondsSinceEpoch % 8),
                        price: 2500,
                      ),
                      _bookCardV2(
                        width: isMobile ? width * 0.42 : 220.0,
                        imgHeight: isMobile ? 90.0 + 40 : 120.0 + 60,
                        titleFont: isMobile ? 13.0 : 16.0,
                        authorFont: isMobile ? 11.0 : 13.0,
                        isMobile: isMobile,
                        title: 'Coaching Express',
                        author: 'Moussa Kaboré',
                        image:
                            'https://images.unsplash.com/photo-1516979187457-637abb4f9353',
                        type: 'course',
                        isNew: true,
                        isPromotion: false,
                        rating: 4.6,
                        achats: 3 + (DateTime.now().millisecondsSinceEpoch % 8),
                        price: 2500,
                      ),
                      _bookCardV2(
                        width: isMobile ? width * 0.42 : 220.0,
                        imgHeight: isMobile ? 90.0 + 40 : 120.0 + 60,
                        titleFont: isMobile ? 13.0 : 16.0,
                        authorFont: isMobile ? 11.0 : 13.0,
                        isMobile: isMobile,
                        title: 'Histoires du Faso',
                        author: 'Awa Ouédraogo',
                        image:
                            'https://images.unsplash.com/photo-1465101178521-c1a9136a3b41',
                        type: 'book',
                        isNew: false,
                        isPromotion: false,
                        rating: 4.2,
                        achats: 3 + (DateTime.now().millisecondsSinceEpoch % 8),
                        price: 2500,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isMobile ? 18 : 28),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatFcfa(num value) {
    return NumberFormat('#,##0', 'fr_FR').format(value) + ' FCFA';
  }

  Widget _categoryCard(
    String label,
    IconData icon,
    double font,
    double iconSize,
    bool isMobile,
  ) {
    return Container(
      width: isMobile ? 150 : 180,
      height: isMobile ? 54 : 64,
      decoration: BoxDecoration(
        color: Color(0xFFFDF6ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFF5F5F5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Color(0xFFFFD600).withOpacity(0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Color(0xFFB98000), size: iconSize),
          ),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: font,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookCard(
    double width,
    double imgHeight,
    double titleFont,
    double authorFont,
    double descFont,
    double badgeFont,
    double badgePad,
    double badgeVert,
    bool isMobile, {
    required String title,
    required String author,
    required String image,
    required String badge,
    required int downloads,
    required double rating,
  }) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: isMobile ? 10 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  image,
                  height: imgHeight + (isMobile ? 30 : 40), // image plus longue
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: badgePad,
                    vertical: badgeVert,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFD600).withOpacity(0.92),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: badgeFont,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB98000),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(isMobile ? 8 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titleFont,
                    color: Color(0xFF222222),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  author,
                  style: TextStyle(
                    fontSize: authorFont,
                    color: Color(0xFF388E3C),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'Description courte...',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: descFont, color: Colors.black54),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Color(0xFFFFD600),
                      size: isMobile ? 15 : 18,
                    ),
                    SizedBox(width: 2),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.download,
                      color: Color(0xFF388E3C),
                      size: isMobile ? 15 : 18,
                    ),
                    SizedBox(width: 2),
                    Text(
                      '$downloads',
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bigCard({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
    required double padding,
    required double iconSize,
    required double fontSize,
    required double descFont,
    required bool isPremium,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isPremium ? Color(0xFFFFF8E1) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: isPremium
            ? Border.all(color: Color(0xFFFFD600), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.13),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: iconSize),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: isPremium ? Color(0xFFD32F2F) : Color(0xFF388E3C),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(fontSize: descFont, color: Colors.black87),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: color, size: iconSize * 0.7),
        ],
      ),
    );
  }

  Widget _bookCardV2({
    required double width,
    required double imgHeight,
    required double titleFont,
    required double authorFont,
    required bool isMobile,
    required String title,
    required String author,
    required String image,
    required String type, // 'book' or 'course'
    bool isNew = false,
    bool isPromotion = false,
    required double rating,
    required int achats,
    double? price, // Ajout du prix optionnel
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.to(
          () => BookDetailPage(
            title: title,
            author: author,
            image: image,
            rating: rating,
            achats: achats,
            isNew: isNew,
            isPromotion: isPromotion,
          ),
        );
      },
      child: Container(
        width: width.clamp(140.0, 200.0),
        constraints: BoxConstraints(
          maxWidth: 200,
          maxHeight: isMobile ? 240 : 270,
          minHeight: isMobile ? 210 : 240,
        ),
        margin: EdgeInsets.only(right: isMobile ? 10 : 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Image.network(
                        image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isNew)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFD600),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Nouveau',
                          style: TextStyle(
                            fontSize: isMobile ? 10 : 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF388E3C),
                          ),
                        ),
                      ),
                    ),
                  if (isPromotion)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFD32F2F),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Promo',
                          style: TextStyle(
                            fontSize: isMobile ? 10 : 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    left: isNew ? 80 : 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: type == 'book'
                            ? Color(0xFF388E3C).withOpacity(0.85)
                            : Color(0xFFFF9800).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        type == 'book' ? 'Livre' : 'Formation',
                        style: TextStyle(
                          fontSize: isMobile ? 10 : 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 8 : 12,
                  isMobile ? 6 : 10,
                  isMobile ? 8 : 12,
                  isMobile ? 8 : 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titleFont,
                        color: Color(0xFF222222),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      author,
                      style: TextStyle(
                        fontSize: authorFont,
                        color: Color(0xFF388E3C),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (price != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                        child: Text(
                          formatFcfa(price!),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD32F2F),
                            fontSize: isMobile ? 13 : 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Color(0xFFFFD600),
                          size: isMobile ? 15 : 18,
                        ),
                        SizedBox(width: 2),
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: isMobile ? 12 : 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.shopping_bag,
                          color: Color(0xFF388E3C),
                          size: isMobile ? 15 : 18,
                        ),
                        SizedBox(width: 2),
                        Text(
                          '$achats',
                          style: TextStyle(
                            fontSize: isMobile ? 11 : 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
