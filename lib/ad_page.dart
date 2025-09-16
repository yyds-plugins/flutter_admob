import 'package:easy_admob_ads_flutter/easy_admob_ads_flutter.dart';
import 'package:flutter/material.dart';

import 'flutter_admob.dart';

class AdPage extends StatelessWidget {
  const AdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: AdsDemo());
  }
}

class AdsDemo extends StatefulWidget {
  const AdsDemo({super.key});
  @override
  State<AdsDemo> createState() => _AdsDemoState();
}

class _AdsDemoState extends State<AdsDemo> {
  late AdmobInterstitialAd _interstitialAd;
  late AdmobRewardedAd _rewardedAd;
  late AdmobRewardedInterstitialAd _rewardedInterstitialAd;

  @override
  void initState() {
    super.initState();
    _loadAllAds();
  }

  final _consentManager = ConsentManager();

  Future<void> _loadAllAds() async {
    // Interstitial
    _interstitialAd = AdmobInterstitialAd(
      minTimeBetweenAds: Duration(seconds: 20),
      onAdStateChanged: (state) {
        debugPrint('Interstitial ad state: $state');
      },
    );
    _interstitialAd.loadAd();

    // Rewarded
    _rewardedAd = AdmobRewardedAd(
      onAdStateChanged: (state) {
        debugPrint('Rewarded ad state: $state');
      },
      onRewardEarned: (reward) {
        // _unlockLevel();
        debugPrint('You earned ${reward.amount} coins!');
      },
    );
    _rewardedAd.loadAd();

    // Rewarded Interstitial
    _rewardedInterstitialAd = AdmobRewardedInterstitialAd(
      onAdStateChanged: (state) {
        setState(() {
          switch (state) {
            case AdState.initial:
              // Initial state before any action
              break;
            case AdState.loading:
              // Ad is loading
              break;
            case AdState.loaded:
              // Ad loaded successfully and ready to show
              break;
            case AdState.error:
              // Error occurred during loading/showing
              break;
            case AdState.closed:
              // Ad was closed by the user
              break;
            case AdState.disabled:
              // Ad was disabled by showAd = false
              break;
          }
        });
      },
      onRewardEarned: (reward) {
        // Show a confirmation to the user
        debugPrint('You earned ${reward.amount} coins!');
      },
    );
    _rewardedInterstitialAd.loadAd();
  }

  void _showInterstitialAd() async {
    final result = await _interstitialAd.showAd();

    if (!result.wasShown && mounted) {
      // You can provide specific messages or actions based on the fail reason
      switch (result.failReason) {
        case AdFailReason.adsDisabled:
          // Perhaps offer to enable ads for rewards
          break;
        case AdFailReason.cooldownPeriod:
          // Show countdown timer until next available ad
          break;
        case AdFailReason.notLoaded:
          // Show loading indicator and retry loading
          _rewardedAd.loadAd();
          break;
        case AdFailReason.showError:
          // Log the error or report to analytics
          break;
        case null:
          // Should not happen for failed ads
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message)));
    }
  }

  final _appOpenAdManager = AdmobAppOpenAd();
  void _showAppOpenAd() async {
    AdHelper.showAppOpenAds = true;
    final result = await _appOpenAdManager.showAdIfAvailable();

    if (!result.wasShown) {
      debugPrint("App Open Ad could not be shown: ${result.message}");
    }
  }

  @override
  void dispose() {
    _interstitialAd.dispose();
    _rewardedAd.dispose();
    _rewardedInterstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showAds = AdHelper.showAds;
    return Scaffold(
      appBar: AppBar(title: const Text('AdMob All Ads Demo')),
      bottomNavigationBar: AdmobBannerAd(collapsible: true, height: 100),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AdmobNativeAd.small(),
            Text("Check the console logs", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                _showInterstitialAd();
              },
              child: const Text('Show Interstitial'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                _rewardedAd.showAd();
              },
              child: const Text('Show Rewarded'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _rewardedInterstitialAd.showAd();
              },
              child: const Text('Show Rewarded Interstitial'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                _showAppOpenAd();
              },
              child: const Text('Manual Show App Open Ad'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showAds = !showAds;
                  AdHelper.showAds = showAds;
                });
              },
              child: Text(showAds ? 'Stop showing ads' : 'Start showing ads'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                MobileAds.instance.openAdInspector((error) {
                  // Error will be non-null if ad inspector closed due to an error.
                });
              },
              child: Text("Ad Inspector"),
            ),
            if (AdHelper.isPrivacyOptionsRequired) ...[
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  _consentManager.showPrivacyOptionsForm((formError) {
                    if (formError != null) {
                      debugPrint("${formError.errorCode}: ${formError.message}");
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("The privacy options form is unavailable because it is not required.")));
                      }
                    }
                  });
                },
                child: Text("Show GDPR Ad Privacy"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
