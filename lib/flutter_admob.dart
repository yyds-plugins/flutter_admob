library flutter_admob;

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_admob/widgets/AppLifecycleReactor.dart';
import 'package:flutter_admob/widgets/AppOpenAdManager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'adid.dart';
export 'adid.dart';

class FlutterAdmob {
  static AdID adID = const AdID();
  static initSDK({required AdID adID}) async {
    adID = adID;
    MobileAds.instance.initialize();
  }

  static showSplashAd() {
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()
      ..loadAd(Platform.isAndroid ? adID.androidSplashId : adID.iosSplashId);
    AppLifecycleReactor appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    appLifecycleReactor.listenToAppStateChanges();
  }

  static showInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid ? adID.androidInsertId : adID.iosInsertId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd interstitialAd) {
            debugPrint('$interstitialAd loaded');
            interstitialAd.setImmersiveMode(true);
            interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (InterstitialAd ad) =>
                  debugPrint('ad onAdShowedFullScreenContent.'),
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

  static showRewarded({void Function(bool)? onRewardVerify, void Function()? onAdClose}) {
    RewardedAd.load(
        adUnitId: Platform.isAndroid ? adID.androidRewardId : adID.iosRewardId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd rewardedAd) {
            debugPrint('$rewardedAd loaded.');

            rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (RewardedAd ad) =>
                  debugPrint('ad onAdShowedFullScreenContent.'),
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
              debugPrint('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  void showRewardedInterstitialAd(String adUnitId) {
    RewardedInterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? adID.androidRewardedInterstitialId
            : adID.iosRewardedInterstitialId,
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

  static Widget feedView() {
    NativeAd nativeAd = NativeAd(
        adUnitId: Platform.isAndroid ? adID.androidNativeId : adID.iosNativeId,
        // adUnitId: Platform.isAndroid ? 'ca-app-pub-3940256099942544/1044960115' : 'ca-app-pub-3940256099942544/2521693316', 测试
        request: const AdRequest(),
        factoryId: '',
        listener: NativeAdListener(
          onAdLoaded: (Ad ad) {
            debugPrint('$NativeAd loaded.');
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            debugPrint('$NativeAd failedToLoad: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => debugPrint('$NativeAd onAdOpened.'),
          onAdClosed: (Ad ad) => debugPrint('$NativeAd onAdClosed.'),
        ))
      ..load();

    return AdWidget(ad: nativeAd);
  }
}
