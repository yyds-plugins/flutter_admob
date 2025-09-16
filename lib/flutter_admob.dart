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

  static String testDevice = '2CFB15DF96F80C09B4534B12A968C542';
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
        AdType.banner: kDebugMode ? _adID.iosBannerId : 'ca-app-pub-3940256099942544/8388050270', // Test ID
        AdType.interstitial: kDebugMode ? _adID.iosInsertId : 'ca-app-pub-3940256099942544/4411468910', // Test ID
        AdType.rewarded: kDebugMode ? _adID.iosRewardId : 'ca-app-pub-3940256099942544/1712485313', // Test ID
        AdType.rewardedInterstitial:
            kDebugMode ? _adID.iosRewardedInterstitialId : 'ca-app-pub-3940256099942544/6978759866', // Test ID
        AdType.appOpen: kDebugMode ? _adID.iosSplashId : 'ca-app-pub-3940256099942544/5575463023', // Test ID
        AdType.native: kDebugMode ? _adID.iosNativeId : 'ca-app-pub-3940256099942544/3986624511', // Test ID
      },
      android: {
        AdType.banner: kDebugMode ? _adID.androidBannerId : 'ca-app-pub-3940256099942544/2014213617', // Test ID
        AdType.interstitial: kDebugMode ? _adID.androidBannerId : 'ca-app-pub-3940256099942544/1033173712', // Test ID
        AdType.rewarded: kDebugMode ? _adID.androidBannerId : 'ca-app-pub-3940256099942544/5224354917', // Test ID
        AdType.rewardedInterstitial:
            kDebugMode ? _adID.androidBannerId : 'ca-app-pub-3940256099942544/5354046379', // Test ID
        AdType.appOpen: kDebugMode ? _adID.androidBannerId : 'ca-app-pub-3940256099942544/3419835294', // Test ID
        AdType.native: kDebugMode ? _adID.androidBannerId : 'ca-app-pub-3940256099942544/2247696110', // Test ID
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
