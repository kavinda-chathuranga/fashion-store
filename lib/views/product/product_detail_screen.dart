import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product_model.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../cart/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  String? _selectedSize = 'M';
  Color? _selectedColor;
  int _currentImageIndex = 0;
  late final PageController _pageController;

  final List<String> _sizes = ['S', 'M', 'L'];
  final List<Color> _colors = [
    Colors.black,
    const Color(0xFFD6A054), // Gold
    const Color(0xFF4A235A), // Purple
  ];

  // Carousel images — uses the same imageUrl with slight colour-filter variations
  // to simulate multiple product shots without extra data fields.
  late final List<String> _images;

  @override
  void initState() {
    super.initState();
    _selectedColor = _colors.first;
    _pageController = PageController();
    // Initialize gallery images from the product model
    _images = widget.product.images.isNotEmpty
        ? widget.product.images
        : [
            widget.product.imageUrl,
            widget.product.imageUrl,
            widget.product.imageUrl,
          ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _addToCart() {
    // Adding multiple items isn't strictly in CartController's current single add API,
    // so we'll just add it once as the UI indicates a "Buy Now" intent or we can loop.
    for (int i = 0; i < _quantity; i++) {
      context.read<CartController>().addItem(widget.product.id);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_quantity x ${widget.product.name} added to cart!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'VIEW',
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartController = context.watch<CartController>();
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Carousel Image Section ─────────────────────────────
            SizedBox(
              height: screenHeight * 0.65,
              child: Stack(
                children: [
                  // Swipeable PageView
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _images.length,
                        onPageChanged: (i) =>
                            setState(() => _currentImageIndex = i),
                        itemBuilder: (context, index) {
                          child:
                          index == 0
                              ? Hero(
                                  tag: 'product_${widget.product.id}',
                                  child: CachedNetworkImage(
                                    imageUrl: _images[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl: _images[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                );
                        },
                      ),
                    ),
                  ),

                  // Top controls (Fashion, Cart, Menu)
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Fashion Back Button
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Fashion',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Right Icons
                          Row(
                            children: [
                              // Wishlist heart
                              Builder(
                                builder: (ctx) {
                                  final wishlistCtrl = ctx
                                      .watch<WishlistController>();
                                  final isFav = wishlistCtrl.isInWishlist(
                                    widget.product.id,
                                  );
                                  return GestureDetector(
                                    onTap: () => wishlistCtrl.toggleWishlist(
                                      widget.product,
                                    ),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isFav
                                            ? Colors.red.shade50
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        isFav
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFav
                                            ? Colors.redAccent
                                            : Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              // Tappable cart icon
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CartScreen(),
                                  ),
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                    if (cartController.itemCount > 0)
                                      Positioned(
                                        right: -4,
                                        top: -4,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.orange,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '${cartController.itemCount}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.menu,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Live Pagination Dots + Tappable Thumbnails ────
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Animated dots tracking current page
                        Row(
                          children: List.generate(_images.length, (index) {
                            final isActive = index == _currentImageIndex;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.only(right: 6),
                              width: isActive ? 20 : 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),
                        // Tappable thumbnails that set the page
                        Row(
                          children: List.generate(_images.length, (index) {
                            final isSelected = index == _currentImageIndex;
                            return GestureDetector(
                              onTap: () {
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(left: 8),
                                width: isSelected ? 52 : 44,
                                height: isSelected ? 52 : 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: isSelected
                                      ? Border.all(
                                          color: const Color(0xFFE5D9CC),
                                          width: 3,
                                        )
                                      : Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 1,
                                        ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 8,
                                          ),
                                        ]
                                      : [],
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      _images[index],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Information Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        'Rs. ${widget.product.price.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Rating Section
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFD6A054),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.product.rating}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${widget.product.reviews} Reviews)',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Detail's Header & Description
                  Text(
                    "Details",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Colors and Size Selectors
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Color Selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Colors:",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: _colors.map((color) {
                              final isSelected = _selectedColor == color;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedColor = color),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: isSelected
                                        ? Border.all(
                                            color: const Color(0xFFD2BCA8),
                                            width: 3,
                                          )
                                        : Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      // Size Selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Size",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: _sizes.map((size) {
                              final isSelected = _selectedSize == size;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedSize = size),
                                child: Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFD2BCA8)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: isSelected
                                        ? null
                                        : Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    size,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Controls: Quantity + Buy Now
                  Row(
                    children: [
                      // Quantity Counter
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (_quantity > 1) setState(() => _quantity--);
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5D9CC).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.remove,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 32,
                            child: Text(
                              '$_quantity',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() => _quantity++);
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5D9CC).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 32),

                      // Buy Now Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _addToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE5D9CC),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Buy Now',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
