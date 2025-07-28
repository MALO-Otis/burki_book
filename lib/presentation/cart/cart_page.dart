import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../book/book_detail_page.dart';
import '../payment/stripe_payment_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Mock data for cart items
  List<Map<String, dynamic>> cartItems = [
    {
      'id': 1,
      'title': 'Leadership Moder',
      'author': 'Jean Dupont',
      'image': 'https://images.unsplash.com/photo-1512820790803-83ca734da794',
      'type': 'book',
      'format': 'PDF',
      'price': 12.99,
      'quantity': 1,
      'isPromo': true,
      'promoText': '-20% aujourd’hui',
      'alreadyBought': false,
      'isGift': false,
    },
    {
      'id': 2,
      'title': 'Formation Marketing',
      'author': 'Sophie Martin',
      'image': 'https://images.unsplash.com/photo-1524985069026-dd778a71c7b4',
      'type': 'course',
      'format': 'Vidéo',
      'price': 29.99,
      'quantity': 1,
      'isPromo': false,
      'promoText': '',
      'alreadyBought': true,
      'isGift': false,
    },
  ];

  String promoCode = '';
  String promoMessage = '';
  double promoDiscount = 0.0;
  bool promoValid = false;
  bool showPaymentPopup = false;
  String language = 'fr'; // 'fr' or 'en'

  // Mock suggestions
  List<Map<String, dynamic>> suggestions = [
    {
      'title': 'Dév. Personnel',
      'author': 'Marc Zida',
      'image': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
      'type': 'book',
      'price': 9.99,
    },
    {
      'title': 'Coaching Express',
      'author': 'Moussa Kaboré',
      'image': 'https://images.unsplash.com/photo-1516979187457-637abb4f9353',
      'type': 'course',
      'price': 19.99,
    },
  ];

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + item['price'] * item['quantity']);
  double get discount => promoDiscount;
  double get taxes => subtotal * 0.05;
  double get total => subtotal - discount + taxes;
  int get totalItems =>
      cartItems.fold<int>(0, (sum, item) => sum + (item['quantity'] as int));

  void applyPromo() {
    setState(() {
      if (promoCode.trim().toLowerCase() == 'burkipromo') {
        promoDiscount = subtotal * 0.2;
        promoValid = true;
        promoMessage = language == 'fr'
            ? 'Code promo appliqué !'
            : 'Promo code applied!';
      } else {
        promoDiscount = 0.0;
        promoValid = false;
        promoMessage = language == 'fr' ? 'Code invalide.' : 'Invalid code.';
      }
    });
  }

  List<int> boughtItemIds = [];
  List<int> wishlistIds = [];

  @override
  void initState() {
    super.initState();
    loadCart();
    loadBoughtItems();
    loadWishlist();
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart_items');
    if (cartString != null) {
      final List<dynamic> decoded = jsonDecode(cartString);
      setState(() {
        cartItems = decoded
            .cast<Map<String, dynamic>>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      });
    }
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart_items', jsonEncode(cartItems));
  }

  Future<void> loadBoughtItems() async {
    final prefs = await SharedPreferences.getInstance();
    final boughtString = prefs.getString('bought_items');
    if (boughtString != null) {
      setState(() {
        boughtItemIds = List<int>.from(jsonDecode(boughtString));
      });
    }
  }

  Future<void> saveBoughtItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bought_items', jsonEncode(boughtItemIds));
  }

  Future<void> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistString = prefs.getString('wishlist_items');
    if (wishlistString != null) {
      setState(() {
        wishlistIds = List<int>.from(jsonDecode(wishlistString));
      });
    }
  }

  Future<void> saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wishlist_items', jsonEncode(wishlistIds));
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    saveCart();
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void addToWishlist(int index) {
    setState(() {
      wishlistIds.add(cartItems[index]['id']);
    });
    saveWishlist();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          language == 'fr'
              ? 'Ajouté à la liste de souhaits'
              : 'Added to wishlist',
        ),
      ),
    );
  }

  void showGiftDialog(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(language == 'fr' ? 'Offrir à un ami' : 'Gift to a friend'),
        content: TextField(
          decoration: InputDecoration(
            hintText: language == 'fr'
                ? 'Email ou téléphone'
                : 'Email or phone',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(language == 'fr' ? 'Annuler' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    language == 'fr' ? 'Cadeau envoyé !' : 'Gift sent!',
                  ),
                ),
              );
            },
            child: Text(language == 'fr' ? 'Envoyer' : 'Send'),
          ),
        ],
      ),
    );
  }

  void showPaymentConfirmation() {
    setState(() {
      showPaymentPopup = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showPaymentPopup = false;
        // Simuler l'achat : ajouter à boughtItemIds
        boughtItemIds.addAll(cartItems.map((e) => e['id'] as int));
        cartItems.clear();
      });
      saveBoughtItems();
      saveCart();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            language == 'fr' ? 'Paiement réussi !' : 'Payment successful!',
          ),
        ),
      );
    });
  }

  String formatFcfa(num value) {
    return NumberFormat('#,##0', 'fr_FR').format(value) + ' FCFA';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 320) {
              // Sur mobile étroit, séparer sur deux lignes
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        language == 'fr' ? 'Mon panier' : 'My Cart',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFD32F2F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$totalItems',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Suppression du bouton "Continuer mes achats"
                ],
              );
            } else {
              return Row(
                children: [
                  Text(
                    language == 'fr' ? 'Mon panier' : 'My Cart',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFFD32F2F),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$totalItems',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Suppression du bouton "Continuer mes achats"
                ],
              );
            }
          },
        ),
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 32,
              vertical: 12,
            ),
            children: [
              // Liste produits
              ...cartItems.asMap().entries.map((entry) {
                int i = entry.key;
                var item = entry.value;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.only(bottom: 16),
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
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 10 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item['image'],
                                width: 60,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => Get.to(
                                      () => BookDetailPage(
                                        title: item['title'],
                                        author: item['author'],
                                        image: item['image'],
                                        rating: 4.5,
                                        achats: 10,
                                        isNew: false,
                                        isPromotion: item['isPromo'],
                                      ),
                                    ),
                                    child: Text(
                                      item['title'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: isMobile ? 15 : 18,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    item['type'] == 'book'
                                        ? (language == 'fr'
                                                  ? 'Auteur: '
                                                  : 'Author: ') +
                                              item['author']
                                        : (language == 'fr'
                                                  ? 'Formateur: '
                                                  : 'Trainer: ') +
                                              item['author'],
                                    style: TextStyle(
                                      fontSize: isMobile ? 12 : 14,
                                      color: Color(0xFF6C4AB6),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.insert_drive_file,
                                        size: 16,
                                        color: Color(0xFFB98000),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        item['format'],
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      if (item['isPromo']) ...[
                                        SizedBox(width: 8),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFD32F2F),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            item['promoText'],
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (item['alreadyBought'])
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Color(0xFF388E3C),
                                            size: 16,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            language == 'fr'
                                                ? 'Déjà dans votre bibliothèque'
                                                : 'Already in your library',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF388E3C),
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
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatFcfa(item['price']),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 15 : 18,
                                color: Color(0xFF6C4AB6),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    color: Color(0xFFB98000),
                                  ),
                                  onPressed: item['quantity'] > 1
                                      ? () => setState(() => item['quantity']--)
                                      : null,
                                ),
                                Text(
                                  '${item['quantity']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add_circle_outline,
                                    color: Color(0xFF388E3C),
                                  ),
                                  onPressed: () =>
                                      setState(() => item['quantity']++),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(
                                    0xFFF57C00,
                                  ), // orange vif
                                  foregroundColor: Colors.white, // texte blanc
                                  minimumSize: Size(isMobile ? 90 : 110, 36),
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: item['alreadyBought']
                                    ? null
                                    : () async {
                                        final resume =
                                            '${item['title']} x${item['quantity']}';
                                        final montant =
                                            item['price'] * item['quantity'];
                                        final result = await Get.to(
                                          () => StripePaymentPage(
                                            resume: resume,
                                            montant: montant,
                                          ),
                                        );
                                        if (result == true) {
                                          setState(() {
                                            boughtItemIds.add(item['id']);
                                            cartItems.removeAt(i);
                                          });
                                          saveBoughtItems();
                                          saveCart();
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                language == 'fr'
                                                    ? 'Achat réussi !'
                                                    : 'Purchase successful!',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                icon: Icon(Icons.shopping_bag, size: 18),
                                label: Text(
                                  language == 'fr' ? 'Acheter' : 'Buy',
                                ),
                              ),
                              SizedBox(width: 6),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => removeItem(i),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: Color(0xFF6C4AB6),
                                ),
                                onPressed: () => addToWishlist(i),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.card_giftcard,
                                  color: Color(0xFFFFD600),
                                ),
                                onPressed: () => showGiftDialog(i),
                                tooltip: language == 'fr'
                                    ? 'Offrir à un ami'
                                    : 'Gift to a friend',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              // Code promo
              Container(
                margin: EdgeInsets.only(bottom: 18),
                padding: EdgeInsets.all(isMobile ? 12 : 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color(0xFF6C4AB6).withOpacity(0.08),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: language == 'fr'
                              ? 'Vous avez un code promo ?'
                              : 'Have a promo code?',
                          border: InputBorder.none,
                        ),
                        onChanged: (v) => promoCode = v,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF57C00), // orange vif
                        foregroundColor: Colors.white, // texte blanc
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: applyPromo,
                      child: Text(language == 'fr' ? 'Appliquer' : 'Apply'),
                    ),
                  ],
                ),
              ),
              if (promoMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    promoMessage,
                    style: TextStyle(
                      color: promoValid ? Color(0xFF388E3C) : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              // Récapitulatif
              Container(
                margin: EdgeInsets.only(bottom: 18),
                padding: EdgeInsets.all(isMobile ? 14 : 22),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language == 'fr' ? 'Articles' : 'Items'),
                        Text('$totalItems'),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Total HT'), Text(formatFcfa(subtotal))],
                    ),
                    if (discount > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language == 'fr' ? 'Remise' : 'Discount'),
                          Text(
                            '-${formatFcfa(discount)}',
                            style: TextStyle(color: Color(0xFFD32F2F)),
                          ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Taxes (5%)'), Text(formatFcfa(taxes))],
                    ),
                    Divider(height: 24, thickness: 1.2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          language == 'fr' ? 'Total à payer' : 'Total to pay',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 16 : 20,
                          ),
                        ),
                        Text(
                          formatFcfa(total),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 18 : 22,
                            color: Color(0xFF6C4AB6),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      language == 'fr'
                          ? 'Tous les achats sont numériques et livrés immédiatement après paiement.'
                          : 'All purchases are digital and delivered instantly after payment.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              // Bouton paiement
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD32F2F), // rouge vif
                        foregroundColor: Colors.white, // texte blanc
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: showPaymentConfirmation,
                      child: Text(
                        language == 'fr' ? 'Payer maintenant' : 'Pay now',
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock, color: Color(0xFF388E3C), size: 18),
                        SizedBox(width: 6),
                        Text(
                          language == 'fr'
                              ? 'Paiement sécurisé via Stripe / MoMo / PayPal'
                              : 'Secure payment via Stripe / MoMo / PayPal',
                          style: TextStyle(fontSize: 11, color: Colors.black87),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.credit_card, color: Color(0xFF6C4AB6)),
                        SizedBox(width: 8),
                        Icon(
                          Icons.account_balance_wallet,
                          color: Color(0xFFB98000),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.payments, color: Color(0xFFD32F2F)),
                      ],
                    ),
                  ],
                ),
              ),
              // Suggestions
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language == 'fr'
                          ? 'Vous pourriez aussi aimer…'
                          : 'You might also like…',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 16 : 20,
                      ),
                    ),
                    SizedBox(
                      height: isMobile ? 240 : 300,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: suggestions.map((s) {
                          return SizedBox(
                            width: isMobile ? 180 : 220,
                            child: Container(
                              margin: EdgeInsets.only(
                                right: 12,
                                top: 8,
                                bottom: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      s['image'],
                                      height: isMobile ? 130 : 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          s['title'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: isMobile ? 12 : 15,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          s['author'],
                                          style: TextStyle(
                                            fontSize: isMobile ? 11 : 13,
                                            color: Color(0xFF388E3C),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          formatFcfa(s['price']),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF6C4AB6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              // Encarts contextuels
              Container(
                margin: EdgeInsets.only(bottom: 18),
                padding: EdgeInsets.all(isMobile ? 12 : 18),
                decoration: BoxDecoration(
                  color: Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.workspace_premium, color: Color(0xFF6C4AB6)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        language == 'fr'
                            ? '📣 Abonnez-vous à Premium et obtenez -30% sur tous vos livres !'
                            : '📣 Subscribe to Premium and get -30% on all your books!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C4AB6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 18),
                padding: EdgeInsets.all(isMobile ? 12 : 18),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFFD32F2F)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        language == 'fr'
                            ? 'Pas de remboursement après téléchargement. Voir la FAQ.'
                            : 'No refund after download. See FAQ.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD32F2F),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        language == 'fr' ? 'FAQ' : 'FAQ',
                        style: TextStyle(color: Color(0xFF6C4AB6)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showPaymentPopup)
            Center(
              child: Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF6C4AB6)),
                    SizedBox(height: 18),
                    Text(
                      language == 'fr'
                          ? 'Paiement en cours…'
                          : 'Processing payment…',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
