library flutter_admob;

import 'package:flutter/cupertino.dart';
import 'package:easy_admob_ads_flutter/easy_admob_ads_flutter.dart';

import 'adid.dart';
export 'adid.dart';
export 'ad_page.dart';

class FlutterGTAds {
  static AdID get adID => _adID;

  static AdID _adID = const AdID();

  static List<AdID> get configs => _configs;
  static List<AdID> _configs = [];

  late AdmobAppOpenAd _appOpenAd;
  late AdmobInterstitialAd _interstitialAd;
  late AdmobRewardedAd _rewardedAd;
  late AdmobRewardedInterstitialAd _rewardedInterstitialAd;

  initSDK({required List<AdID> configs}) async {
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
        AdType.interstitial: _adID.androidInsertId, // Test ID
        AdType.rewarded: _adID.androidRewardId, // Test ID
        AdType.rewardedInterstitial: _adID.androidRewardedInterstitialId, // Test ID
        AdType.appOpen: _adID.androidSplashId, // Test ID
        AdType.native: _adID.androidNativeId, // Test ID
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

  Widget showSplashAd() {
    _appOpenAd = AdmobAppOpenAd();
    _appOpenAd.onAdStateChanged = (state) {
      switch (state) {
        case AdState.initial: //
          // Initial state before any action
          break;
        case AdState.loading: //加载中
          // Ad is loading
          break;
        case AdState.loaded: //加载完成
          // Ad loaded successfully and ready to show
          _appOpenAd.showAdIfAvailable();
          break;
        case AdState.error: //加载错误
          // Error occurred during loading/showing
          break;
        case AdState.closed: //用户关闭了广告
          // Ad was closed by the user
          break;
        case AdState.disabled: //禁用了广告
          // Ad was disabled by showAd = false
          break;
      }
    };
    _appOpenAd.loadAd();
    return const SizedBox.shrink();
  }

  Widget splashWidget({BuildContext? context, required void Function() dismiss}) {
    dismiss();
    return const SizedBox.shrink();
  }

  Future<void> showInsertAd() async {
    _interstitialAd = AdmobInterstitialAd(
      minTimeBetweenAds: const Duration(seconds: 20),
      onAdStateChanged: (state) {
        if (state == AdState.loaded) {
          _interstitialAd.showAd();
        }
        debugPrint('AdmobInterstitialAd ad state: $state');
      },
    );
    _interstitialAd.loadAd();
  }

  void showRewardedInterstitialAd({required void Function(int, bool) onVerifyClose}) {
    _rewardedInterstitialAd = AdmobRewardedInterstitialAd(
      onAdStateChanged: (state) {
        if (state == AdState.loaded) {
          _rewardedInterstitialAd.showAd();
        }
        debugPrint('Rewarded ad state: $state');
      },
      onRewardEarned: (reward) {
        // Grant reward here
        onVerifyClose(0, true);
      },
    );
    _rewardedInterstitialAd.loadAd();
  }

  showRewardAd({required void Function(int, bool) onVerifyClose}) {
    _rewardedAd = AdmobRewardedAd(
      onAdStateChanged: (state) {
        if (state == AdState.loaded) {
          _rewardedAd.showAd();
        }
        debugPrint('Rewarded ad state: $state');
      },
      onRewardEarned: (reward) {
        // Grant the user a reward
        onVerifyClose(0, true);
      },
    );
    _rewardedAd.loadAd();
  }

  Widget bannerView() {
    return const AdmobBannerAd(collapsible: true, height: 64);
  }

  Widget feedView() {
    return AdmobNativeAd.medium();
  }
}
