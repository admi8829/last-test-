import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../services/gms_and_ads_service.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final String languageCode;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleLanguage;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.languageCode,
    required this.onToggleTheme,
    required this.onToggleLanguage,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _selectedGrade = 9; // Options: 9, 10, 11, 12

  // Dictionary for dynamic translation matching 'EN/አማርኛ'
  final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Smart X Academy',
      'greet_title': 'Hello Student!',
      'greet_sub': 'Grade level selector active',
      'explore_title': 'National Grade Syllabus',
      'nav_home': 'Home',
      'nav_courses': 'Courses',
      'nav_settings': 'Settings',
      'nav_about': 'About',
    },
    'am': {
      'title': 'ስማርት ኤክስ አካዳሚ',
      'greet_title': 'ሰላም ተማሪ!',
      'greet_sub': 'የክፍል ደረጃ መምረጫው ገባሪ ነው',
      'explore_title': 'ብሔራዊ የክፍል ሥርዓተ ትምህርት',
      'nav_home': 'መነሻ',
      'nav_courses': 'ኮርሶች',
      'nav_settings': 'ማስተካከያዎች',
      'nav_about': 'ስለ እኛ',
    }
  };

  String _local(String key) {
    return _localizedValues[widget.languageCode]?[key] ?? key;
  }

  // Interactive module content dynamic by grade selector
  Map<String, dynamic> _getFeaturedModule() {
    switch (_selectedGrade) {
      case 9:
        return {
          'title': 'Interactive Chemical Synthesis Module',
          'teacher': 'Dr. Samuel',
          'duration': '42 mins',
          'video_id': 'FRjnr4UAhNk',
          'image_url': 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=600&auto=format&fit=crop&q=80',
        };
      case 10:
        return {
          'title': 'Genetics & Biological Chromosomes study',
          'teacher': 'Prof. Eleni Bekele',
          'duration': '55 mins',
          'video_id': 'Y89gXoXfPlg',
          'image_url': 'https://images.unsplash.com/photo-1507668077129-56e32842fceb?w=600&auto=format&fit=crop&q=80',
        };
      case 11:
        return {
          'title': 'Advanced Quantum Mechanics & Relativity Intro',
          'teacher': 'Dr. Johannes',
          'duration': '1 hour 15 mins',
          'video_id': 'hGfG848WUXg',
          'image_url': 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=600&auto=format&fit=crop&q=80',
        };
      case 12:
        return {
          'title': 'Calculus Limits, Derivatives & Functions Mastery',
          'teacher': 'Ato Abraham Alula',
          'duration': '1 hour 30 mins',
          'video_id': '2gMv-NswG_c',
          'image_url': 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=600&auto=format&fit=crop&q=80',
        };
      default:
        return {};
    }
  }

  // Syllabus list items for subject grid
  List<Map<String, dynamic>> _getSyllabusItems() {
    final gradeText = "G$_selectedGrade";
    return [
      {
        'subject': 'Biology $gradeText',
        'lessons': _selectedGrade == 9
            ? '12 Lessons • Cell Cycle & Species'
            : _selectedGrade == 10
                ? '15 Lessons • Ecosystems & Genetics'
                : _selectedGrade == 11
                    ? '18 Lessons • Human Physiology'
                    : '22 Lessons • Molecular Biology & Biotech',
        'icon': Icons.bubble_chart_rounded,
        'badgeColor': const Color(0xFFE0F2FE),
        'textColor': const Color(0xFF0369A1),
        'iconColor': const Color(0xFF0284C7),
        'bgColor': const Color(0xFFF0F9FF),
      },
      {
        'subject': 'Chemistry $gradeText',
        'lessons': _selectedGrade == 9
            ? '15 Lessons • Gas States & Atoms'
            : _selectedGrade == 10
                ? '18 Lessons • Chemical Equilibrium'
                : _selectedGrade == 11
                    ? '20 Lessons • Hydrocarbons & Organic'
                    : '24 Lessons • Industrial Chemistry',
        'icon': Icons.science_rounded,
        'badgeColor': const Color(0xFFE0F8F5),
        'textColor': const Color(0xFF0F766E),
        'iconColor': const Color(0xFF0D9488),
        'bgColor': const Color(0xFFF2FBF9),
      },
      {
        'subject': 'Physics $gradeText',
        'lessons': _selectedGrade == 9
            ? '14 Lessons • Forces & Motion'
            : _selectedGrade == 10
                ? '16 Lessons • Electromagnetism Intro'
                : _selectedGrade == 11
                    ? '19 Lessons • Thermodynamics & Heat'
                    : '25 Lessons • Modern Nuclear Physics',
        'icon': Icons.psychology_rounded,
        'badgeColor': const Color(0xFFFEF3C7),
        'textColor': const Color(0xFFB45309),
        'iconColor': const Color(0xFFD97706),
        'bgColor': const Color(0xFFFFFDF5),
      },
      {
        'subject': 'Mathematics $gradeText',
        'lessons': _selectedGrade == 9
            ? '20 Lessons • Real Numbers & Algebra'
            : _selectedGrade == 10
                ? '22 Lessons • Solid Geometry & Trigo'
                : _selectedGrade == 11
                    ? '25 Lessons • Vectors & Complex Num'
                    : '30 Lessons • Limits & Integrals Masterclass',
        'icon': Icons.calculate_rounded,
        'badgeColor': const Color(0xFFF3E8FF),
        'textColor': const Color(0xFF7E22CE),
        'iconColor': const Color(0xFF9333EA),
        'bgColor': const Color(0xFFFAF5FF),
      },
    ];
  }

  void _triggerAdAndExecute(VoidCallback action) {
    // Show interstitial sponsor ad
    GmsAndAdsService.showInterstitialAd(() {
      action();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLight = !widget.isDarkMode;

    return Scaffold(
      backgroundColor: isLight ? const Color(0xFFFDFEFE) : const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Mock status bar area matching the screenshot header to details
            _buildMockStatusBar(isLight),

            // 2. Main Tab router
            Expanded(
              child: _buildCurrentTab(isLight),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isLight ? Colors.white : const Color(0xFF1E293B),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: isLight ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF1E88E5),
          unselectedItemColor: isLight ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          selectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Icon(_currentIndex == 0 ? Icons.home_filled : Icons.home_outlined),
              ),
              label: _local('nav_home'),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Icon(_currentIndex == 1 ? Icons.menu_book_sharp : Icons.menu_book_outlined),
              ),
              label: _local('nav_courses'),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Icon(_currentIndex == 2 ? Icons.settings : Icons.settings_outlined),
              ),
              label: _local('nav_settings'),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Icon(_currentIndex == 3 ? Icons.info : Icons.info_outline),
              ),
              label: _local('nav_about'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockStatusBar(bool isLight) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "12:41",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isLight ? const Color(0xFF1E293B) : Colors.white,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: isLight ? const Color(0xFFD1FAE5) : const Color(0xFF065F46),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "GMS",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: isLight ? const Color(0xFF065F46) : const Color(0xFF34D399),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 11,
                      color: isLight ? const Color(0xFF065F46) : const Color(0xFF34D399),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "100%",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isLight ? const Color(0xFF1E293B) : Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.battery_full_rounded,
                size: 16,
                color: isLight ? const Color(0xFF1E293B) : Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTab(bool isLight) {
    switch (_currentIndex) {
      case 0:
        return _buildHomeScreenContent(isLight);
      case 1:
        return _buildCoursesScreen(isLight);
      case 2:
        return _buildSettingsScreen(isLight);
      case 3:
        return _buildAboutScreen(isLight);
      default:
        return _buildHomeScreenContent(isLight);
    }
  }

  Widget _buildHomeScreenContent(bool isLight) {
    final featured = _getFeaturedModule();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Beautiful Header Greeting Row matching screenshot
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _local('greet_title'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w800,
                        color: isLight ? const Color(0xFF0F172A) : Colors.white,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      _local('greet_sub'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              // LHS Student Avatar Matcher
              _buildLargeProfileAvatar(isLight),
            ],
          ),

          const SizedBox(height: 24.0),

          // 2. Grade Selection horizontal chips matching G9, G10, G11, G12
          _buildGradeSelectorChips(isLight),

          const SizedBox(height: 26.0),

          // 3. Featured Card (Interactive Module box matching screenshot)
          _buildFeaturedInteractiveCard(isLight, featured),

          const SizedBox(height: 28.0),

          // 4. Section Syllabus Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _local('explore_title'),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w800,
                  color: isLight ? const Color(0xFF0F172A) : Colors.white,
                  letterSpacing: -0.4,
                ),
              ),
              Text(
                "G$_selectedGrade STATUS",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E88E5), // Blue accent color
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16.0),

          // 5. Grid of Subjects (2-Column dynamic grid matching screen)
          _buildSubjectGrid(isLight),

          const SizedBox(height: 20.0),

          // 6. GMS Sponsored banner placed at bottom of scrolling page
          const SmartXAdsBannerWidget(),
        ],
      ),
    );
  }

  Widget _buildLargeProfileAvatar(bool isLight) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isLight ? const Color(0xFFEFF6FF) : const Color(0xFF1E3A8A),
        shape: BoxShape.circle,
        border: Border.all(
          color: isLight ? const Color(0xFFBFDBFE) : const Color(0xFF3B82F6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        "ST",
        style: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: isLight ? const Color(0xFF1E40AF) : const Color(0xFF93C5FD),
        ),
      ),
    );
  }

  Widget _buildGradeSelectorChips(bool isLight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [9, 10, 11, 12].map((gradeNum) {
        final isSelected = _selectedGrade == gradeNum;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedGrade = gradeNum;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isLight ? Colors.white : const Color(0xFF1E293B))
                    : (isLight ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A)),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: isSelected
                      ? (isLight ? const Color(0xFFE2E8F0) : const Color(0xFF334155))
                      : Colors.transparent,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10.0,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                "G$gradeNum",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15.0,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? (isLight ? const Color(0xFF0F172A) : Colors.white)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeaturedInteractiveCard(bool isLight, Map<String, dynamic> featured) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isLight ? Colors.white : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20.0), // Rounded corners (border-radius: 20)
        boxShadow: [
          BoxShadow(
            color: isLight ? Colors.black.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.2),
            blurRadius: 16.0,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: isLight ? const Color(0xFFF1F5F9) : const Color(0xFF334155),
          width: 1,
        ),
      ),
      clipBehavior: Theme.of(context).brightness == Brightness.dark ? Clip.antiAlias : Clip.none,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Thumbnail stacked with translucent Play button
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 185,
                  width: double.infinity,
                  color: isLight ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                  child: Image.network(
                    featured['image_url'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.school, size: 50, color: Colors.grey));
                    },
                  ),
                ),
                // Play overlay element
                GestureDetector(
                  onTap: () {
                    _triggerAdAndExecute(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Course details coming soon!')),
                      );
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Color(0xFF1E88E5),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Text section below thumbnail matches description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    featured['title'],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                      color: isLight ? const Color(0xFF0F172A) : Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      Text(
                        "Teacher: ${featured['teacher']}",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "•",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Duration: ${featured['duration']}",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectGrid(bool isLight) {
    final list = _getSyllabusItems();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.0,
        mainAxisSpacing: 14.0,
        childAspectRatio: 1.15,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return GestureDetector(
          onTap: () {
            _triggerAdAndExecute(() {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Course details coming soon!')),
              );
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: isLight ? item['bgColor'] : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20.0), // border-radius: 20
              boxShadow: isLight
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
            ),
            child: Stack(
              children: [
                // Inner content structured like standard image index
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: isLight ? item['badgeColor'] : const Color(0xFF334155),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item['icon'],
                        color: isLight ? item['iconColor'] : Colors.white,
                        size: 20,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['subject'],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w800,
                            color: isLight ? const Color(0xFF0F172A) : Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 3.5),
                        Text(
                          item['lessons'],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF94A3B8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
                // Tiny decorative badge in top right corner
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: isLight
                          ? item['badgeColor']
                          : const Color(0xFF334155).withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "G$_selectedGrade",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: isLight ? item['textColor'] : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Beautiful redesigned "Courses" Tab
  Widget _buildCoursesScreen(bool isLight) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Syllabus Explore",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isLight ? const Color(0xFF0F172A) : Colors.white,
                ),
              ),
              _buildLargeProfileAvatar(isLight),
            ],
          ),
          const SizedBox(height: 16),
          // search box
          TextField(
            style: GoogleFonts.plusJakartaSans(),
            decoration: InputDecoration(
              hintText: "Search standard subjects...",
              hintStyle: GoogleFonts.plusJakartaSans(color: const Color(0xFF94A3B8)),
              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF94A3B8)),
              filled: true,
              fillColor: isLight ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildEnhancedCourseTile("Mathematics syllabus master", "Grades 9-12 full curriculum", "4.9 ★ (320 ratings)", "120 Chapters", Colors.purple, isLight),
          _buildEnhancedCourseTile("General Physics course", "Mechanics up to nuclear studies", "4.8 ★ (180 ratings)", "105 Chapters", Colors.amber, isLight),
          _buildEnhancedCourseTile("Standard Biology complete guide", "Cell physiology up to ecology study", "4.7 ★ (210 ratings)", "98 Chapters", const Color(0xFF10B981), isLight),
          _buildEnhancedCourseTile("Inorganic & Organic Chemistry", "Elements synthesis, rates & reactions", "4.8 ★ (150 ratings)", "112 Chapters", Colors.teal, isLight),
        ],
      ),
    );
  }

  Widget _buildEnhancedCourseTile(String title, String subtitle, String rating, String cCount, Color accent, bool isLight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isLight ? const Color(0xFFF1F5F9) : const Color(0xFF334155),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.class_rounded, color: accent, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: isLight ? const Color(0xFF0F172A) : Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                    const SizedBox(width: 3),
                    Text(
                      rating,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isLight ? const Color(0xFF475569) : Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      cCount,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w600,
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
  }

  // Modified beautiful Settings screen featuring custom triggers
  Widget _buildSettingsScreen(bool isLight) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _local('nav_settings'),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: isLight ? const Color(0xFF0F172A) : Colors.white,
              ),
            ),
            _buildLargeProfileAvatar(isLight),
          ],
        ),
        const SizedBox(height: 24),

        // Settings items card
        Container(
          decoration: BoxDecoration(
            color: isLight ? Colors.white : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isLight ? const Color(0xFFF1F5F9) : const Color(0xFF334155),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.g_translate_rounded, color: isLight ? const Color(0xFF1E3A8A) : Colors.blue),
                title: Text(
                  "Language / ቋንቋ",
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  widget.languageCode == 'en' ? "English (Amharic translation available)" : "አማርኛ (ወደ እንግሊዝኛ ቀይር)",
                  style: GoogleFonts.plusJakartaSans(fontSize: 11.5),
                ),
                trailing: Switch(
                  value: widget.languageCode == 'am',
                  onChanged: (val) => widget.onToggleLanguage(),
                ),
              ),
              const Divider(height: 1, indent: 50),
              ListTile(
                leading: Icon(Icons.nights_stay_rounded, color: isLight ? const Color(0xFF1E3A8A) : Colors.blue),
                title: Text(
                  "Dark theme layout Mode",
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  widget.isDarkMode ? "Dark Theme Enabled" : "Light Theme Enabled",
                  style: GoogleFonts.plusJakartaSans(fontSize: 11.5),
                ),
                trailing: Switch(
                  value: widget.isDarkMode,
                  onChanged: (val) => widget.onToggleTheme(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Notifications panel integrations check
        Text(
          "Notifications & Services Integrations",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15.0,
            fontWeight: FontWeight.w800,
            color: isLight ? const Color(0xFF0F172A) : Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18.0),
          decoration: BoxDecoration(
            color: isLight ? Colors.white : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isLight ? const Color(0xFFF1F5F9) : const Color(0xFF334155),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    GmsAndAdsService.isGmsAvailable ? Icons.verified_rounded : Icons.offline_bolt_rounded,
                    color: GmsAndAdsService.isGmsAvailable ? Colors.green : Colors.amber,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      GmsAndAdsService.isGmsAvailable ? "Google Play Services (GMS) Detected" : "Offline Sandbox Emulator Mode Active",
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 13.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildModernStatusLine("GMS API status verified", GmsAndAdsService.isGmsAvailable ? "YES" : "NO", isLight),
              _buildModernStatusLine("Firebase cloud notifications", GmsAndAdsService.isFirebaseInitialized ? "Active & Healthy" : "Offline Mode", isLight),
              _buildModernStatusLine("Preloaded Interstitial Ads", GmsAndAdsService.isInterstitialAdLoaded ? "System Ready" : "Standby/Offline", isLight),
              if (GmsAndAdsService.fcmToken != null) ...[
                const SizedBox(height: 16),
                Text(
                  "Firebase FCM Push Token:",
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isLight ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isLight ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    GmsAndAdsService.fcmToken!,
                    style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernStatusLine(String label, String val, bool isLight) {
    final statusColor = (val == "YES" || val == "Active & Healthy" || val == "System Ready")
        ? const Color(0xFF10B981)
        : const Color(0xFFF59E0B);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              color: const Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            val,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  // Beautiful redesigned "About" Tab
  Widget _buildAboutScreen(bool isLight) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "About Smart X",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isLight ? const Color(0xFF0F172A) : Colors.white,
                ),
              ),
              _buildLargeProfileAvatar(isLight),
            ],
          ),
          const SizedBox(height: 36),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isLight ? const Color(0xFFEEF2F6).withValues(alpha: 0.5) : const Color(0xFF1E293B),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school, size: 76, color: Color(0xFF1E88E5)),
          ),
          const SizedBox(height: 24),
          Text(
            "Smart X Academy",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: isLight ? const Color(0xFF0F172A) : Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Ethiopian Grade level study hub",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: const Color(0xFF94A3B8),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Premium offline-supported Android system build. Designed to help millions of Ethiopian students view highly robust, structured Grade 9, Grade 10, Grade 11, and Grade 12 educational syllabus topics, and watch streaming interactive study tutorials.",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              height: 1.6,
              fontWeight: FontWeight.w500,
              color: isLight ? const Color(0xFF475569) : Colors.grey[300],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isLight ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isLight ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "App Release Version",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                Text(
                  "1.0.0+1",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E88E5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
