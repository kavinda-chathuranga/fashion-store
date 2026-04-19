import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/animations.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> mockNotifications = [
      {
        'title': 'New Collection Alert!',
        'body': 'Discover our Autumn Collection 2026 now.',
        'time': '2 hours ago',
        'icon': 'collection'
      },
      {
        'title': 'Order Dispatched',
        'body': 'Your order #ORD12345 has been shipped.',
        'time': '1 day ago',
        'icon': 'order'
      },
      {
        'title': 'Flash Sale!',
        'body': 'Up to 50% off on all accessories for the next 24 hours.',
        'time': '3 days ago',
        'icon': 'sale'
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          children: [
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
                      'Notifications',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: mockNotifications.isEmpty
                  ? Center(
                      child: Text(
                        'No notifications yet',
                        style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: mockNotifications.length,
                      itemBuilder: (context, index) {
                        final notif = mockNotifications[index];
                        final iconData = notif['icon'] == 'order'
                            ? Icons.local_shipping_outlined
                            : notif['icon'] == 'sale'
                                ? Icons.local_offer_outlined
                                : Icons.collections_outlined;

                        return StaggeredItem(
                          index: index,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE5D9CC),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(iconData, size: 20, color: Colors.white),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              notif['title']!,
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            notif['time']!,
                                            style: GoogleFonts.inter(
                                              color: Colors.black38,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        notif['body']!,
                                        style: GoogleFonts.inter(
                                          color: Colors.black54,
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
