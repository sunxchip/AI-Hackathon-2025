import 'package:flutter/material.dart';

import 'api/naver_directions_service.dart';
import 'api/elevation_service.dart';
import 'api/csv_utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/mainMapScreen.dart';
import 'screens/inputSearchScreen.dart';
import 'screens/routeSummaryScreen.dart';
import 'screens/profileScreen.dart';
import 'screens/chargingStationScreen.dart';
// import 'screens/savedLocationScreen.dart';
// import 'screens/registerVehicleScreen.dart';
import 'screens/DeviceInfoScreen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 바인딩 초기화
  await dotenv.load();

  final naverClientId = dotenv.env['NAVER_CLIENT_ID']!;
  final naverClientSecret = dotenv.env['NAVER_CLIENT_SECRET']!;
  final googleApiKey = dotenv.env['GOOGLE_API_KEY']!;
  final startLat = "37.5665", startLng = "126.9780";
  final goalLat = "37.5772", goalLng = "126.9855";

  try {
    // 1. 경로 Polyline 추출
    final coords = await fetchRouteCoordinates(
      startLat: startLat, startLng: startLng,
      goalLat: goalLat, goalLng: goalLng,
      naverClientId: naverClientId,
      naverClientSecret: naverClientSecret,
    );

    // 2. 고도값 조회 (API 요청 안전모드 ON)
    final coordsWithEle = await fetchElevationsBatch(
      latLngList: coords,
      googleApiKey: googleApiKey,
      batchSize: 512,
      maxRequests: 500,
      minDelayMs: 250,
      safeMode: true,
    );

    // 3. csv로 저장
    final path = await saveToCsvSimple(coordsWithEle, filename: "my_path.csv");
    print('CSV 저장 위치: $path');

  } catch (e, st) {
    print("오류: $e\n$st");
  }

  //Flutter UI
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 해커톤',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMapScreen(),
        '/input': (context) => const InputSearchScreen(),
        '/route': (context) => const RouteSummaryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/charging': (context) => const ChargingStationScreen(),
        // '/saved': (context) => const SavedLocationScreen(),
        '/routeSummary': (context) => const RouteSummaryScreen(),
        // '/register': (context) => const RegisterVehicleScreen(),
        '/savedDevice': (context) => DeviceInfoScreen(
          onBack: () => Navigator.pop(context),
        ),


      },
    );
  }
}
