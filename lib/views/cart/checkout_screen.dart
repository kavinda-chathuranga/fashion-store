import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/animations.dart';
import 'payment_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalPrice;
  const CheckoutScreen({super.key, required this.totalPrice});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _selectedPaymentMethod = 0;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthController>().currentUser;
    if (user != null) {
      _addressController.text = user.address;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _placeOrder() async {
    if (_formKey.currentState!.validate()) {
      final cartController = context.read<CartController>();
      final orderController = context.read<OrderController>();
      final authController = context.read<AuthController>();

      final items = cartController.items.values.toList();
      final userId = authController.currentUser?.id ?? 'guest';

      await orderController.placeOrder(
        userId,
        items,
        widget.totalPrice,
        _addressController.text,
      );

      if (mounted) {
        cartController.clearCart();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PaymentSuccessScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<OrderController>().isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          children: [
            // Top Section with Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 14, color: Colors.black87),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Checkout',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 32), // Balance center
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInWidget(
                        delay: const Duration(milliseconds: 0),
                        child: Text(
                          'Delivery Details',
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeInWidget(
                        delay: const Duration(milliseconds: 80),
                        child: CustomTextField(
                          label: 'Shipping Address',
                          hint: 'Enter your full delivery address',
                          controller: _addressController,
                          validator: (val) => val == null || val.isEmpty ? 'Address is required' : null,
                        ),
                      ),
                      const SizedBox(height: 32),
                      FadeInWidget(
                        delay: const Duration(milliseconds: 160),
                        child: Text(
                          'Payment Method',
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeInWidget(
                        delay: const Duration(milliseconds: 200),
                        child: Row(
                          children: [
                            _PaymentMethodCard(
                              icon: Icons.credit_card, 
                              label: 'Card', 
                              isSelected: _selectedPaymentMethod == 0,
                              onTap: () => setState(() => _selectedPaymentMethod = 0),
                            ),
                            const SizedBox(width: 12),
                            _PaymentMethodCard(
                              icon: Icons.account_balance_wallet, 
                              label: 'PayPal', 
                              isSelected: _selectedPaymentMethod == 1,
                              onTap: () => setState(() => _selectedPaymentMethod = 1),
                            ),
                            const SizedBox(width: 12),
                            _PaymentMethodCard(
                              icon: Icons.apple, 
                              label: 'Apple Pay', 
                              isSelected: _selectedPaymentMethod == 2,
                              onTap: () => setState(() => _selectedPaymentMethod = 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      FadeInWidget(
                        delay: const Duration(milliseconds: 240),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))
                            ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Summary',
                                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Subtotal', style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                                  Text('Rs. ${widget.totalPrice.toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Delivery Fee', style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                                  Text('Free', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.green)),
                                ],
                              ),
                              const Divider(height: 32, color: Colors.black12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                                  Text('Rs. ${widget.totalPrice.toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      FadeInWidget(
                        delay: const Duration(milliseconds: 300),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isLoading ? () {} : _placeOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD2BCA8),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: isLoading 
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                'PLACE ORDER',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFD2BCA8) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFFD2BCA8) : Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.black54),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
