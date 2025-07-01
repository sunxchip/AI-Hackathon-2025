import 'package:flutter/material.dart';
import 'RouteSummaryScreen.dart';
import 'DeviceInfoScreen.dart';
import 'ChargingStationScreen.dart';
import 'ProfileScreen.dart';

class MainMapScreen extends StatefulWidget {
  const MainMapScreen({super.key});

  @override
  State<MainMapScreen> createState() => _MainMapScreenState();
}

class _MainMapScreenState extends State<MainMapScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();

    _screens.addAll([
      const MainMapContent(),
      DeviceInfoScreen(onBack: () {
        setState(() {
          _selectedIndex = 0;
        });
      }),
      const ChargingStationScreen(),
      const ProfileScreen(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF7F4F8),
        selectedItemColor: const Color(0xFF41867C),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '지도'),
          BottomNavigationBarItem(icon: Icon(Icons.wheelchair_pickup), label: '저장된 기기'),
          BottomNavigationBarItem(icon: Icon(Icons.ev_station), label: '충전소 찾기'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
      ),
    );
  }
}

class MainMapContent extends StatelessWidget {
  const MainMapContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/map_sample.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 60,
          left: 16,
          right: 16,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text('주소 검색', style: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RouteSummaryScreen()),
                  );
                },
                child: Image.asset(
                  'assets/images/start_map.png',
                  height: 48,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
