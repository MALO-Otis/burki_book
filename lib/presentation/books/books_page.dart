import 'package:burki_book/presentation/cart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../book/book_detail_page.dart';

class Book {
  final int id;
  final String title;
  final String author;
  final String format;
  final String genre;
  final double rating;
  final int reviews;
  final double price;
  final double? originalPrice;
  final String cover;
  final bool isNew;
  final bool isOwned;
  final bool isFavorite;
  final String description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.format,
    required this.genre,
    required this.rating,
    required this.reviews,
    required this.price,
    this.originalPrice,
    required this.cover,
    this.isNew = false,
    this.isOwned = false,
    this.isFavorite = false,
    required this.description,
  });

  Book copyWith({bool? isFavorite, bool? isOwned}) {
    return Book(
      id: id,
      title: title,
      author: author,
      format: format,
      genre: genre,
      rating: rating,
      reviews: reviews,
      price: price,
      originalPrice: originalPrice,
      cover: cover,
      isNew: isNew,
      isOwned: isOwned ?? this.isOwned,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description,
    );
  }
}

final List<Book> mockBooks = [
  Book(
    id: 1,
    title: "Développement React Avancé",
    author: "Marie Dubois",
    format: "PDF",
    genre: "Programmation",
    rating: 4.8,
    reviews: 156,
    price: 24.99,
    originalPrice: 34.99,
    cover:
        "https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=400&h=600&fit=crop",
    isNew: true,
    description: "Guide complet pour maîtriser React et ses concepts avancés",
  ),
  Book(
    id: 2,
    title: "L'Art de la Méditation",
    author: "Jean-Pierre Martin",
    format: "Audio",
    genre: "Développement personnel",
    rating: 4.6,
    reviews: 89,
    price: 19.99,
    cover:
        "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=600&fit=crop",
    isFavorite: true,
    description: "Découvrez les bienfaits de la méditation quotidienne",
  ),
  Book(
    id: 3,
    title: "Finance Islamique Moderne",
    author: "Ahmed Hassan",
    format: "ePub",
    genre: "Finance",
    rating: 4.9,
    reviews: 203,
    price: 29.99,
    cover:
        "https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=600&fit=crop",
    isOwned: true,
    description: "Principes et applications de la finance islamique",
  ),
  Book(
    id: 4,
    title: "Cuisine Méditerranéenne",
    author: "Sofia Rossi",
    format: "PDF",
    genre: "Cuisine",
    rating: 4.4,
    reviews: 67,
    price: 16.99,
    cover:
        "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=600&fit=crop",
    description: "Recettes authentiques de la Méditerranée",
  ),
  Book(
    id: 5,
    title: "Business Strategy 2024",
    author: "Robert Wilson",
    format: "Audio",
    genre: "Business",
    rating: 4.7,
    reviews: 134,
    price: 27.99,
    originalPrice: 39.99,
    cover:
        "https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?w=400&h=600&fit=crop",
    isNew: true,
    description: "Stratégies modernes pour réussir en affaires",
  ),
  Book(
    id: 6,
    title: "Histoire de l'Art Islamique",
    author: "Fatima Al-Zahra",
    format: "ePub",
    genre: "Histoire",
    rating: 4.5,
    reviews: 92,
    price: 22.99,
    cover:
        "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=600&fit=crop",
    description: "Exploration de l'art islamique à travers les siècles",
  ),
];

const genres = [
  "Tous",
  "Programmation",
  "Business",
  "Finance",
  "Cuisine",
  "Histoire",
  "Développement personnel",
];
const formats = ["Tous", "PDF", "ePub", "Audio"];
const sortOptions = [
  {"value": "popular", "label": "Populaires"},
  {"value": "newest", "label": "Nouveautés"},
  {"value": "bestseller", "label": "Meilleures ventes"},
  {"value": "alphabetical", "label": "A-Z"},
  {"value": "price-low", "label": "Prix croissant"},
  {"value": "price-high", "label": "Prix décroissant"},
  {"value": "most-bought", "label": "Le plus acheté"},
  {"value": "promo", "label": "Ceux en promo"},
  {"value": "free", "label": "Ceux gratuit"},
];

