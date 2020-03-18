import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:asset_pickers/asset_pickers.dart';

void main() {
  const MethodChannel channel = MethodChannel('asset_pickers');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
