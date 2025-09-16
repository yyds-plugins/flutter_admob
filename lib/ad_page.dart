import 'dart:async';

import 'package:flutter/material.dart';

import 'banner_view.dart';
import 'flutter_admob.dart';

class AdmobPage extends StatefulWidget {
  const AdmobPage({Key? key}) : super(key: key);

  @override
  State<AdmobPage> createState() => _AdmobPagePageState();
}

class _AdmobPagePageState extends State<AdmobPage> {
  String interstitialId = "";

  @override
  void initState() {
// TODO: implement initState
    super.initState();
  }

  /// 展示开屏广告
  static Future<void> showSplashAd() async {
    FlutterGTAds.showSplashAd();
  }

  /// 加载插屏广告
  static Future<void> showInterstitialAd() async {
    FlutterGTAds.showInterstitialAd();
  }

  static Future<void> showRewardedInterstitialAd() async {
    FlutterGTAds.showRewardedInterstitialAd();
  }

  /// 激励视频广告
  static Future<void> showRewardAd({void Function(bool)? onRewardVerify, void Function()? onAdClose}) async {
    FlutterGTAds.showRewardAd(onVerifyClose: (code, v) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Demo"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("banner广告"),
                FlutterGTAds.bannerView(),
                SizedBox(height: 20),
                const ElevatedButton(
                  onPressed: showSplashAd,
                  child: Text("开屏广告"),
                ),
                SizedBox(height: 20),
                const ElevatedButton(
                  onPressed: showInterstitialAd,
                  child: Text("插屏广告"),
                ),
                SizedBox(height: 20),
                const ElevatedButton(
                  onPressed: showRewardedInterstitialAd,
                  child: Text("插屏激励广告"),
                ),
                SizedBox(height: 20),
                const ElevatedButton(
                  onPressed: showRewardAd,
                  child: Text("激励视频广告"),
                ),
                SizedBox(height: 20),
                Text("信息流广告"),
                FlutterGTAds.feedView(),
              ],
            ),
          ),
        ));
  }
}
