import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_api_availability/google_api_availability.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Redundant - moved to NotificationService
}

class GmsAndAdsService {
  static bool isGmsAvailable = false;
  static bool isFirebaseInitialized = false;
  static bool isAdMobInitialized = false;
  static String? fcmToken;
  static String? statusMessage;
  static InterstitialAd? _interstitialAd;
  static bool isInterstitialAdLoaded = false;

  /// Private helper to get current firebase options
  static FirebaseOptions get currentFirebaseOptions {
    if (Platform.isIOS) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyBbDTLG9q0yCzXA-vzffB2hwSRoDeaXymA',
        appId: '1:629000096457:ios:ca9e524da1729a4afedb18',
        messagingSenderId: '629000096457',
        projectId: 'smart-x-academy',
        storageBucket: 'smart-x-academy.firebasestorage.app',
        iosBundleId: 'com.smartxacademy.app',
      );
    }
    return const FirebaseOptions(
      apiKey: 'AIzaSyBbDTLG9q0yCzXA-vzffB2hwSRoDeaXymA',
      appId: '1:629000096457:android:ca9e524da1729a4afedb18',
      messagingSenderId: '629000096457',
      projectId: 'smart-x-academy',
      storageBucket: 'smart-x-academy.firebasestorage.app',
    );
  }

  /// Initialize all requested services explicitly
  static Future<void> initializeAll() async {
    // 1. Initial GMS check
    isGmsAvailable = await _checkGmsAvailability();
    if (!isGmsAvailable) {
      statusMessage = "Non-GMS Device detected. Safe Mode active.";
      return;
    }

    // 2. Initialize Firebase
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: currentFirebaseOptions);
      }
      isFirebaseInitialized = true;
    } catch (e) {
      if (kDebugMode) print("Firebase Error: $e");
      statusMessage = "Firebase error: $e";
    }

    // 3. Initialize AdMob
    try {
      await MobileAds.instance.initialize();
      isAdMobInitialized = true;
      statusMessage = "All systems operational (GMS Active).";
      loadInterstitialAd();
    } catch (e) {
      if (kDebugMode) print("AdMob Error: $e");
      statusMessage = "AdMob error: $e";
    }
  }

  /// Preload an official Google AdMob test interstitial ad
  static void loadInterstitialAd() {
    if (!isGmsAvailable || !isAdMobInitialized) return;

    try {
      InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Official AdMob Test Interstitial ID
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            isInterstitialAdLoaded = true;
            if (kDebugMode) {
              print('AdMob Interstitial Ad loaded successfully.');
            }
          },
          onAdFailedToLoad: (error) {
            isInterstitialAdLoaded = false;
            _interstitialAd = null;
            if (kDebugMode) {
              print('AdMob Interstitial Ad failed to load: $error');
            }
          },
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception loading interstitial: $e");
      }
    }
  }

  /// Show the preloaded interstitial ad or call the onDismissed callback if not loaded
  static void showInterstitialAd(VoidCallback onDismissed) {
    if (isInterstitialAdLoaded && _interstitialAd != null) {
      try {
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            isInterstitialAdLoaded = false;
            _interstitialAd = null;
            onDismissed();
            loadInterstitialAd(); // Reload for next time
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            isInterstitialAdLoaded = false;
            _interstitialAd = null;
            onDismissed();
            loadInterstitialAd(); // Reload for next time
          },
        );
        _interstitialAd!.show();
      } catch (e) {
        if (kDebugMode) {
          print("Exception showing interstitial: $e");
        }
        onDismissed();
      }
    } else {
      if (kDebugMode) {
        print('Interstitial ad was not loaded. Executing callback directly.');
      }
      onDismissed();
    }
  }

  /// Private helper to check GMS availability
  static Future<bool> _checkGmsAvailability() async {
    if (!Platform.isAndroid) {
      // Non-Android platforms are not constrained by Google Play Services
      return true;
    }
    try {
      final dynamic googleApiCheck = GoogleApiAvailability.instance;
      final dynamic availability = await googleApiCheck.checkPlayServicesAvailability();
      return availability.toString().contains('success');
    } catch (e) {
      if (kDebugMode) {
        print("Exception during GMS check: $e");
      }
      return false;
    }
  }
}

/// A highly polished, GMS-safe AdMob banner widget
class SmartXAdsBannerWidget extends StatefulWidget {
  final AdSize adSize;
  const SmartXAdsBannerWidget({
    super.key,
    this.adSize = AdSize.banner,
  });

  @override
  State<SmartXAdsBannerWidget> createState() => _SmartXAdsBannerWidgetState();
}

class _SmartXAdsBannerWidgetState extends State<SmartXAdsBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      setState(() {
        _failed = true;
      });
      return;
    }

    // If GMS is not available, or AdMob has not successfully initialized,
    // do not attempt to load standard AdMob to avoid core crashes or errors.
    if (!GmsAndAdsService.isGmsAvailable || !GmsAndAdsService.isAdMobInitialized) {
      setState(() {
        _failed = true;
      });
      return;
    }

    try {
      _bannerAd = BannerAd(
        adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Official Google AdMob test banner unit ID
        size: widget.adSize,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _isLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            if (kDebugMode) {
              print('AdMob Banner Ad failed to load: $error');
            }
            ad.dispose();
            setState(() {
              _failed = true;
            });
          },
        ),
      )..load();
    } catch (e) {
      if (kDebugMode) {
        print("AdMob error in widget container: $e");
      }
      setState(() {
        _failed = true;
      });
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (_failed) {
      // Non-GMS or AdMob failed placeholder banner (Designed with exact visual quality)
      return Container(
        width: double.infinity,
        height: widget.adSize.height.toDouble(),
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          border: Border.all(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0D2353).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.security_rounded,
                color: Color(0xFF1E88E5),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Smart X Clean Safe Mode",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                      color: isDark ? Colors.white : const Color(0xFF1E2843),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    !GmsAndAdsService.isGmsAvailable
                        ? "Running without Google Play Services. No ads or tracking."
                        : "Educational Content Enabled.",
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "PREMIUM",
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 8.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (!_isLoaded) {
      // Sleek shimmering/loading placeholder state
      return Container(
        width: double.infinity,
        height: widget.adSize.height.toDouble(),
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          border: Border.all(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF1E88E5),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Preparing sponsor banner...",
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      );
    }

    // Return the actual Google Mobile Ads widget
    return Container(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      alignment: Alignment.center,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
