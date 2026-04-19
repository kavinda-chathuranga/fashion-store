import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../orders/order_history_screen.dart';
import '../wishlist/wishlist_screen.dart';
import '../notifications/notifications_screen.dart';
import '../settings/settings_screen.dart';
import 'edit_profile_screen.dart';
import '../../core/theme.dart';
import '../../widgets/animations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final user = authController.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
           child: Text(
             'Not logged in',
             style: GoogleFonts.inter(fontSize: 16, color: context.subTextColor),
           )
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // ── Profile Header Card ───────────────────────────────────
            FadeInWidget(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.headerColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: context.beigeColor,
                      child: Text(
                        user.name.substring(0, 1).toUpperCase(),
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: context.textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: context.subTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                              );
                            },
                            child: Text(
                              'Edit Profile',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: context.beigeColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // ── Menu Options ──────────────────────────────────────────
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  children: [
                    _buildListTile(
                      context,
                      index: 0,
                      icon: Icons.shopping_bag_outlined,
                      title: 'Order History',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                        );
                      },
                    ),
                    _buildListTile(
                      context,
                      index: 1,
                      icon: Icons.favorite_outline,
                      title: 'My Wishlist',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const WishlistScreen()),
                        );
                      },
                    ),
                    _buildListTile(
                      context,
                      index: 2,
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                        );
                      },
                    ),
                    _buildListTile(
                      context,
                      index: 3,
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildListTile(
                      context,
                      index: 4,
                      icon: Icons.logout,
                      title: 'Logout',
                      color: Colors.redAccent,
                      onTap: () async {
                        await authController.logout();
                      },
                    ),
                    const SizedBox(height: 80), 
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    final itemColor = color ?? context.textColor;
    return StaggeredItem(
      index: index,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: context.isDarkMode ? Colors.white.withOpacity(0.03) : Colors.grey.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (color ?? context.beigeColor).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color ?? context.beigeColor, size: 20),
          ),
          title: Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: itemColor,
            ),
          ),
          subtitle: subtitle != null ? Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: context.subTextColor)) : null,
          trailing: Icon(Icons.arrow_forward_ios, size: 14, color: context.subTextColor.withOpacity(0.5)),
          onTap: onTap,
        ),
      ),
    );
  }
}
