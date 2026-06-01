import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradeCoursesScreen extends StatefulWidget {
  final int grade;

  const GradeCoursesScreen({super.key, required this.grade});

  @override
  State<GradeCoursesScreen> createState() => _GradeCoursesScreenState();
}

class _GradeCoursesScreenState extends State<GradeCoursesScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final bool isLight = !_isDarkMode;

    return Scaffold(
      backgroundColor: isLight ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isLight ? Colors.black : Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Grade ${widget.grade}",
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            color: isLight ? const Color(0xFF0F172A) : Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isLight ? Icons.nightlight_round : Icons.wb_sunny_rounded,
              color: isLight ? const Color(0xFF334155) : Colors.amber,
            ),
            onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Icon(Icons.language, color: isLight ? const Color(0xFF334155) : Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(
                  "EN/አማ",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isLight ? const Color(0xFF334155) : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Featured Card
            _buildFeaturedCard(isLight),

            const SizedBox(height: 32),

            // Subjects Header
            Text(
              "Subjects",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isLight ? const Color(0xFF0F172A) : Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Subjects Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: [
                _buildSubjectCard(
                  "Physics",
                  "Matter & Energy",
                  Icons.science,
                  const Color(0xFFE0F2FE),
                  const Color(0xFF1E88E5),
                  isLight,
                ),
                _buildSubjectCard(
                  "Chemistry",
                  "Elements & Compounds",
                  Icons.biotech,
                  const Color(0xFFE0F8F5),
                  const Color(0xFF0D9488),
                  isLight,
                ),
                _buildSubjectCard(
                  "Mathematics",
                  "Algebra & Geometry",
                  Icons.calculate,
                  const Color(0xFFF3E8FF),
                  const Color(0xFF9333EA),
                  isLight,
                ),
                _buildSubjectCard(
                  "History",
                  "World Civilizations",
                  Icons.history_edu,
                  const Color(0xFFFEF3C7),
                  const Color(0xFFD97706),
                  isLight,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(isLight),
    );
  }

  Widget _buildFeaturedCard(bool isLight) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Mock Illustration/Image Space
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isLight ? const Color(0xFFF1F5F9) : const Color(0xFF334155),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.auto_awesome_mosaic,
                  size: 80,
                  color: isLight ? Colors.blue.withOpacity(0.2) : Colors.white10,
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Grade ${widget.grade} Courses",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: isLight ? const Color(0xFF0F172A) : Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Explore subjects and materials.",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor,
    bool isLight,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isLight ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isLight ? bgColor : iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: isLight ? const Color(0xFF0F172A) : Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: const Color(0xFF94A3B8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(bool isLight) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : const Color(0xFF0F172A),
        border: Border(
          top: BorderSide(
            color: isLight ? const Color(0xFFF1F5F9) : const Color(0xFF334155),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(Icons.home_filled, "Home", true, isLight),
          _buildNavItem(Icons.menu_book_rounded, "Courses", false, isLight),
          _buildNavItem(Icons.person_outline_rounded, "Profile", false, isLight),
          _buildNavItem(Icons.settings_outlined, "Settings", false, isLight),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, bool isLight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.blue : const Color(0xFF94A3B8),
          size: 26,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? Colors.blue : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}
