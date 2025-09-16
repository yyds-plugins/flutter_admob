library flutter_admob;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_admob_ads_flutter/easy_admob_ads_flutter.dart';

import 'adid.dart';
export 'adid.dart';
export 'ad_page.dart';

class FlutterGTAds {
  static AdID get adID => _adID;

  static AdID _adID = const AdID();

  static List<AdID> get configs => _configs;
  static List<AdID> _configs = [];

  static initSDK({required List<AdID> configs}) async {
    if (!configs.isNotEmpty) return;
    _configs = configs;
    _adID = configs.first;

    AdHelper.setupAdLogging();
    AdHelper.testDeviceIds = ['2CFB15DF96F80C09B4534B12A968C542'];
    // Initialize ad unit IDs for Android and/or iOS (required for at least one)
    // Leave any value as an empty string ("") to skip that ad type.
    AdIdRegistry.initialize(
      ios: {
        AdType.banner: _adID.iosBannerId, // Test ID
        AdType.interstitial: _adID.iosInsertId, // Test ID
        AdType.rewarded: _adID.iosRewardId, // Test ID
        AdType.rewardedInterstitial: _adID.iosRewardedInterstitialId, // Test ID
        AdType.appOpen: _adID.iosSplashId, // Test ID
        AdType.native: _adID.iosNativeId, // Test ID
      },
      android: {
        AdType.banner: _adID.androidBannerId, // Test ID
        AdType.interstitial: _adID.androidBannerId, // Test ID
        AdType.rewarded: _adID.androidBannerId, // Test ID
        AdType.rewardedInterstitial: _adID.androidBannerId, // Test ID
        AdType.appOpen: _adID.androidBannerId, // Test ID
        AdType.native: _adID.androidBannerId, // Test ID
      },
    );

    // Global Ad Configuration
    AdHelper.showAds = true; // Set to false to disable all ads globally
    // AdHelper.showAppOpenAds = true; // Set to false to disable App Open Ad on startup

    // AdHelper.showConstentGDPR = true; // Simulate GDPR consent (debug only, false in release)

    // Initialize Google Mobile Ads SDK
    await AdmobService().initialize();

    // Optional: Use during development to test if all ad units load successfully
    // await AdRealIdValidation.validateAdUnits();
  }

  static showSplashAd() {
    final appOpenAd = AdmobAppOpenAd();
    appOpenAd.loadAd();
    appOpenAd.showAdIfAvailable();
  }

  static showInsertAd() {
    final interstitialAd = AdmobInterstitialAd();
    interstitialAd.loadAd();
    interstitialAd.showAd();
  }

  static void showRewardedInterstitialAd({required void Function(int, bool) onVerifyClose}) {
    final rewardedInterstitialAd = AdmobRewardedInterstitialAd(
      onRewardEarned: (reward) {
        // Grant reward here
        onVerifyClose(0, true);
      },
    );
    rewardedInterstitialAd.loadAd();
    rewardedInterstitialAd.showAd();
  }

  static showRewardAd({required void Function(int, bool) onVerifyClose}) {
    final rewardedAd = AdmobRewardedAd(
      onRewardEarned: (reward) {
        // Grant the user a reward
        onVerifyClose(0, true);
      },
    );
    rewardedAd.loadAd();
    rewardedAd.showAd();
  }

  static Widget bannerView() {
    return const AdmobBannerAd(collapsible: true, height: 64);
  }

  static Widget feedView() {
    return AdmobNativeAd.medium();
  }
}
