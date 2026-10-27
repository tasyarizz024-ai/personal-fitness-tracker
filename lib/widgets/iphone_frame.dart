// lib/widgets/iphone_frame.dart
import 'dart:async';
import 'package:flutter/material.dart';

/// Pilihan warna sasis Titanium iPhone 16 Pro
enum IPhoneColor {
  blackTitanium,
  naturalTitanium,
  desertTitanium,
  whiteTitanium,
}

class IPhoneFrame extends StatefulWidget {
  final Widget child;

  const IPhoneFrame({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<IPhoneFrame> createState() => _IPhoneFrameState();
}

class _IPhoneFrameState extends State<IPhoneFrame> {
  bool _enableFrame = true;
  IPhoneColor _selectedColor = IPhoneColor.blackTitanium;
  late Timer _clockTimer;
  String _currentTime = '09:41';
  bool _isIslandExpanded = false;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _clockTimer =
        Timer.periodic(const Duration(seconds: 30), (_) => _updateTime());
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    if (mounted) {
      setState(() {
        _currentTime = '$hour:$minute';
      });
    }
  }

  void _cycleColor() {
    setState(() {
      final values = IPhoneColor.values;
      final nextIndex = (values.indexOf(_selectedColor) + 1) % values.length;
      _selectedColor = values[nextIndex];
    });
  }

  String get _colorLabel {
    switch (_selectedColor) {
      case IPhoneColor.blackTitanium:
        return 'Black';
      case IPhoneColor.naturalTitanium:
        return 'Natural';
      case IPhoneColor.desertTitanium:
        return 'Desert';
      case IPhoneColor.whiteTitanium:
        return 'White';
    }
  }

  Color get _bezelColor {
    switch (_selectedColor) {
      case IPhoneColor.blackTitanium:
        return const Color(0xFF1C1C1E);
      case IPhoneColor.naturalTitanium:
        return const Color(0xFF383734);
      case IPhoneColor.desertTitanium:
        return const Color(0xFF423830);
      case IPhoneColor.whiteTitanium:
        return const Color(0xFF4A4B4D);
    }
  }

  Color get _frameBorderColor {
    switch (_selectedColor) {
      case IPhoneColor.blackTitanium:
        return const Color(0xFF2C2C2E);
      case IPhoneColor.naturalTitanium:
        return const Color(0xFF5A5852);
      case IPhoneColor.desertTitanium:
        return const Color(0xFF6B5C50);
      case IPhoneColor.whiteTitanium:
        return const Color(0xFF7A7C80);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Jika layar sudah berukuran HP (< 520px) atau pengguna mematikan bingkai
        if (constraints.maxWidth < 520 || !_enableFrame) {
          return Stack(
            children: [
              widget.child,
              if (constraints.maxWidth >= 520)
                Positioned(
                  top: 16,
                  right: 16,
                  child: _buildFloatingControls(),
                ),
            ],
          );
        }

        // Tampilan Desktop / Web Browser: Tampilkan Mockup iPhone 16 Pro Mewah
        final screenHeight = constraints.maxHeight;
        // Target iPhone 16 Pro ratio: 393 x 852
        // Skala frame agar pas vertikal di browser
        final targetPhoneHeight = 852.0;
        final targetPhoneWidth = 393.0;

        // Hitung skala jika tinggi browser terbatas
        final availableHeight = screenHeight - 60; // beri margin
        final scale = (availableHeight / targetPhoneHeight).clamp(0.65, 1.0);

        return Scaffold(
          backgroundColor: const Color(0xFF060910),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.2),
                radius: 1.2,
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF070B14),
                  Color(0xFF030508),
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background ambient glow di belakang phone
                Positioned(
                  child: Container(
                    width: 440 * scale,
                    height: 890 * scale,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60 * scale),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00F59B).withOpacity(0.08),
                          blurRadius: 100,
                          spreadRadius: 20,
                        ),
                        BoxShadow(
                          color: const Color(0xFF00E5FF).withOpacity(0.06),
                          blurRadius: 120,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),

                // Floating Top Controls Bar
                Positioned(
                  top: 20,
                  child: _buildFloatingControls(),
                ),

                // Mockup iPhone 16 Pro
                Transform.scale(
                  scale: scale,
                  child:
                      _buildIPhoneHardware(targetPhoneWidth, targetPhoneHeight),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF131B30).withOpacity(0.92),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF1C2844)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF00F59B).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.phone_iphone_rounded,
                    color: Color(0xFF00F59B), size: 16),
                SizedBox(width: 6),
                Text(
                  'iPhone 16 Pro',
                  style: TextStyle(
                    color: Color(0xFF00F59B),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Warna Titanium (Klik untuk ganti warna)
          InkWell(
            onTap: _cycleColor,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF18233E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _frameBorderColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white38),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Titanium: $_colorLabel',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Toggle Frame
          InkWell(
            onTap: () => setState(() => _enableFrame = !_enableFrame),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF18233E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    _enableFrame
                        ? Icons.fullscreen_rounded
                        : Icons.phone_iphone_rounded,
                    color: Colors.white70,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _enableFrame ? 'Layar Penuh' : 'Bingkai iPhone',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIPhoneHardware(double phoneWidth, double phoneHeight) {
    const bezelThickness = 12.0;
    final totalWidth = phoneWidth + (bezelThickness * 2);
    final totalHeight = phoneHeight + (bezelThickness * 2);

    return Container(
      width: totalWidth,
      height: totalHeight,
      decoration: BoxDecoration(
        color: _bezelColor,
        borderRadius: BorderRadius.circular(55),
        border: Border.all(color: _frameBorderColor, width: 3.5),
        boxShadow: [
          // Bayangan luar sasis iPhone yang realistis
          BoxShadow(
            color: Colors.black.withOpacity(0.65),
            blurRadius: 40,
            spreadRadius: 8,
            offset: const Offset(0, 16),
          ),
          // Kilauan chamfered edge luar
          BoxShadow(
            color: Colors.white.withOpacity(0.12),
            blurRadius: 1,
            spreadRadius: 0.5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // --- TOMBOL FISIK SAMPING ---
          // Action Button (Kiri Atas)
          Positioned(
            left: -7,
            top: 110,
            child: Container(
              width: 5,
              height: 28,
              decoration: BoxDecoration(
                color: _frameBorderColor,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(3)),
              ),
            ),
          ),
          // Volume Up (Kiri)
          Positioned(
            left: -7,
            top: 155,
            child: Container(
              width: 5,
              height: 50,
              decoration: BoxDecoration(
                color: _frameBorderColor,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(3)),
              ),
            ),
          ),
          // Volume Down (Kiri)
          Positioned(
            left: -7,
            top: 220,
            child: Container(
              width: 5,
              height: 50,
              decoration: BoxDecoration(
                color: _frameBorderColor,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(3)),
              ),
            ),
          ),
          // Power Button (Kanan)
          Positioned(
            right: -7,
            top: 170,
            child: Container(
              width: 5,
              height: 75,
              decoration: BoxDecoration(
                color: _frameBorderColor,
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(3)),
              ),
            ),
          ),

          // --- LAYAR OLED IPHONE (SCREEN AREA) ---
          Positioned.fill(
            top: bezelThickness,
            bottom: bezelThickness,
            left: bezelThickness,
            right: bezelThickness,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(44),
              child: Stack(
                children: [
                  // Aplikasi Flutter Sebenarnya dengan iPhone Safe Area
                  MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      size: Size(phoneWidth, phoneHeight),
                      padding: const EdgeInsets.only(top: 50, bottom: 24),
                      viewPadding: const EdgeInsets.only(top: 50, bottom: 24),
                    ),
                    child: widget.child,
                  ),

                  // iOS Top Status Bar (Overlay)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: _buildIOSStatusBar(),
                    ),
                  ),

                  // iOS Dynamic Island (Overlay Interaktif)
                  Positioned(
                    top: 11,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: _buildDynamicIsland(),
                    ),
                  ),

                  // iOS Bottom Home Indicator (Garis swipe putih)
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: Center(
                        child: Container(
                          width: 135,
                          height: 4.5,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.35),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIOSStatusBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Jam iOS (kiri)
          Text(
            _currentTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),

          // Indikator iOS (kanan: Sinyal, 5G, Wi-Fi, Baterai)
          Row(
            children: [
              // 4 Bar Sinyal Seluler
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildSignalBar(4),
                  const SizedBox(width: 1.5),
                  _buildSignalBar(6),
                  const SizedBox(width: 1.5),
                  _buildSignalBar(8),
                  const SizedBox(width: 1.5),
                  _buildSignalBar(10),
                ],
              ),
              const SizedBox(width: 5),
              // Tulisan 5G
              const Text(
                '5G',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 5),
              // Ikon Wi-Fi
              const Icon(Icons.wifi_rounded, color: Colors.white, size: 15),
              const SizedBox(width: 5),
              // Indikator Baterai Khas iOS dengan pill 100%
              Container(
                width: 24,
                height: 11.5,
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.5),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.8), width: 1.2),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF00F59B), // Baterai penuh hijau neon
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignalBar(double height) {
    return Container(
      width: 2.5,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.8),
      ),
    );
  }

  Widget _buildDynamicIsland() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isIslandExpanded = !_isIslandExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutBack,
        width: _isIslandExpanded ? 210 : 124,
        height: _isIslandExpanded ? 46 : 30,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _isIslandExpanded
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.directions_run_rounded,
                            color: Color(0xFF00F59B), size: 16),
                        SizedBox(width: 6),
                        Text(
                          'FitTrack Live',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00E5FF),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Aktif',
                          style: TextStyle(
                            color: Color(0xFF00E5FF),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 10),
                  // Sensor lubang kamera depan TrueDepth
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF080C14),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF162540),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 3.5,
                        height: 3.5,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E3A8A),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Titik indikator kecil sensor ambient
                  Container(
                    width: 5.5,
                    height: 5.5,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0C1322),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
              ),
      ),
    );
  }
}
