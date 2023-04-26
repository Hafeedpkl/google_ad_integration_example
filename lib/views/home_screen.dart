import 'package:flutter/material.dart';
import 'package:google_ad_integration/ad_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    initBannerId();
    initInterstitialAd();
    super.initState();
  }

  late BannerAd bannerAd;
  late InterstitialAd interstitialAd;
  bool isAdLoaded = false;

  initBannerId() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-3940256099942544/6300978111",
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print(error);
          },
        ),
        request: AdRequest());
    bannerAd.load();
  }

  initInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            print('$ad loaded');
            interstitialAd = ad;
            setState(() {
              isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (error) {
            print(error);
          },
        ));
  }

  void showInterstitialAd() {
    if (interstitialAd == null) {
      print('something went wrong');
      return;
    }
    interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) =>
          print('ad onShowedFullScreenContent'),
      onAdWillDismissFullScreenContent: (ad) {
        print('$ad onDismissibleFullScreenContent');
        ad.dispose();
        initInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        initInterstitialAd();
      },
    );
    interstitialAd.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google ads'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'here is example for google ads from Admob',
            ),
            ElevatedButton(
                onPressed: showInterstitialAd,
                child: Text("show InterstitialAd"))
          ],
        ),
      ),
      bottomNavigationBar: isAdLoaded
          ? SizedBox(
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              child: AdWidget(ad: bannerAd),
            )
          : SizedBox(),
    );
  }
}
