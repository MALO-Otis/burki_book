import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../payment/stripe_payment_page.dart';

class BookDetailPage extends StatelessWidget {
  final String title;
  final String author;
  final String image;
  final double rating;
  final int achats;
  final bool isNew;
  final bool isPromotion;
  final bool hasAudio;
  final bool isPremium;

  const BookDetailPage({
    Key? key,
    required this.title,
    required this.author,
    required this.image,
    required this.rating,
    required this.achats,
    this.isNew = false,
    this.isPromotion = false,
    this.hasAudio = false,
    this.isPremium = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: isMobile ? 320 : 420,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'book_${title.hashCode}',
                    child: Image.network(image, fit: BoxFit.cover),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.45),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 32,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (isNew)
                              _badge(
                                'Nouveau',
                                Color(0xFFFFD600),
                                Color(0xFF388E3C),
                                isMobile,
                              ),
                            if (isPromotion) SizedBox(width: 8),
                            if (isPromotion)
                              _badge(
                                'Promo',
                                Color(0xFFD32F2F),
                                Colors.white,
                                isMobile,
                              ),
                            if (isPremium) SizedBox(width: 8),
                            if (isPremium)
                              _badge(
                                'Premium',
                                Color(0xFF388E3C),
                                Colors.white,
                                isMobile,
                              ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 22 : 30,
                            shadows: [
                              Shadow(color: Colors.black26, blurRadius: 4),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          author,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: isMobile ? 15 : 18,
                          ),
                        ),
                        SizedBox(height: 14),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Color(0xFFFFD600),
                              size: isMobile ? 18 : 22,
                            ),
                            SizedBox(width: 4),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(
                              Icons.shopping_bag,
                              color: Colors.white,
                              size: isMobile ? 18 : 22,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '$achats achats',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share, color: Colors.black87),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.flag, color: Colors.black54),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 40,
                vertical: 18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Actions secondaires au-dessus du résumé
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _mainActionButton(
                        icon: Icons.download,
                        label: 'Télécharger',
                        isMobile: isMobile,
                        color: Color(0xFF388E3C),
                        onTap: () {},
                      ),
                      _mainActionButton(
                        icon: Icons.favorite_border,
                        label: 'Souhaits',
                        isMobile: isMobile,
                        color: Color(0xFFB98000),
                        onTap: () {},
                      ),
                      _mainActionButton(
                        icon: Icons.history,
                        label: 'Voir dans l\'historique',
                        isMobile: isMobile,
                        color: Color(0xFF388E3C),
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  // Résumé long avec bouton déplier/replier
                  const ExpandableSummary(isMobile: false),
                  SizedBox(height: 18),
                  // Card d'achat et actions principales (style maquette)
                  _purchaseCard(context, isMobile),
                  SizedBox(height: 22),
                  // Section audio
                  if (hasAudio) _audioSection(isMobile),
                  // Section détails du livre
                  _BookDetailsCard(isMobile: isMobile),
                  SizedBox(height: 22),
                  // Avis & Commentaires
                  _reviewsSection(isMobile),
                  SizedBox(height: 22),
                  // Recommandations
                  Text(
                    'Vous aimerez aussi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 18 : 22,
                    ),
                  ),
                  SizedBox(height: 10),
                  _recommendationsSlider(isMobile),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String label, Color bg, Color fg, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.bold,
          fontSize: isMobile ? 11 : 13,
        ),
      ),
    );
  }

  Widget _mainActions(BuildContext context, bool isMobile) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _mainActionButton(
              icon: Icons.shopping_bag,
              label: 'Acheter',
              isMobile: isMobile,
              color: Color(0xFFD32F2F),
              onTap: () {
                // Aller à la page de paiement Stripe simulée
                final resume = 'Achat du livre "$title" par $author';
                final montant =
                    24990; // Remplacer par la vraie variable de prix si dispo
                Get.to(
                  () => StripePaymentPage(resume: resume, montant: montant),
                );
              },
              isPrimary: true,
            ),
            _mainActionButton(
              icon: Icons.shopping_cart,
              label: 'Ajouter au panier',
              isMobile: isMobile,
              color: Color(0xFF388E3C),
              onTap: () {},
              isPrimary: true,
            ),
            _mainActionButton(
              icon: Icons.menu_book,
              label: 'Lire un extrait',
              isMobile: isMobile,
              color: Color(0xFFFFD600),
              fgColor: Colors.black,
              onTap: () {},
              isPrimary: true,
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _mainActionButton(
              icon: Icons.favorite_border,
              label: 'Souhaits',
              isMobile: isMobile,
              color: Color(0xFFB98000),
              onTap: () {},
            ),
            _mainActionButton(
              icon: Icons.download,
              label: 'Télécharger',
              isMobile: isMobile,
              color: Color(0xFF388E3C),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _mainActionButton({
    required IconData icon,
    required String label,
    required bool isMobile,
    required Color color,
    Color? fgColor,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(
            icon,
            color: fgColor ?? Colors.white,
            size: isMobile ? 20 : 24,
          ),
          label: Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.bold,
              color: fgColor ?? Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: fgColor ?? Colors.white,
            elevation: isPrimary ? 4 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 10 : 14,
              horizontal: 6,
            ),
          ),
        ),
      ),
    );
  }

  Widget _audioSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Version audio disponible',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 16 : 18,
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.headphones, color: Colors.white),
          label: Text('Écouter la version audio'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF388E3C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
        ),
        SizedBox(height: 18),
      ],
    );
  }

  Widget _reviewsSection(bool isMobile) {
    return Builder(
      builder: (context) {
        double userRating = 0;
        return StatefulBuilder(
          builder: (context, setState) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Avis & Commentaires',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 18 : 22,
                ),
              ),
              SizedBox(height: 10),
              // Étoiles d'évaluation utilisateur en emphase
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                    (i) => GestureDetector(
                      onTap: () {
                        setState(() => userRating = (i + 1).toDouble());
                        Future.delayed(Duration(milliseconds: 200), () {
                          _showAllComments(context: context);
                          Future.delayed(Duration(milliseconds: 350), () {
                            _showCommentDialog(context, userRating);
                          });
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 150),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.star,
                          color: (i < userRating)
                              ? Color(0xFFFFA000)
                              : Colors.grey[300],
                          size: isMobile ? 36 : 44,
                          shadows: [
                            if (i < userRating)
                              Shadow(color: Color(0xFFFFA000), blurRadius: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Color(0xFFFFD600),
                    size: isMobile ? 28 : 34,
                  ),
                  SizedBox(width: 6),
                  Text(
                    '4.6',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 22 : 28,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '(128 avis)',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: isMobile ? 13 : 15,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _ratingHistogram(isMobile),
              SizedBox(height: 12),
              _commentList(isMobile),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => _showAllComments(context: context),
                  icon: Icon(Icons.forum, color: Color(0xFF388E3C)),
                  label: Text(
                    'Voir tous les commentaires',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              _addReviewBox(isMobile),
            ],
          ),
        );
      },
    );
  }

  void _showCommentDialog(BuildContext context, double rating) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Merci pour votre note !'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Aidez la communauté en laissant un commentaire.'),
            SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Votre commentaire...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // Ici, tu peux gérer l'envoi du commentaire
              Navigator.of(ctx).pop();
            },
            child: Text('Envoyer'),
          ),
        ],
      ),
    );
  }

  void _showAllComments({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 18,
            left: 18,
            right: 18,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tous les commentaires',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 260,
                child: ListView(
                  children: [
                    _commentItemWithLike(
                      'Awa O.',
                      'Super livre, très inspirant !',
                      5,
                      false,
                    ),
                    _commentItemWithLike(
                      'Fatou T.',
                      'Bien écrit, mais un peu court.',
                      4,
                      true,
                    ),
                    _commentItemWithLike(
                      'Moussa K.',
                      'Merci pour le retour !',
                      5,
                      false,
                      isReply: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Votre commentaire...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF388E3C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _commentItemWithLike(
    String user,
    String text,
    int stars,
    bool liked, {
    bool isReply = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: isReply ? 24 : 0, top: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Color(0xFF388E3C),
            child: Text(user[0], style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 8),
                    Row(
                      children: List.generate(
                        stars,
                        (i) => Icon(
                          Icons.star,
                          color: Color(0xFFFFD600),
                          size: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(text, style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              liked ? Icons.favorite : Icons.favorite_border,
              color: liked ? Color(0xFFD32F2F) : Colors.grey,
              size: 20,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _ratingHistogram(bool isMobile) {
    return Column(
      children: List.generate(5, (i) {
        final star = 5 - i;
        final percent = [0.55, 0.22, 0.13, 0.07, 0.03][i];
        return Row(
          children: [
            Text('$star', style: TextStyle(fontSize: isMobile ? 12 : 14)),
            Icon(
              Icons.star,
              color: Color(0xFFFFD600),
              size: isMobile ? 13 : 15,
            ),
            SizedBox(width: 4),
            Expanded(
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: Color(0xFFF5F5F5),
                color: Color(0xFF388E3C),
                minHeight: isMobile ? 7 : 10,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '${(percent * 100).toInt()}%',
              style: TextStyle(fontSize: isMobile ? 11 : 13),
            ),
          ],
        );
      }),
    );
  }

  Widget _commentList(bool isMobile) {
    return Column(
      children: [
        _commentItem(
          'Awa O.',
          'Super livre, très inspirant !',
          5,
          isMobile,
          replies: [
            _commentItem(
              'Moussa K.',
              'Merci pour le retour !',
              5,
              isMobile,
              isReply: true,
            ),
          ],
        ),
        _commentItem('Fatou T.', 'Bien écrit, mais un peu court.', 4, isMobile),
      ],
    );
  }

  Widget _commentItem(
    String user,
    String text,
    int stars,
    bool isMobile, {
    List<Widget>? replies,
    bool isReply = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: isReply ? 24 : 0, top: 8, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: isMobile ? 13 : 16,
                backgroundColor: Color(0xFF388E3C),
                child: Text(user[0], style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 8),
              Text(
                user,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 13 : 15,
                ),
              ),
              SizedBox(width: 8),
              Row(
                children: List.generate(
                  stars,
                  (i) => Icon(
                    Icons.star,
                    color: Color(0xFFFFD600),
                    size: isMobile ? 12 : 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(left: isMobile ? 36 : 44),
            child: Text(text, style: TextStyle(fontSize: isMobile ? 12 : 14)),
          ),
          if (replies != null) ...replies!,
        ],
      ),
    );
  }

  Widget _addReviewBox(bool isMobile) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(isMobile ? 10 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Ajouter un avis...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Color(0xFF388E3C)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _recommendationsSlider(bool isMobile) {
    return SizedBox(
      height: isMobile ? 180 : 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _recommendationCard(
            'Le Pouvoir du Savoir',
            'Fatou Traoré',
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            isMobile,
          ),
          _recommendationCard(
            'Coaching Express',
            'Moussa Kaboré',
            'https://images.unsplash.com/photo-1516979187457-637abb4f9353',
            isMobile,
          ),
          _recommendationCard(
            'Histoires du Faso',
            'Awa Ouédraogo',
            'https://images.unsplash.com/photo-1465101178521-c1a9136a3b41',
            isMobile,
          ),
        ],
      ),
    );
  }

  Widget _recommendationCard(
    String title,
    String author,
    String image,
    bool isMobile,
  ) {
    return Container(
      width: isMobile ? 120 : 150,
      margin: EdgeInsets.only(right: isMobile ? 10 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              image,
              height: isMobile ? 80 : 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: isMobile ? 80 : 100,
                color: Colors.grey[200],
                child: Icon(Icons.broken_image, color: Colors.grey, size: 32),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isMobile ? 7 : 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 12 : 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  author,
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 12,
                    color: Color(0xFF388E3C),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _purchaseCard(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
        border: Border.all(color: Color(0xFFF5F5F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Étoiles + note + nombre d'avis
          Row(
            children: [
              ...List.generate(
                5,
                (i) => Icon(
                  i < 4 ? Icons.star : Icons.star_border,
                  color: Color(0xFFFFA000),
                  size: isMobile ? 26 : 30,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '4.6',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 18 : 22,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '(198 avis)',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: isMobile ? 13 : 15,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            '+1247 lecteurs',
            style: TextStyle(
              color: Colors.black54,
              fontSize: isMobile ? 12 : 14,
            ),
          ),
          SizedBox(height: 12),
          // Formats et audio
          Wrap(
            spacing: 10,
            children: [
              if (hasAudio)
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.play_circle,
                    color: Color(0xFF388E3C),
                    size: 20,
                  ),
                  label: Text(
                    'Audio disponible',
                    style: TextStyle(color: Color(0xFF388E3C)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF388E3C)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              OutlinedButton(
                onPressed: () {},
                child: Text('PDF'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: Text('ePub'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: Text('Audio'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Prix
          Text(
            formatFcfa(24990), // ou la variable de prix
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 26 : 32,
              color: Color(0xFFD35400),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.shopping_cart, color: Colors.white),
                  label: Text(
                    'Ajouter au panier',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF9800),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    'Lire un extrait',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(color: Color(0xFFFF9800)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              'Gratuit avec l’abonnement Premium',
              style: TextStyle(
                color: Color(0xFFB98000),
                fontSize: isMobile ? 12 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Ajout du widget résumé dépliable
class ExpandableSummary extends StatefulWidget {
  final bool isMobile;
  const ExpandableSummary({required this.isMobile});
  @override
  State<ExpandableSummary> createState() => _ExpandableSummaryState();
}

class _ExpandableSummaryState extends State<ExpandableSummary> {
  bool expanded = false;
  final String summary =
      "Ce livre vous plonge dans l'univers fascinant de la connaissance et du développement personnel. À travers des exemples inspirants, des conseils pratiques et des témoignages, il vous guide pas à pas pour révéler votre potentiel, surmonter les obstacles et atteindre vos objectifs. Que vous soyez étudiant, professionnel ou simplement curieux, ce livre vous apportera des clés concrètes pour progresser dans votre vie personnelle et professionnelle. Découvrez comment la persévérance, l'apprentissage continu et la passion peuvent transformer votre quotidien et ouvrir de nouvelles perspectives. Un ouvrage incontournable pour tous ceux qui souhaitent s'épanouir et réussir dans un monde en constante évolution.";

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: widget.isMobile ? 14 : 16,
      color: Colors.black87,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          summary,
          style: style,
          maxLines: expanded ? null : 4,
          overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => setState(() => expanded = !expanded),
            child: Text(
              expanded ? 'Moins' : 'Tous',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

// Ajout du widget détails du livre
class _BookDetailsCard extends StatelessWidget {
  final bool isMobile;
  const _BookDetailsCard({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      color: Colors.brown[200],
      fontWeight: FontWeight.w600,
      fontSize: isMobile ? 14 : 16,
    );
    final valueStyle = TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.w500,
      fontSize: isMobile ? 15 : 17,
    );
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Color(0xFFF5F5F5)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book,
                color: Colors.brown[700],
                size: isMobile ? 22 : 26,
              ),
              SizedBox(width: 8),
              Text(
                'Détails du livre',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 18 : 22,
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          _detailRow('Pages:', '324', labelStyle, valueStyle),
          _detailRow('Langue:', 'Français', labelStyle, valueStyle),
          _detailRow('Éditeur:', 'Tech Books Africa', labelStyle, valueStyle),
          _detailRow('ISBN:', '978-2-123456-78-9', labelStyle, valueStyle),
          _detailRow('Publication:', '15/01/2024', labelStyle, valueStyle),
          _detailRow('Taille:', '12.5 MB', labelStyle, valueStyle),
          _detailRow('Format:', 'PDF, ePub, Audio', labelStyle, valueStyle),
        ],
      ),
    );
  }

  Widget _detailRow(
    String label,
    String value,
    TextStyle labelStyle,
    TextStyle valueStyle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: labelStyle)),
          Expanded(
            child: Text(value, style: valueStyle, textAlign: TextAlign.left),
          ),
        ],
      ),
    );
  }
}

String formatFcfa(num value) {
  return NumberFormat('#,##0', 'fr_FR').format(value) + ' FCFA';
}
