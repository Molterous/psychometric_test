import './assets.dart';
import '../helper/triple.dart';

class StringAssets {

  static const String appName             = "Psychometric Tests";

  static const String addedSoonText       = "New Tests Will be added soon...";

  static const String crtTitle            = "Critical Reaction Test (CRT)";
  static const String crtDesc             = "This test is designed to measure a user's visual perception, reaction time, and motor coordination under varying conditions. A train image continuously moves across the screen—either from the left or the right—and the participant must stop the train as accurately as possible when it aligns with a visible tunnel.";


  static const homeScreenTests = const [
    const Triple(
      crtTitle,
      crtDesc,
      Assets.trainImg,
    ),
  ];

}