class BooksPage extends StatefulWidget {
  const BooksPage({Key? key}) : super(key: key);

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Book> books = List.from(mockBooks);
  List<Book> filteredBooks = List.from(mockBooks);
  String searchQuery = '';
  String selectedGenre = 'Tous';
  String selectedFormat = 'Tous';
  double minRating = 0;
  int selectedPriceInterval = 0; // 0: <1000f, 1: <2000f, 2: <3500f
  final List<String> priceIntervals = ['< 1000f', '< 2000f', '< 3500f'];

  // Pour la sélection multiple d'intervalles de prix et de notes
  List<bool> selectedPriceRanges = [false, false, false];
  List<bool> selectedRatingRanges = [false, false, false];
  final List<String> priceIntervalsLabels = ['< 1000f', '< 2000f', '< 3500f'];
  final List<List<double>> priceIntervalsValues = [
    [0, 1000],
    [1000, 2000],
    [2000, 3500],
  ];
  final List<String> ratingIntervalsLabels = ['0-2★', '2-3.5★', '3.5-5★'];
  final List<List<double>> ratingIntervalsValues = [
    [0, 2],
    [2, 3.5],
    [3.5, 5],
  ];

  final List<Map<String, String>> sortOptions = [
    {"value": "popular", "label": "Populaires"},
    {"value": "newest", "label": "Nouveautés"},
    {"value": "bestseller", "label": "Meilleures ventes"},
    {"value": "alphabetical", "label": "A-Z"},
    {"value": "price-low", "label": "Prix croissant"},
    {"value": "price-high", "label": "Prix décroissant"},
    {"value": "most-bought", "label": "Le plus acheté"},
    {"value": "promo", "label": "Ceux en promo"},
    {"value": "free", "label": "Ceux gratuit"},
  ];

  bool loading = true;
  bool isGrid = true;
  String sortBy = 'popular';

