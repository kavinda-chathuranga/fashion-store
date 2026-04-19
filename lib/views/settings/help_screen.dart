import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/animations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      'Help & Support',
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
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  Text(
                    'Frequently Asked Questions',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FAQItem(
                    index: 0,
                    question: 'How can I track my order?',
                    answer: 'You can track your order in the "Order History" section of your profile. Once dispatched, a tracking number will be provided.',
                  ),
                  _FAQItem(
                    index: 1,
                    question: 'What is your return policy?',
                    answer: 'We offer a 30-day return policy for all luxury items. Items must be in their original condition with tags attached.',
                  ),
                  _FAQItem(
                    index: 2,
                    question: 'Do you ship internationally?',
                    answer: 'Yes, we ship to over 50 countries worldwide. Shipping costs and delivery times vary by location.',
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Contact Us',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ContactTile(
                    index: 3,
                    icon: Icons.email_outlined,
                    title: 'Email Support',
                    subtitle: 'support@fashionstore.com',
                  ),
                  _ContactTile(
                    index: 4,
                    icon: Icons.phone_outlined,
                    title: 'Phone Support',
                    subtitle: '+91 98765 43210',
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;
  final int index;
  const _FAQItem({required this.question, required this.answer, required this.index});

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return StaggeredItem(
      index: widget.index,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          title: Text(
            widget.question,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          trailing: Icon(
            _expanded ? Icons.remove : Icons.add,
            color: const Color(0xFFD2BCA8),
            size: 18,
          ),
          onExpansionChanged: (val) => setState(() => _expanded = val),
          children: [
            Text(
              widget.answer,
              style: GoogleFonts.inter(
                color: Colors.black54,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int index;
  const _ContactTile({required this.icon, required this.title, required this.subtitle, required this.index});

  @override
  Widget build(BuildContext context) {
    return StaggeredItem(
      index: index,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE5D9CC).withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: Colors.black54),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: Colors.black38)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
