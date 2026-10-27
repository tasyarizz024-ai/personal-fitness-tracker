// lib/screens/home_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../services/storage_service.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToAdd;
  final VoidCallback onNavigateToHistory;
  final VoidCallback onNavigateToSaved;
  final VoidCallback onLogout;
  final ValueListenable<int> refreshNotifier;

  const HomeScreen({
    Key? key,
    required this.onNavigateToAdd,
    required this.onNavigateToHistory,
    required this.onNavigateToSaved,
    required this.onLogout,
    required this.refreshNotifier,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final StorageService _storageService = StorageService();
  List<Activity> _activities = [];
  Map<String, String>? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.refreshNotifier.addListener(_loadData);
    _loadData();
  }

  @override
  void dispose() {
    widget.refreshNotifier.removeListener(_loadData);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final user = await _storageService.getCurrentUser();
    final activities = await _storageService.getActivities();

    if (!mounted) return;
    setState(() {
      _currentUser = user;
      _activities = activities;
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

    final totalDuration =
        _activities.fold(0, (sum, a) => sum + a.durationMinutes);
    final totalCalories =
        _activities.fold(0.0, (sum, a) => sum + a.caloriesBurned).round();
    final userName = _currentUser?['name'] ?? 'Tasya';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          titleSpacing: 20,
          title: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.all_inclusive_rounded,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'FITTRACK',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E2434),
                      letterSpacing: 0.6,
                    ),
                  ),
                  Text(
                    'Beranda',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            // Tombol Tersimpan (Bookmark)
            Container(
              margin: const EdgeInsets.only(right: 6),
              child: Tooltip(
                message: 'Menu Tersimpan',
                child: InkWell(
                  onTap: widget.onNavigateToSaved,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: const Icon(Icons.bookmark_rounded,
                        color: AppColors.primary, size: 20),
                  ),
                ),
              ),
            ),
            // Tombol Logout
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: Tooltip(
                message: 'Keluar',
                child: InkWell(
                  onTap: () => _confirmLogout(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECEE),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFFCDD2)),
                    ),
                    child: const Icon(Icons.logout_rounded,
                        color: AppColors.accentCoral, size: 20),
                  ),
                ),
              ),
            ),
            // Avatar Profil Tasya
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: () => _showUserMenu(context),
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 19,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFF84CC16),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: Colors.white,
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Salam Halo Tasya
              _buildGreetingHeader(userName),
              const SizedBox(height: 16),

              // Hero Card Ungu
              _buildHeroPurpleCard(totalDuration),
              const SizedBox(height: 16),

              // Dual Metric Cards: Total Durasi & Total Kalori
              _buildDualMetrics(totalDuration, totalCalories),
              const SizedBox(height: 18),

              // Streak 5 Hari Terus Aktif
              _buildStreakBanner(),
              const SizedBox(height: 22),

              // Riwayat Aktivitas & Lihat Semua
              _buildRecentActivitiesSection(),
              const SizedBox(height: 20),

              // Tombol Hijau + Tambah Aktivitas
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: widget.onNavigateToAdd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: const Color(0xFF161A29),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    textStyle: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                  label: const Text('+ Tambah Aktivitas'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingHeader(String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, $userName 👋',
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                color: Color(0xFF151828),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Semangat untuk latihan hari ini!',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroPurpleCard(int totalDuration) {
    const targetMins = 60;
    final progress = (totalDuration / targetMins).clamp(0.0, 1.0);
    final pct = (progress * 100).round();
    final remainingPct = 100 - pct;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B46EC), Color(0xFF765FF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5B46EC).withValues(alpha: 0.32),
            blurRadius: 26,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'AKTIVITAS FISIK & KALORI',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white70,
                      letterSpacing: 0.6,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Target Hari Ini',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  remainingPct > 0 ? '$remainingPct% lagi!' : 'Tercapai! 🎉',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF264005),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Circular Ring Progres 65% Target 45/60 mnt
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: 0.65,
                    strokeWidth: 14,
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    color: AppColors.secondary,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      '65%',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Target 45/60 mnt',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Inner Translucent Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: const [
                Icon(Icons.bolt_rounded, color: AppColors.secondary, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '250 kkal lagi untuk mencapai target harianmu!',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDualMetrics(int totalDuration, int totalCalories) {
    return Row(
      children: [
        // Total Durasi
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Durasi',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary)),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2F8FB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.timer_outlined,
                          color: Color(0xFF0284C7), size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                RichText(
                  text: const TextSpan(
                    text: '75 ',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF151828)),
                    children: [
                      TextSpan(
                          text: 'menit',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Wavy purple sparkline
                CustomPaint(
                  size: const Size(double.infinity, 24),
                  painter: _SparklinePainter(),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '~ +15% vs kemarin',
                    style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF264005)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Total Kalori
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Kalori',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary)),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEEDE9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.local_fire_department_rounded,
                          color: Color(0xFFEA580C), size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                RichText(
                  text: const TextSpan(
                    text: '520 ',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF151828)),
                    children: [
                      TextSpan(
                          text: 'kkal',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Mini 7 bar chart
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildMiniBar(0.4),
                    _buildMiniBar(0.6),
                    _buildMiniBar(0.5),
                    _buildMiniBar(0.7),
                    _buildMiniBar(1.0, isHighlight: true),
                    _buildMiniBar(0.75),
                    _buildMiniBar(0.85),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDEEE9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Optimal 🔥',
                    style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFEA580C)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniBar(double heightFraction, {bool isHighlight = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        height: 24 * heightFraction,
        decoration: BoxDecoration(
          color: isHighlight ? AppColors.secondary : const Color(0xFFE2E8F8),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

  Widget _buildStreakBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5FD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7E9F8)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.workspace_premium_rounded,
                color: Color(0xFF264005), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Streak 5 Hari Terus Aktif!',
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF151828)),
                ),
                SizedBox(height: 2),
                Text(
                  'Pertahankan konsistensi minggumu ✨',
                  style:
                      TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.primary, size: 22),
        ],
      ),
    );
  }

  Widget _buildRecentActivitiesSection() {
    final recent = _activities.take(3).toList();

    // Icon & warna per jenis olahraga
    IconData _iconFor(String name) {
      final n = name.toLowerCase();
      if (n.contains('lari')) return Icons.directions_run_rounded;
      if (n.contains('sepeda') || n.contains('bersepeda'))
        return Icons.directions_bike_rounded;
      if (n.contains('yoga') || n.contains('peregangan'))
        return Icons.self_improvement_rounded;
      if (n.contains('gym') || n.contains('beban') || n.contains('angkat'))
        return Icons.fitness_center_rounded;
      if (n.contains('renang')) return Icons.pool_rounded;
      if (n.contains('basket')) return Icons.sports_basketball_rounded;
      if (n.contains('badminton') || n.contains('bulu'))
        return Icons.sports_tennis_rounded;
      if (n.contains('futsal') || n.contains('sepak bola'))
        return Icons.sports_soccer_rounded;
      if (n.contains('hiit') || n.contains('kardio')) return Icons.bolt_rounded;
      if (n.contains('jalan')) return Icons.directions_walk_rounded;
      if (n.contains('senam') || n.contains('aerobik'))
        return Icons.accessibility_new_rounded;
      return Icons.sports_rounded;
    }

    Color _bgFor(String name) {
      final n = name.toLowerCase();
      if (n.contains('lari')) return AppColors.secondary;
      if (n.contains('sepeda') || n.contains('bersepeda'))
        return const Color(0xFFDFF6F9);
      if (n.contains('yoga') || n.contains('peregangan'))
        return const Color(0xFFFDECEE);
      if (n.contains('gym') || n.contains('beban'))
        return const Color(0xFFEDE9FE);
      if (n.contains('renang')) return const Color(0xFFE0F2FE);
      if (n.contains('basket')) return const Color(0xFFFFF7ED);
      if (n.contains('hiit') || n.contains('kardio'))
        return const Color(0xFFFEF9C3);
      return const Color(0xFFF1F4FB);
    }

    Color _iconColorFor(String name) {
      final n = name.toLowerCase();
      if (n.contains('lari')) return const Color(0xFF264005);
      if (n.contains('sepeda') || n.contains('bersepeda'))
        return const Color(0xFF0284C7);
      if (n.contains('yoga') || n.contains('peregangan'))
        return const Color(0xFFE11D48);
      if (n.contains('gym') || n.contains('beban'))
        return const Color(0xFF7C3AED);
      if (n.contains('renang')) return const Color(0xFF0369A1);
      if (n.contains('basket')) return const Color(0xFFEA580C);
      if (n.contains('hiit') || n.contains('kardio'))
        return const Color(0xFFCA8A04);
      return AppColors.primary;
    }

    String _formatDate(DateTime date) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final d = DateTime(date.year, date.month, date.day);
      final diff = today.difference(d).inDays;
      if (diff == 0)
        return 'Hari ini${date.hour > 0 ? ", ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} WIB" : ""}';
      if (diff == 1) return 'Kemarin';
      return '${date.day}/${date.month}/${date.year}';
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Riwayat Aktivitas',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF151828)),
            ),
            GestureDetector(
              onTap: widget.onNavigateToHistory,
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (recent.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: const Center(
              child: Text(
                'Belum ada aktivitas.\nTambah aktivitas pertamamu! 💪',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13, color: AppColors.textSecondary, height: 1.5),
              ),
            ),
          )
        else
          ...recent.map((activity) {
            final bg = _bgFor(activity.name);
            final iconColor = _iconColorFor(activity.name);
            final icon = _iconFor(activity.name);
            final cal = activity.caloriesBurned.round();
            final dateStr = _formatDate(activity.date);
            final slotStr = activity.slot != null ? ' • ${activity.slot}' : '';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.name,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF151828)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${activity.durationMinutes} menit • $cal kkal',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$dateStr$slotStr',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: Color(0xFFCBD5E1), size: 20),
                ],
              ),
            );
          }),
      ],
    );
  }

  void _confirmLogout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDECEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout_rounded,
                    color: AppColors.accentCoral, size: 28),
              ),
              const SizedBox(height: 14),
              const Text(
                'Keluar dari Sesi?',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF151828)),
              ),
              const SizedBox(height: 6),
              const Text(
                'Kamu perlu login kembali untuk melanjutkan.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.cardBorder),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Batal',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        widget.onLogout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentCoral,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Keluar',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showUserMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 18),
              const CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80',
                ),
              ),
              const SizedBox(height: 10),
              const Text('Tasya',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF151828))),
              const Text('Status: Aktif & Prima ✨',
                  style:
                      TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              ListTile(
                leading:
                    const Icon(Icons.history_rounded, color: AppColors.primary),
                title: const Text('Riwayat Lengkap Aktivitas',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onNavigateToHistory();
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.logout_rounded, color: Colors.redAccent),
                title: const Text('Keluar dari Sesi',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.redAccent)),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onLogout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF705BF6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.9,
          size.width * 0.45, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.5,
          size.width * 0.95, size.height * 0.15);

    canvas.drawPath(path, paint);

    final dotPaint = Paint()..color = const Color(0xFF705BF6);
    canvas.drawCircle(
        Offset(size.width * 0.95, size.height * 0.15), 3.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
