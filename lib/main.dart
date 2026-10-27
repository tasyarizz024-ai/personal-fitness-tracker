// lib/main.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/add_activity_screen.dart';
import 'screens/history_screen.dart';
import 'screens/bmi_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/saved_menus_screen.dart';
import 'services/storage_service.dart';
import 'widgets/iphone_frame.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PersonalFitnessTrackerApp());
}

/// Palet warna: Iris Purple, Vibrant Lime & Soft Canvas sesuai mockup desain
class AppColors {
  static const Color background = Color(0xFFF7F8FC);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color cardAlt = Color(0xFFF1EFFE);
  static const Color cardHover = Color(0xFFEBE8FD);
  static const Color cardBorder = Color(0xFFEEF1F6);

  static const Color primary = Color(0xFF5844EB); // Iris Purple
  static const Color primaryHover = Color(0xFF4733DB);
  static const Color secondary = Color(0xFFD2FB52); // Vibrant Lime
  static const Color accentLime = Color(0xFFD2FB52);
  static const Color accentAmber = Color(0xFFFFAA00);
  static const Color accentCoral = Color(0xFFFF4770);
  static const Color accentCyan = Color(0xFF0284C7);

  static const Color textPrimary = Color(0xFF121626);
  static const Color textSecondary = Color(0xFF6E7787);
  static const Color textMuted = Color(0xFF959FAD);
  static const Color textDim = Color(0xFFCBD5E1);

  static const Color error = Color(0xFFFF4770);
}

class PersonalFitnessTrackerApp extends StatelessWidget {
  const PersonalFitnessTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrack - Personal Fitness Tracker',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.cardSurface,
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Color(0xFF121626),
          onSurface: AppColors.textPrimary,
        ),
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: AppColors.primary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
          margin: EdgeInsets.zero,
        ),
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      builder: (context, child) => IPhoneFrame(
        child: child ?? const SizedBox(),
      ),
      home: const RootSessionGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RootSessionGate extends StatefulWidget {
  const RootSessionGate({Key? key}) : super(key: key);

  @override
  State<RootSessionGate> createState() => _RootSessionGateState();
}

class _RootSessionGateState extends State<RootSessionGate> {
  final StorageService _storageService = StorageService();
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _initDefaultSession();
  }

  Future<void> _initDefaultSession() async {
    final user = await _storageService.getCurrentUser();
    setState(() {
      _isLoggedIn = user != null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (!_isLoggedIn) {
      return AuthScreen(
        onLoginSuccess: () {
          setState(() => _isLoggedIn = true);
        },
      );
    }

    return MainNavigationScreen(
      onLogout: () async {
        await _storageService.logout();
        setState(() => _isLoggedIn = false);
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final VoidCallback onLogout;
  const MainNavigationScreen({Key? key, required this.onLogout})
      : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  int _savedMenusKey = 0;
  // Notifiers untuk memuat ulang data ketika tab dibuka kembali.
  final _homeRefreshNotifier = ValueNotifier<int>(0);
  final _historyRefreshNotifier = ValueNotifier<int>(0);

  late final List<Widget> _screens;

  void _goToSaved() {
    setState(() {
      _currentIndex = 4;
      _savedMenusKey++;
    });
  }

  void _goToHome() {
    setState(() => _currentIndex = 0);
    _homeRefreshNotifier.value++;
  }

  void _goToHistory() {
    setState(() => _currentIndex = 3);
    _historyRefreshNotifier.value++;
  }

  @override
  void dispose() {
    _homeRefreshNotifier.dispose();
    _historyRefreshNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onNavigateToAdd: () => setState(() => _currentIndex = 1),
        onNavigateToHistory: _goToHistory,
        onNavigateToSaved: _goToSaved,
        onLogout: widget.onLogout,
        refreshNotifier: _homeRefreshNotifier,
      ),
      AddActivityScreen(
        onSaved: _goToHome,
      ),
      const BmiScreen(),
      HistoryScreen(refreshNotifier: _historyRefreshNotifier),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 4
          // SavedMenusScreen selalu di-rebuild segar setiap dibuka
          ? SavedMenusScreen(key: ValueKey(_savedMenusKey))
          : IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
      bottomNavigationBar: Container(
        height: 78,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tab 1: Beranda
              InkWell(
                onTap: () => setState(() => _currentIndex = 0),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home_rounded,
                        color: _currentIndex == 0
                            ? AppColors.primary
                            : AppColors.textMuted,
                        size: 24,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Beranda',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: _currentIndex == 0
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tab Tersimpan
              InkWell(
                onTap: _goToSaved,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bookmark_rounded,
                        color: _currentIndex == 4
                            ? AppColors.primary
                            : AppColors.textMuted,
                        size: 24,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Tersimpan',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: _currentIndex == 4
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Center: Floating Lime Button (+)
              Transform.translate(
                offset: const Offset(0, -14),
                child: GestureDetector(
                  onTap: () => setState(() => _currentIndex = 1),
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withValues(alpha: 0.6),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add_rounded,
                        color: Color(0xFF151828), size: 30),
                  ),
                ),
              ),

              // Tab Riwayat
              InkWell(
                onTap: _goToHistory,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.history_rounded,
                        color: _currentIndex == 3
                            ? AppColors.primary
                            : AppColors.textMuted,
                        size: 24,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Riwayat',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: _currentIndex == 3
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tab BMI
              InkWell(
                onTap: () => setState(() => _currentIndex = 2),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calculate_rounded,
                        color: _currentIndex == 2
                            ? AppColors.primary
                            : AppColors.textMuted,
                        size: 24,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'BMI',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: _currentIndex == 2
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
