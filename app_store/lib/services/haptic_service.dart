import 'package:flutter_haptic_feedback/flutter_haptic_feedback.dart';

class HapticService {
  static Future<void> light() async => FlutterHapticFeedback.vibrate(HapticFeedbackType.lightImpact);
  static Future<void> medium() async => FlutterHapticFeedback.vibrate(HapticFeedbackType.mediumImpact);
  static Future<void> heavy() async => FlutterHapticFeedback.vibrate(HapticFeedbackType.heavyImpact);
}
