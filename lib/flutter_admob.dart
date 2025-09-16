library flutter_admob;

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_admob/banner_view.dart';
import 'package:flutter_admob/widgets/AppLifecycleReactor.dart';
import 'package:flutter_admob/widgets/AppOpenAdManager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'adid.dart';
import 'feed_view.dart';
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
    await MobileAds.instance.initialize();

    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(testDeviceIds: [testDevice]));
  }

  static showSplashAd() {
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()
      ..loadAd(Platform.isAndroid ? adID.androidSplashId : adID.iosSplashId);
    AppLifecycleReactor appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    appLifecycleReactor.listenToAppStateChanges();
  }

  static showInsertAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid ? adID.androidInsertId : adID.iosInsertId,
        // adUnitId: Platform.isAndroid
        //     ? 'ca-app-pub-3940256099942544/1033173712'
        //     : 'ca-app-pub-3940256099942544/4411468910',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd interstitialAd) {
            debugPrint('$interstitialAd loaded');
            interstitialAd.setImmersiveMode(true);
            interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (InterstitialAd ad) => debugPrint('ad onAdShowedFullScreenContent.'),
              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                debugPrint('$ad onAdDismissedFullScreenContent.');
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
              },
            );
            interstitialAd.show();
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error.');
          },
        ));
  }

  static void showRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: Platform.isAndroid ? adID.androidRewardedInterstitialId : adID.iosRewardedInterstitialId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            debugPrint('$ad loaded.');
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
                  debugPrint('$ad onAdShowedFullScreenContent.'),
              onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
                debugPrint('$ad onAdDismissedFullScreenContent.');
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent: (RewardedInterstitialAd ad, AdError error) {
                debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
              },
            );

            ad.setImmersiveMode(true);
            ad.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              debugPrint('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedInterstitialAd failed to load: $error');
          },
        ));
  }

  static showRewardAd({required void Function(int, bool) onVerifyClose}) {
    RewardedAd.load(
        adUnitId: Platform.isAndroid ? adID.androidRewardId : adID.iosRewardId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd rewardedAd) {
            debugPrint('$rewardedAd loaded.');

            rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (RewardedAd ad) => debugPrint('ad onAdShowedFullScreenContent.'),
              onAdDismissedFullScreenContent: (RewardedAd ad) {
                debugPrint('$ad onAdDismissedFullScreenContent.');
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
                debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
              },
            );

            rewardedAd.setImmersiveMode(true);
            rewardedAd.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              onVerifyClose(0, true);
              debugPrint('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  static Widget bannerView() {
    return AdmobBannerView(Platform.isAndroid ? adID.androidBannerId : adID.iosBannerId);
  }

  static Widget feedView() {
    return FeedView(adUnitId: Platform.isAndroid ? adID.androidNativeId : adID.iosNativeId);
  }
}
