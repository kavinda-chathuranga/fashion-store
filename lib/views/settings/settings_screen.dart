import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme_controller.dart';
import '../../core/theme.dart';
import '../../widgets/animations.dart';
import 'help_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? Colors.black26
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 14,
                        color: context.textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Settings',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: context.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),

            // ── Settings List ───────────────────────────────────────
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: Text(
                        'App Settings',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: context.subTextColor.withOpacity(0.5),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    StaggeredItem(
                      index: 0,
                      child: _SettingsTile(
                        icon: Icons.dark_mode_outlined,
                        title: 'Dark Mode',
                        trailing: Switch(
                          value: themeController.isDarkMode,
                          activeThumbColor: context.beigeColor,
                          onChanged: (val) => themeController.toggleTheme(),
                        ),
                      ),
                    ),
                    StaggeredItem(
                      index: 1,
                      child: _SettingsTile(
                        icon: Icons.language_outlined,
                        title: 'Language',
                        trailingText: 'English',
                      ),
                    ),
                    StaggeredItem(
                      index: 2,
                      child: _SettingsTile(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HelpScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(
                      color: context.isDarkMode
                          ? Colors.white10
                          : Colors.black12,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: Text(
                        'About',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: context.subTextColor.withOpacity(0.5),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    StaggeredItem(
                      index: 3,
                      child: _SettingsTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                      ),
                    ),
                    StaggeredItem(
                      index: 4,
                      child: _SettingsTile(
                        icon: Icons.description_outlined,
                        title: 'Terms of Service',
                      ),
                    ),
                    StaggeredItem(
                      index: 5,
                      child: _SettingsTile(
                        icon: Icons.info_outline,
                        title: 'App Version',
                        trailingText: '1.0.0',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final String? trailingText;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? Colors.white.withOpacity(0.02)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.beigeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: context.beigeColor),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: context.textColor,
          ),
        ),
        trailing:
            trailing ??
            (trailingText != null
                ? Text(
                    trailingText!,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: context.subTextColor,
                    ),
                  )
                : Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: context.subTextColor.withOpacity(0.5),
                  )),
        onTap: onTap,
      ),
    );
  }
}
