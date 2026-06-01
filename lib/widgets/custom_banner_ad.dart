import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomBannerAd extends StatefulWidget {
  final String? adUnitId;
  final AdSize size;
  final VoidCallback? onAdLoaded;
  final Function(LoadAdError)? onAdFailedToLoad;

  const CustomBannerAd({
    super.key,
    this.adUnitId,
    this.size = AdSize.banner,
    this.onAdLoaded,
    this.onAdFailedToLoad,
  });

  @override
  State<CustomBannerAd> createState() => _CustomBannerAdState();
}

class _CustomBannerAdState extends State<CustomBannerAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initBannerAd();
  }

  /// Get the correct ad unit ID based on platform
  String _getAdUnitId() {
    if (kIsWeb) return '';
    if (widget.adUnitId != null) return widget.adUnitId!;
    
    // Default to Google Test IDs if none provided
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    return '';
  }

  void _initBannerAd() {
    // Safety check for test environments or unsupported platforms
    if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) return;

    _bannerAd = BannerAd(
      adUnitId: _getAdUnitId(),
      size: widget.size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (kDebugMode) print('Banner Ad loaded successfully.');
          if (mounted) {
            setState(() {
              _isLoaded = true;
              _hasError = false;
            });
            if (widget.onAdLoaded != null) widget.onAdLoaded!();
          }
        },
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) print('Banner Ad failed to load: $error');
          ad.dispose();
          if (mounted) {
            setState(() {
              _isLoaded = false;
              _hasError = true;
            });
            if (widget.onAdFailedToLoad != null) widget.onAdFailedToLoad!(error);
          }
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If ad is loaded, show it
    if (_isLoaded && _bannerAd != null) {
      return Container(
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }

    // Graceful fallback for error or loading states
    // We return a shrinked sized box to not disrupt UI flow if it fails
    if (_hasError) {
      return const SizedBox.shrink();
    }

    // While loading, we return a small placeholder or empty box
    return SizedBox(
      height: widget.size.height.toDouble(),
      width: double.infinity,
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent),
        ),
      ),
    );
  }
}
