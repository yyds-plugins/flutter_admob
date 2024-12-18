enum Alias {
  unknown(name: '', code: ''),
  csj(name: '穿山甲', code: 'csj'),
  gromore(name: 'Gromore', code: 'gromore'),
  ylh(name: '优量汇', code: 'ylh'),
  ks(name: '快手', code: 'ks'),
  bqt(name: '百青藤', code: 'bqt'),
  admob(name: 'Admob', code: 'admob');

  final String name;
  final String code;
  const Alias({required this.name, required this.code});

  factory Alias.fromName(String name) {
    return Alias.values.firstWhere((element) => element.name == name);
  }

  factory Alias.fromWeight(String code) {
    return Alias.values.firstWhere((element) => element.code == code);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'code': code};
  }
}

class AdID {
  final Alias alias;
  final String androidId;
  final String androidSplashId;
  final String androidRewardId;
  final String androidInsertId;
  final String androidRewardedInterstitialId;
  final String androidNativeId;
  final String androidBannerId;

  final String iosId;
  final String iosSplashId;
  final String iosRewardId;
  final String iosInsertId;
  final String iosRewardedInterstitialId;
  final String iosNativeId;
  final String iosBannerId;

  const AdID(
      {this.alias = Alias.unknown,
      this.androidId = '',
      this.androidSplashId = '',
      this.androidRewardId = "",
      this.androidInsertId = "",
      this.androidRewardedInterstitialId = '',
      this.androidNativeId = "",
      this.androidBannerId = "",
      this.iosId = '',
      this.iosSplashId = "",
      this.iosRewardId = "",
      this.iosInsertId = "",
      this.iosRewardedInterstitialId = '',
      this.iosNativeId = "",
      this.iosBannerId = ""});
}