  // Genres populaires pour le sélecteur rapide (à adapter selon vos stats réelles)
  final List<String> topGenres = [
    'Programmation',
    'Business',
    'Finance',
    'Cuisine',
    'Histoire',
    'Développement personnel',
    'Roman',
    'Science',
    'Poésie',
    'Aventure',
    'Biographie',
  ];
  String selectedTopGenre = 'Programmation';

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        loading = false;
      });
    });
  }

  void filterBooks() {
    List<Book> filtered = books.where((book) {
      final matchesSearch =
          book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesGenre =
          selectedGenre == 'Tous' || book.genre == selectedGenre;
      final matchesFormat =
          selectedFormat == 'Tous' || book.format == selectedFormat;
      // Filtrage par intervalles de prix multiples
      bool matchesPrice = true;
      if (selectedPriceRanges.contains(true)) {
        matchesPrice = false;
        for (int i = 0; i < selectedPriceRanges.length; i++) {
          if (selectedPriceRanges[i]) {
            final min = priceIntervalsValues[i][0];
            final max = priceIntervalsValues[i][1];
            if (book.price >= min && book.price < max) {
              matchesPrice = true;
              break;
            }
          }
        }
      } else {
        // fallback: interval unique
        if (selectedPriceInterval == 0) {
          matchesPrice = book.price < 1000;
        } else if (selectedPriceInterval == 1) {
          matchesPrice = book.price < 2000;
        } else if (selectedPriceInterval == 2) {
          matchesPrice = book.price < 3500;
        }
      }
      // Filtrage par intervalles de notes multiples
      bool matchesRating = true;
      if (selectedRatingRanges.contains(true)) {
        matchesRating = false;
        for (int i = 0; i < selectedRatingRanges.length; i++) {
          if (selectedRatingRanges[i]) {
            final min = ratingIntervalsValues[i][0];
            final max = ratingIntervalsValues[i][1];
            if (book.rating >= min && book.rating < max) {
              matchesRating = true;
              break;
            }
          }
        }
      } else {
        matchesRating = book.rating >= minRating;
      }
      return matchesSearch &&
          matchesGenre &&
          matchesFormat &&
          matchesRating &&
          matchesPrice;
    }).toList();

    switch (sortBy) {
      case 'newest':
        filtered.sort((a, b) => (b.isNew ? 1 : 0) - (a.isNew ? 1 : 0));
        break;
      case 'bestseller':
        filtered.sort((a, b) => b.reviews - a.reviews);
        break;
      case 'alphabetical':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'price-low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price-high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'most-bought':
        filtered.sort((a, b) => b.reviews.compareTo(a.reviews));
        break;
      case 'promo':
        filtered = filtered
            .where(
              (b) =>
                  b.originalPrice != null &&
                  b.price < (b.originalPrice ?? b.price),
            )
            .toList();
        break;
      case 'free':
        filtered = filtered.where((b) => b.price == 0).toList();
        break;
      default:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }
    setState(() {
      filteredBooks = filtered;
    });
  }

  void toggleFavorite(int bookId) {
    setState(() {
      books = books
          .map(
            (book) => book.id == bookId
                ? book.copyWith(isFavorite: !book.isFavorite)
                : book,
          )
          .toList();
    });
    filterBooks();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Favoris mis à jour')));
  }

  void addToCart(Book book) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${book.title}" a été ajouté à votre panier')),
    );
  }

  Widget getFormatIcon(String format) {
    switch (format) {
      case 'PDF':
        return const Icon(
          Icons.picture_as_pdf,
          size: 16,
          color: Colors.redAccent,
        );
      case 'ePub':
        return const Icon(Icons.menu_book, size: 16, color: Colors.blueAccent);
      case 'Audio':
        return const Icon(Icons.headphones, size: 16, color: Colors.green);
      default:
        return const Icon(Icons.book, size: 16, color: Colors.grey);
    }
  }

  Color getFormatColor(String format) {
    switch (format) {
      case 'PDF':
        return Colors.red.shade50;
      case 'ePub':
        return Colors.blue.shade50;
      case 'Audio':
        return Colors.green.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  void openSortSidebar() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.sort, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Trier par',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Section intervalles de prix multiples
                const Text(
                  'Prix (sélection multiple)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Column(
                  children: List.generate(
                    priceIntervalsLabels.length,
                    (i) => CheckboxListTile(
                      value: selectedPriceRanges[i],
                      onChanged: (v) {
                        setState(() {
                          selectedPriceRanges[i] = v!;
                        });
                        filterBooks();
                      },
                      title: Text(priceIntervalsLabels[i]),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Section intervalles de notes multiples
                const Text(
                  'Note (sélection multiple)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Column(
                  children: List.generate(
                    ratingIntervalsLabels.length,
                    (i) => CheckboxListTile(
                      value: selectedRatingRanges[i],
                      onChanged: (v) {
                        setState(() {
                          selectedRatingRanges[i] = v!;
                        });
                        filterBooks();
                      },
                      title: Row(
                        children: [
                          Text(ratingIntervalsLabels[i]),
                          const SizedBox(width: 4),
                          Row(
                            children: List.generate(
                              i + 1,
                              (j) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Section tri
                const Text(
                  'Trier par',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: sortOptions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (ctx, idx) {
                      final opt = sortOptions[idx];
                      final isSelected = sortBy == opt['value'];
                      return Material(
                        color: isSelected
                            ? Colors.blue.withOpacity(0.08)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                sortBy = '';
                              } else {
                                sortBy = opt['value']!;
                              }
                            });
                            filterBooks();
                            Navigator.of(context).maybePop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 4,
                            ),
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: opt['value']!,
                                  groupValue: sortBy.isEmpty ? null : sortBy,
                                  onChanged: (_) {
                                    setState(() {
                                      if (isSelected) {
                                        sortBy = '';
                                      } else {
                                        sortBy = opt['value']!;
                                      }
                                    });
                                    filterBooks();
                                    Navigator.of(context).maybePop();
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    opt['label']!,
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                if (opt['value'] == 'price-low')
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.arrow_downward,
                                      color: Colors.green,
                                    ),
                                  )
                                else if (opt['value'] == 'price-high')
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.arrow_upward,
                                      color: Colors.red,
                                    ),
                                  )
                                else if (opt['value'] == 'most-bought')
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: Colors.orange,
                                    ),
                                  )
                                else if (opt['value'] == 'promo')
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.local_offer,
                                      color: Colors.purple,
                                    ),
                                  )
                                else if (opt['value'] == 'free')
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.money_off,
                                      color: Colors.teal,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: loading
            ? _buildSkeleton(context, isWide)
            : _buildContent(context, isWide, isMobile),
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context, bool isWide) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(height: 32, width: 120, color: Colors.grey[300]),
              Row(
                children: [
                  Container(height: 40, width: 40, color: Colors.grey[300]),
                  const SizedBox(width: 8),
                  Container(height: 40, width: 40, color: Colors.grey[300]),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 40,
            width: double.infinity,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: isWide ? 5 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: List.generate(
                10,
                (i) => Container(color: Colors.grey[300], height: 200),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isWide, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Tous les livres',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      Get.to(
                        () => CartPage(),
                        transition: Transition.downToUp,
                        duration: const Duration(milliseconds: 400),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Search bar
          Stack(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un livre, auteur...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 12,
                  ),
                ),
                onChanged: (v) {
                  setState(() {
                    searchQuery = v;
                  });
                  filterBooks();
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Controls
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_alt_outlined),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: selectedTopGenre,
                items: topGenres
                    .take(10)
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() {
                      selectedTopGenre = v;
                      selectedGenre = v;
                    });
                    filterBooks();
                  }
                },
                hint: const Text('Genre populaire'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(isGrid ? Icons.grid_view : Icons.view_list),
                onPressed: () => setState(() {
                  isGrid = !isGrid;
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Book count
          Row(
            children: [
              Text(
                '${filteredBooks.length} livre${filteredBooks.length != 1 ? 's' : ''} trouvé${filteredBooks.length != 1 ? 's' : ''}',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Books grid/list
          Expanded(
            child: filteredBooks.isEmpty
                ? _buildEmptyState()
                : isGrid
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWide
                          ? 4
                          : isMobile
                          ? 2
                          : 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 25,
                      childAspectRatio: 0.36,
                    ),
                    itemCount: filteredBooks.length,
                    itemBuilder: (ctx, i) {
                      final book = filteredBooks[i];
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => BookDetailPage(
                              title: book.title,
                              author: book.author,
                              image: book.cover,
                              rating: book.rating,
                              achats: book.reviews,
                              isNew: book.isNew,
                              isPromotion:
                                  book.originalPrice != null &&
                                  book.price <
                                      (book.originalPrice ?? book.price),
                              hasAudio: book.format == 'Audio',
                              isPremium: false,
                            ),
                            transition: Transition.cupertino,
                            duration: const Duration(milliseconds: 500),
                          );
                        },
                        child: Hero(
                          tag: 'book_${book.id}',
                          child: _BookCard(
                            book: book,
                            onFavorite: () => toggleFavorite(book.id),
                            onAddToCart: () => addToCart(book),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.separated(
                    itemCount: filteredBooks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final book = filteredBooks[i];
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => BookDetailPage(
                              title: book.title,
                              author: book.author,
                              image: book.cover,
                              rating: book.rating,
                              achats: book.reviews,
                              isNew: book.isNew,
                              isPromotion:
                                  book.originalPrice != null &&
                                  book.price <
                                      (book.originalPrice ?? book.price),
                              hasAudio: book.format == 'Audio',
                              isPremium: false,
                            ),
                            transition: Transition.cupertino,
                            duration: const Duration(milliseconds: 500),
                          );
                        },
                        child: Hero(
                          tag: 'book_${book.id}',
                          child: _BookCard(
                            book: book,
                            onFavorite: () => toggleFavorite(book.id),
                            onAddToCart: () => addToCart(book),
                            isList: true,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Genre', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: genres
              .map(
                (g) => ChoiceChip(
                  label: Text(g),
                  selected: selectedGenre == g,
                  onSelected: (_) {
                    setState(() {
                      selectedGenre = g;
                    });
                    filterBooks();
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        const Text('Format', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: formats
              .map(
                (f) => ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      getFormatIcon(f),
                      const SizedBox(width: 4),
                      Text(f),
                    ],
                  ),
                  selected: selectedFormat == f,
                  onSelected: (_) {
                    setState(() {
                      selectedFormat = f;
                    });
                    filterBooks();
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        const Text(
          'Note minimum',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: minRating,
                min: 0,
                max: 5,
                divisions: 10,
                label: minRating == 0 ? 'Toutes' : '$minRating★',
                activeColor: Colors.amber,
                onChanged: (v) {
                  setState(() {
                    minRating = v;
                  });
                  filterBooks();
                },
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: List.generate(
                5,
                (i) => Icon(
                  Icons.star,
                  size: 18,
                  color: i < minRating ? Colors.amber : Colors.grey[300],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Prix maximum',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 8,
          children: List.generate(
            priceIntervals.length,
            (i) => ChoiceChip(
              label: Text(priceIntervals[i]),
              selected: selectedPriceInterval == i,
              onSelected: (_) {
                setState(() {
                  selectedPriceInterval = i;
                });
                filterBooks();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📚', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          const Text(
            'Aucun livre trouvé',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            'Essayez de modifier vos critères de recherche',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              setState(() {
                searchQuery = '';
                selectedGenre = 'Tous';
                selectedFormat = 'Tous';
                minRating = 0;
                selectedPriceInterval = 0;
              });
              filterBooks();
            },
            child: const Text('Réinitialiser les filtres'),
          ),
        ],
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onFavorite;
  final VoidCallback onAddToCart;
  final bool isList;
  const _BookCard({
    required this.book,
    required this.onFavorite,
    required this.onAddToCart,
    this.isList = false,
  });

  @override
  Widget build(BuildContext context) {
    final cover = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Image.network(
          book.cover,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
        ),
      ),
    );
    final badges = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (book.isNew)
          Container(
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Nouveau',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        if (book.originalPrice != null)
          Container(
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '-${(100 - (book.price / (book.originalPrice ?? book.price)) * 100).round()}%',
              style: const TextStyle(color: Colors.red, fontSize: 10),
            ),
          ),
        if (book.isOwned)
          Container(
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('Possédé', style: TextStyle(fontSize: 10)),
          ),
      ],
    );
    final favoriteBtn = IconButton(
      icon: Icon(
        book.isFavorite ? Icons.favorite : Icons.favorite_border,
        color: book.isFavorite ? Colors.red : Colors.grey,
        size: 20,
      ),
      onPressed: onFavorite,
    );
    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _BooksPageState().getFormatIcon(book.format),
                  const SizedBox(width: 4),
                  Text(book.format, style: const TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          book.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          book.author,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Row(
          children: [
            Row(
              children: List.generate(
                5,
                (i) => Icon(
                  Icons.star,
                  size: 14,
                  color: i < book.rating.floor()
                      ? Colors.amber
                      : Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${book.rating} (${book.reviews})',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                children: [
                  Text(
                    '${book.price} FCFA',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  if (book.originalPrice != null)
                    Text(
                      '${book.originalPrice} FCFA',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ElevatedButton(
          onPressed: book.isOwned ? null : onAddToCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: book.isOwned ? Colors.grey[300] : null,
            foregroundColor: book.isOwned ? Colors.black : null,
            minimumSize: const Size.fromHeight(32),
          ),
          child: Text(
            book.isOwned ? 'Déjà possédé' : 'Ajouter au panier',
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
    return isList
        ? Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    child: Stack(
                      children: [
                        cover,
                        Positioned(top: 4, left: 4, child: badges),
                        Positioned(top: 4, right: 4, child: favoriteBtn),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: info),
                ],
              ),
            ),
          )
        : Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      cover,
                      Positioned(top: 4, left: 4, child: badges),
                      Positioned(top: 4, right: 4, child: favoriteBtn),
                    ],
                  ),
                  const SizedBox(height: 8),
                  info,
                ],
              ),
            ),
          );
  }
}
