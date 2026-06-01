import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw UnsupportedError('Unsupported platform');
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// Loads and returns a BannerAd widget
  static Widget getBannerAdWidget() {
    return const SmartXBannerAdContainer();
  }

  /// Loads and shows a Rewarded Video Ad
  static void showRewardedAd({
    required Function(RewardItem reward) onUserEarnedReward,
  }) {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          if (kDebugMode) {
            print('$ad loaded.');
          }
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
            },
          );

          ad.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              onUserEarnedReward(reward);
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (kDebugMode) {
            print('RewardedAd failed to load: $error');
          }
        },
      ),
    );
  }
}

class SmartXBannerAdContainer extends StatefulWidget {
  const SmartXBannerAdContainer({super.key});

  @override
  State<SmartXBannerAdContainer> createState() => _SmartXBannerAdContainerState();
}

class _SmartXBannerAdContainerState extends State<SmartXBannerAdContainer> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          if (kDebugMode) {
            print('BannerAd failed to load: $err');
          }
          ad.dispose();
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
    if (_isLoaded && _bannerAd != null) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
