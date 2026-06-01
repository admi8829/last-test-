import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isDarkMode;
  final String languageCode;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleLanguage;

  const SplashScreen({
    super.key,
    required this.isDarkMode,
    required this.languageCode,
    required this.onToggleTheme,
    required this.onToggleLanguage,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _progressValue = 0.0;
  String _statusMessage = "Starting system...";
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    
    // Smooth branding pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startLoadingProcess();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startLoadingProcess() {
    const totalDuration = Duration(milliseconds: 2500); // 2.5 seconds total loading
    const interval = Duration(milliseconds: 25);
    final totalSteps = totalDuration.inMilliseconds ~/ interval.inMilliseconds;
    int currentStep = 0;

    _timer = Timer.periodic(interval, (timer) {
      currentStep++;
      if (currentStep >= totalSteps) {
        timer.cancel();
        setState(() {
          _progressValue = 1.0;
          _statusMessage = widget.languageCode == 'am' 
              ? "ዝግጁ ነው! እንኳን ደህና መጡ።" 
              : "Ready! Welcome to Smart X.";
        });
        
        // Wait a small moment so user sees 100% completion, then animate navigation
        Future.delayed(const Duration(milliseconds: 350, once completed: null), () {
          if (mounted) {
            _navigateToHome();
          }
        });
      } else {
        setState(() {
          _progressValue = currentStep / totalSteps;
          _updateStatusMessage(_progressValue);
        });
      }
    });
  }

  void _updateStatusMessage(double progress) {
    bool isAmharic = widget.languageCode == 'am';
    if (progress < 0.2) {
      _statusMessage = isAmharic ? "ሞጁሎችን በማስጀመር ላይ..." : "Initializing study modules...";
    } else if (progress < 0.45) {
      _statusMessage = isAmharic ? "የትምህርት መረጃዎችን በማገናኘት ላይ..." : "Connecting learning frameworks...";
    } else if (progress < 0.7) {
      _statusMessage = isAmharic ? "ቪዲዮዎችን እና ቲቶሪያሎችን በማዘጋጀት ላይ..." : "Caching video tutorials...";
    } else if (progress < 0.9) {
      _statusMessage = isAmharic ? "የክፍል ደረጃ አስተካካዮችን በማረጋገጥ ላይ..." : "Calibrating student interface...";
    } else {
      _statusMessage = isAmharic ? "ፕሮግራሙን በመክፈት ላይ..." : "Opening Academy hub...";
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(
          isDarkMode: widget.isDarkMode,
          languageCode: widget.languageCode,
          onToggleTheme: widget.onToggleTheme,
          onToggleLanguage: widget.onToggleLanguage,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 550),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLight = !widget.isDarkMode;
    final int percentage = (_progressValue * 100).toInt();

    return Scaffold(
      backgroundColor: isLight ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background soft visual ambiance
          Positioned(
            top: -100,
            right: -100,
            child: _buildBlurSphere(
              color: isLight ? const Color(0xFFE0F2FE) : const Color(0xFF1E3A8A).withOpacity(0.3),
              size: 300,
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: _buildBlurSphere(
              color: isLight ? const Color(0xFFF3E8FF) : const Color(0xFF4C1D95).withOpacity(0.2),
              size: 280,
            ),
          ),

          // Main splash container
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 4),

                // Pulsing Interactive Logo Frame
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isLight ? Colors.white : const Color(0xFF1E293B),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: isLight 
                              ? const Color(0xFF2563EB).withOpacity(0.12)
                              : const Color(0xFF000000).withOpacity(0.4),
                          blurRadius: 36,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Hero(
                      tag: 'app_logo',
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF3B82F6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.auto_awesome_mosaic_rounded,
                          size: 58,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  "Smart X Academy",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: isLight ? const Color(0xFF0F172A) : Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  widget.languageCode == 'am' 
                      ? "የኢትዮጵያ የትምህርት ማዕከል (9-12)"
                      : "Ethiopian Study Hub (Grades 9-12)",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                    letterSpacing: 0.1,
                  ),
                ),

                const Spacer(flex: 3),

                // Loading Counter
                Text(
                  "$percentage%",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: isLight ? const Color(0xFF2563EB) : const Color(0xFF60A5FA),
                    letterSpacing: -1,
                  ),
                ),
                
                const SizedBox(height: 12),

                // Premium thin loading track
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    height: 6,
                    width: double.infinity,
                    color: isLight ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                    child: Row(
                      children: [
                        Flexible(
                          flex: (percentage * 100).toInt(),
                          fit: FlexFit.tight,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF2563EB), Color(0xFF60A5FA)],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: ((1.0 - _progressValue) * 10000).toInt(),
                          child: const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Changing loader context/subtitle
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    _statusMessage,
                    key: ValueKey<String>(_statusMessage),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Soft credit line at the bottom
                Text(
                  widget.languageCode == 'am' 
                      ? "ከክብር ጋር በ Smart X የተዘጋጀ"
                      : "Crafted with honor by Smart X",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF94A3B8).withOpacity(0.6),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurSphere({required Color color, required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
