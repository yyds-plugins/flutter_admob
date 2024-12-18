import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobBannerView extends StatefulWidget {
  final double h;
  const AdmobBannerView({super.key, this.h = 10});

  @override
  State<AdmobBannerView> createState() => _AdmobBannerViewState();
}

class _AdmobBannerViewState extends State<AdmobBannerView> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final BannerAd banner = BannerAd(
        size: AdSize.banner,
        adUnitId: '',
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            debugPrint('$BannerAd loaded.');
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            debugPrint('$BannerAd failedToLoad: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => debugPrint('$BannerAd onAdOpened.'),
          onAdClosed: (Ad ad) => debugPrint('$BannerAd onAdClosed.'),
        ),
        request: const AdRequest())
      ..load();
    return Container(
      alignment: Alignment.center,
      width: banner.size.width.toDouble(),
      height: banner.size.height.toDouble(),
      child: AdWidget(ad: banner),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
