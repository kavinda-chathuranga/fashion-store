import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../models/product_model.dart';
import '../../core/theme.dart';
import '../product/product_detail_screen.dart';
import '../cart/cart_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Removed local categories list to use ProductController's source of truth


  void _showFilterSheet() {
    double tempPrice = 10000;
    String tempSort = 'Newest';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.headerColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.beigeColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Filter Options',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: context.textColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Max Price: Rs. ${tempPrice.toInt()}',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: context.textColor,
                    ),
                  ),
                  Slider(
                    value: tempPrice,
                    max: 20000,
                    divisions: 20,
                    activeColor: context.beigeColor,
                    inactiveColor: context.beigeColor.withOpacity(0.2),
                    label: tempPrice.round().toString(),
                    onChanged: (val) {
                      setSheetState(() => tempPrice = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sort By',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: context.textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: ['Newest', 'Price: Low to High', 'Price: High to Low']
                        .map((sort) {
                      final isSelected = tempSort == sort;
                      return ChoiceChip(
                        label: Text(sort),
                        selected: isSelected,
                        selectedColor: context.beigeColor,
                        labelStyle: GoogleFonts.inter(
                          color: isSelected ? Colors.white : context.textColor,
                          fontSize: 12,
                        ),
                        onSelected: (v) {
                          if (v) setSheetState(() => tempSort = sort);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ProductController>().applyFilters(
                              maxPrice: tempPrice,
                              sortBy: tempSort,
                            );
                        Navigator.pop(context);
                      },
                      child: const Text('APPLY FILTERS'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productController = context.watch<ProductController>();
    final cartController = context.watch<CartController>();
    final isLoading = productController.isLoading;
    final categories = productController.categories;
    final selectedCategory = productController.selectedCategory;
    final filtered = productController.filteredProducts;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // ── Top Header ──────────────────────────────────────────
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 24,
              right: 24,
              bottom: 20,
            ),
            decoration: BoxDecoration(color: context.headerColor),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Fashion',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                        color: context.textColor,
                      ),
                    ),
                    Row(
                      children: [
                        // ── Tappable Cart Icon ──────────────────────────
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
                                  color: context.isDarkMode
                                      ? Colors.black26
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: context.textColor,
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
                        // ── Working Hamburger Menu ──────────────────────
                        GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: context.isDarkMode
                                  ? Colors.black26
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.menu,
                              color: context.textColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Tappable Search Bar ─────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchScreen(),
                          ),
                        ),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: context.isDarkMode
                                ? Colors.black26
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: context.subTextColor),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Search',
                                  style: GoogleFonts.inter(
                                    color: context.subTextColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // ── Working Filter Button ───────────────────────────
                    GestureDetector(
                      onTap: _showFilterSheet,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: context.beigeColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.tune,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Categories & Product Grid ─────────────────────────────────
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Category Chips
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      isLoading
                          ? _CategoryChipShimmer()
                          : SizedBox(
                              height: 48,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  final isSelected = selectedCategory == category;
                                  return GestureDetector(
                                    onTap: () => context
                                        .read<ProductController>()
                                        .setCategory(category),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 4,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? context.beigeColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: isSelected
                                            ? null
                                            : Border.all(
                                                color: context.beigeColor
                                                    .withOpacity(0.3),
                                              ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        category,
                                        style: GoogleFonts.inter(
                                          color: isSelected
                                              ? Colors.white
                                              : context.textColor,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'All Collection',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: context.subTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                // ── Shimmer / Products Grid ──────────────────────────────
                if (isLoading)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.58,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 24,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (_, _) => _ProductCardShimmer(),
                        childCount: 6,
                      ),
                    ),
                  )
                else if (filtered.isEmpty)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 60,
                              color: context.beigeColor.withOpacity(0.3),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No products found',
                              style: GoogleFonts.inter(
                                color: context.subTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.58,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 24,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = filtered[index];
                        return _HomeProductCard(
                          product: product,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreen(product: product),
                            ),
                          ),
                        );
                      }, childCount: filtered.length),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shimmer Widgets ──────────────────────────────────────────────────────────

class _CategoryChipShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.isDarkMode ? Colors.white10 : Colors.grey.shade300,
      highlightColor: context.isDarkMode
          ? Colors.white24
          : Colors.grey.shade100,
      child: SizedBox(
        height: 48,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 5,
          itemBuilder: (_, i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.isDarkMode ? Colors.white10 : Colors.grey.shade300,
      highlightColor: context.isDarkMode
          ? Colors.white24
          : Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(width: 100, height: 12, color: Colors.white),
          const SizedBox(height: 6),
          Container(width: 70, height: 12, color: Colors.white),
        ],
      ),
    );
  }
}

// ── Product Card ─────────────────────────────────────────────────────────────

class _HomeProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const _HomeProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final wishlistController = context.watch<WishlistController>();
    final cartController = context.read<CartController>();
    final isFav = wishlistController.isInWishlist(product.id);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Hero(
                    tag: 'product_${product.id}',
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Shimmer.fromColors(
                        baseColor: context.isDarkMode
                            ? Colors.white10
                            : Colors.grey.shade300,
                        highlightColor: context.isDarkMode
                            ? Colors.white24
                            : Colors.grey.shade100,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (_, _, _) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => wishlistController.toggleWishlist(product),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isFav
                            ? Colors.red.shade50
                            : (context.isDarkMode
                                  ? Colors.black45
                                  : Colors.white),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isFav
                            ? Colors.redAccent
                            : context.textColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      cartController.addItem(product.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart!'),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? Colors.black45
                            : Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_shopping_cart_outlined,
                        size: 16,
                        color: context.textColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.textColor,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFD6A054), size: 12),
              const SizedBox(width: 4),
              Text(
                '${product.rating}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: context.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Rs. ${product.price.toInt()}',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: context.beigeColor,
            ),
          ),
        ],
      ),
    );
  }
}
