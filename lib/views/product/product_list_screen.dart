import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/product_controller.dart';
import '../../widgets/product_card.dart';
import '../../widgets/shimmer_widgets.dart';
import '../../widgets/animations.dart';
import 'product_detail_screen.dart';
import '../../core/theme.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = context.watch<ProductController>();
    final categories = productController.categories;
    final isLoading = productController.isLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header Title ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Explore Fashion',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: context.textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Category Chips ───────────────────────────────────────
            SizedBox(
              height: 44,
              child: isLoading
                  ? const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CategoryChipsSkeleton(),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = category == productController.selectedCategory;
                        return FadeInWidget(
                          delay: Duration(milliseconds: 60 * index),
                          child: GestureDetector(
                            onTap: () => context.read<ProductController>().setCategory(category),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              decoration: BoxDecoration(
                                color: isSelected ? context.beigeColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected ? null : Border.all(color: context.beigeColor.withOpacity(0.3)),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                category,
                                style: GoogleFonts.inter(
                                  color: isSelected ? Colors.white : context.textColor,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),

            // ── Product Grid ─────────────────────────────────────────
            Expanded(
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ProductGridSkeleton(count: 4),
                    )
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: GridView.builder(
                        key: ValueKey(productController.selectedCategory),
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.58,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 24,
                        ),
                        itemCount: productController.filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = productController.filteredProducts[index];
                          return StaggeredItem(
                            index: index,
                            child: ProductCard(
                              product: product,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailScreen(product: product),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
