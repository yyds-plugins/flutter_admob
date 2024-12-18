import 'dart:async';

import 'package:flutter/material.dart';

import 'banner_view.dart';
import 'flutter_admob.dart';

class FlutterAdmobPage extends StatefulWidget {
  const FlutterAdmobPage({Key? key}) : super(key: key);

  @override
  State<FlutterAdmobPage> createState() => _FlutterGromorePageState();
}

class _FlutterGromorePageState extends State<FlutterAdmobPage> {
  String interstitialId = "";

  @override
  void initState() {
// TODO: implement initState
    super.initState();
  }

  /// 展示开屏广告
  static Future<void> showSplashAd() async {
    FlutterAdmob.showSplashAd();
  }

  /// 加载插屏广告
  static Future<void> showInterstitialAd() async {
    FlutterAdmob.showInterstitialAd();
  }

  /// 激励视频广告
  static Future<void> showRewardAd(
      {void Function(bool)? onRewardVerify, void Function()? onAdClose}) async {
    FlutterAdmob.showRewarded();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Demo"),
        ),
        body: const Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
// ElevatedButton(
//   onPressed: initSDK,
//   child: Text("初始化SDK"),
// ),
// SizedBox(height: 20),
                ElevatedButton(
                  onPressed: showSplashAd,
                  child: Text("开屏广告"),
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: showInterstitialAd,
                  child: Text("插屏广告"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: showRewardAd,
                  child: Text("激励视频广告"),
                ),
                SizedBox(height: 20),
                Text("banner广告"),
                AdmobBannerView()
              ],
            ),
          ),
        ));
  }
}
