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
              childAspectRatio: 0.88,
              children: [
                _buildSubjectCard(
                  "Physics",
                  "Matter & Energy",
                  Icons.blur_on_rounded,
                  const Color(0xFF2196F3),
                  isLight,
                ),
                _buildSubjectCard(
                  "Chemistry",
                  "Elements & Compounds",
                  Icons.biotech_rounded,
                  const Color(0xFF10B981),
                  isLight,
                ),
                _buildSubjectCard(
                  "Mathematics",
                  "Algabra & Geometry",
                  Icons.architecture_rounded,
                  const Color(0xFF9333EA),
                  isLight,
                ),
                _buildSubjectCard(
                  "History",
                  "World Civilizations",
                  Icons.history_edu_rounded,
                  const Color(0xFFF59E0B),
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
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          // Premium Illustration/Image Space
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isLight ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ground/Desk shelf line
                Positioned(
                  bottom: 12,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: isLight ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
                
                // Elements Row representing the illustration
                Positioned(
                  bottom: 14,
                  child: SizedBox(
                    width: 300,
                    height: 140,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // 1. Globe on the left
                        Positioned(
                          left: 10,
                          bottom: 10,
                          child: Icon(
                            Icons.public_rounded,
                            size: 54,
                            color: const Color(0xFF42A5F5).withOpacity(0.85),
                          ),
                        ),
                        Positioned(
                          left: 22,
                          bottom: 5,
                          child: Container(
                            width: 30,
                            height: 15,
                            decoration: BoxDecoration(
                              color: const Color(0xFF90A4AE),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                            ),
                          ),
                        ),

                        // 2. Flask/Science behind books
                        Positioned(
                          left: 100,
                          bottom: 30,
                          child: Icon(
                            Icons.science_outlined,
                            size: 44,
                            color: const Color(0xFF26A69A).withOpacity(0.6),
                          ),
                        ),
                        
                        // 3. Stack of colorful books
                        Positioned(
                          left: 70,
                          bottom: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Top book
                              Container(
                                width: 90,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF26C6DA),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(height: 1.5),
                              // Second book
                              Container(
                                width: 100,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF81C784),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(height: 1.5),
                              // Third book
                              Container(
                                width: 110,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF8A65),
                                  borderRadius: BorderRadius.circular(3.5),
                                ),
                              ),
                              const SizedBox(height: 1.5),
                              // Bottom book
                              Container(
                                width: 115,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5C6BC0),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 4. Smartphone standing on the right
                        Positioned(
                          right: 25,
                          bottom: 5,
                          child: Container(
                            width: 58,
                            height: 94,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF263238),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFCFD8DC), width: 1.5),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Brand Logo/Acronynm inside phone
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.auto_awesome,
                                        size: 14,
                                        color: Color(0xFF1E88E5),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Smart X",
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 6,
                                          fontWeight: FontWeight.w900,
                                          color: const Color(0xFF0F172A),
                                        ),
                                      ),
                                      Text(
                                        "Academy",
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 4,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Top camera notch
                                  Positioned(
                                    top: 1,
                                    child: Container(
                                      width: 14,
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF263238),
                                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(2)),
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
                  ),
                ),
                
                // Centered Play Button overlay (matches the translucent design)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF64748B).withOpacity(0.4),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
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
    Color accentColor,
    bool isLight,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isLight ? const Color(0xFF0F172A) : Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: const Color(0xFF64748B),
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
