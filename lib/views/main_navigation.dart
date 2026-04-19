import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/cart_controller.dart';
import '../controllers/auth_controller.dart';
import '../core/theme.dart';
import 'home/home_screen.dart';
import 'product/product_list_screen.dart';
import 'cart/cart_screen.dart';
import 'profile/profile_screen.dart';
import 'orders/order_history_screen.dart';
import 'wishlist/wishlist_screen.dart';
import 'settings/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = const [
    HomeScreen(),
    ProductListScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  late final List<AnimationController> _tabControllers;
  late final List<Animation<double>> _tabFades;

  @override
  void initState() {
    super.initState();
    _tabControllers = List.generate(
      _pages.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        value: i == 0 ? 1.0 : 0.0,
      ),
    );
    _tabFades = _tabControllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _tabControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTabTap(int index) {
    if (index == _currentIndex) return;
    _tabControllers[_currentIndex].reverse();
    setState(() => _currentIndex = index);
    _tabControllers[index].forward();
  }

  @override
  Widget build(BuildContext context) {
    final cartItemCount = context.watch<CartController>().itemCount;
    final user = context.watch<AuthController>().currentUser;

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: Drawer(
        backgroundColor: context.headerColor,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: context.beigeColor.withOpacity(0.2),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: context.beigeColor,
                    child: Text(
                      user?.name.substring(0, 1).toUpperCase() ?? '?',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Guest User',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: context.textColor,
                          ),
                        ),
                        Text(
                          user?.email ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: context.subTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _DrawerTile(
              icon: Icons.home_outlined,
              title: 'Home',
              onTap: () {
                Navigator.pop(context);
                _onTabTap(0);
              },
            ),
            _DrawerTile(
              icon: Icons.shopping_bag_outlined,
              title: 'My Orders',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
              },
            ),
            _DrawerTile(
              icon: Icons.favorite_border,
              title: 'Wishlist',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const WishlistScreen()));
              },
            ),
            _DrawerTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
            ),
            const Spacer(),
            const Divider(),
            _DrawerTile(
              icon: Icons.logout,
              title: 'Logout',
              color: Colors.redAccent,
              onTap: () {
                context.read<AuthController>().logout();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: Stack(
        children: List.generate(_pages.length, (i) {
          return FadeTransition(
            opacity: _tabFades[i],
            child: IgnorePointer(
              ignoring: _currentIndex != i,
              child: _pages[i],
            ),
          );
        }),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: _AnimatedNavBar(
            currentIndex: _currentIndex,
            cartBadge: cartItemCount,
            onTap: _onTabTap,
          ),
        ),
      ),
    );
  }
}

class _AnimatedNavBar extends StatelessWidget {
  final int currentIndex;
  final int cartBadge;
  final ValueChanged<int> onTap;

  const _AnimatedNavBar({
    required this.currentIndex,
    required this.cartBadge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'icon': Icons.home_filled, 'label': 'Home'},
      {'icon': Icons.shopping_bag, 'label': 'Shop'},
      {'icon': Icons.shopping_cart, 'label': 'Cart'},
      {'icon': Icons.person, 'label': 'Profile'},
    ];

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: context.beigeColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (i) {
          final isSelected = i == currentIndex;
          final item = navItems[i];
          
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                    size: 24,
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 4),
                    Text(
                      item['label'] as String,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? context.textColor),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: color ?? context.textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
