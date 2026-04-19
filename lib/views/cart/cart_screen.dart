import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/product_controller.dart';
import '../../widgets/shimmer_widgets.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = context.watch<CartController>();
    final productController = context.read<ProductController>();
    final isLoading = context.watch<ProductController>().isLoading;
    final cartItems = cartController.items.values.toList();

    double calculateTotal() {
      double total = 0;
      for (var item in cartItems) {
        try {
          final product = productController.getProductById(item.productId);
          total += product.price * item.quantity;
        } catch (_) {}
      }
      return total;
    }

    final totalPrice = calculateTotal();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0), // Off-white matching the design
      body: Stack(
        children: [
          // Main Body
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row (Fashion, Cart, Menu)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fashion',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Stack(
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

                // Back Button Box
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Cart Items List
                if (isLoading)
                  Expanded(
                    child: ListView.builder(
                      itemCount: 3,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemBuilder: (_, _) => const CartItemSkeleton(),
                    ),
                  )
                else if (cartItems.isEmpty)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Your cart is empty',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      padding: const EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                        bottom: 250,
                      ), // bottom padding keeps items from underlapping behind the card
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];
                        final product = productController.getProductById(
                          cartItem.productId,
                        );

                        return Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          color: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image block
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 72,
                                  height: 72,
                                  color: Colors
                                      .white, // Incase it requires a fallback background
                                  child: CachedNetworkImage(
                                    imageUrl: product.imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (_, _) =>
                                        Container(color: Colors.grey.shade200),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Content Block
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title and Size
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.name,
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          'L', // Mock 'L' size exactly like image
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),

                                    // Price
                                    Text(
                                      'Rs. ${product.price.toStringAsFixed(2)}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // Counter and Delete
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Counter Component
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (cartItem.quantity > 1) {
                                                  cartController.updateQuantity(
                                                    cartItem.productId,
                                                    cartItem.quantity - 1,
                                                  );
                                                }
                                              },
                                              child: Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: const Icon(
                                                  Icons.remove,
                                                  size: 14,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 28,
                                              child: Text(
                                                '${cartItem.quantity}',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                cartController.updateQuantity(
                                                  cartItem.productId,
                                                  cartItem.quantity + 1,
                                                );
                                              },
                                              child: Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 14,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Trash Button
                                        GestureDetector(
                                          onTap: () => cartController
                                              .removeItem(cartItem.productId),
                                          child: const Icon(
                                            Icons.delete,
                                            size: 18,
                                            color: Colors.black87,
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
                      },
                    ),
                  ),
              ],
            ),
          ),

          // Bottom Checkout Sheet Overlay
          if (!isLoading && cartItems.isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Promo Code Row
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'PROMO CODE',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black38,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5D9CC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'APPLY',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Totals Calculations
                      _TotalsRow(label: 'Sub Total', value: totalPrice),
                      const SizedBox(height: 12),
                      _TotalsRow(label: 'Shipping', value: 0),
                      const SizedBox(height: 12),
                      _TotalsRow(
                        label: 'Bag Total',
                        value: totalPrice,
                        isBold: true,
                      ),

                      const SizedBox(height: 24),

                      // Proceed To Checkout Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CheckoutScreen(totalPrice: totalPrice),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD2BCA8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Proceed To Checkout',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TotalsRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;

  const _TotalsRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -',
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: TextStyle(color: Colors.grey.shade400, letterSpacing: 2),
            ),
          ),
        ),
        Text(
          value.toStringAsFixed(2),
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
