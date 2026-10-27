// lib/screens/history_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../services/storage_service.dart';
import '../main.dart';
import 'food_recommendation_screen.dart';

class HistoryScreen extends StatefulWidget {
  final ValueListenable<int> refreshNotifier;

  const HistoryScreen({Key? key, required this.refreshNotifier})
      : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final StorageService _storageService = StorageService();
  List<Activity> _activities = [];
  String _searchQuery = '';
  String _selectedFilterSport = 'Semua';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.refreshNotifier.addListener(_loadActivities);
    _loadActivities();
  }

  @override
  void dispose() {
    widget.refreshNotifier.removeListener(_loadActivities);
    super.dispose();
  }

  Future<void> _loadActivities() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final activities = await _storageService.getActivities();
    if (!mounted) return;
    setState(() {
      _activities = activities;
      _isLoading = false;
    });
  }

  Future<void> _deleteActivity(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Aktivitas',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
            'Apakah kamu yakin ingin menghapus catatan latihan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _storageService.deleteActivity(id);
      await _loadActivities();
    }
  }

  IconData _getSportIcon(String sportName) {
    switch (sportName) {
      case 'Gym / Angkat Beban':
        return Icons.fitness_center_rounded;
      case 'Lari':
        return Icons.directions_run_rounded;
      case 'Sepak Bola / Futsal':
        return Icons.sports_soccer_rounded;
      case 'Badminton':
        return Icons.sports_tennis_rounded;
      case 'Bersepeda':
        return Icons.directions_bike_rounded;
      case 'Renang':
        return Icons.pool_rounded;
      case 'Basket':
        return Icons.sports_basketball_rounded;
      case 'HIIT / Kardio Intensif':
        return Icons.flash_on_rounded;
      case 'Yoga & Peregangan':
        return Icons.self_improvement_rounded;
      default:
        return Icons.sports_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body:
            Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final sportsOptions = [
      'Semua',
      ...{..._activities.map((a) => a.name)}
    ];

    final filtered = _activities.where((a) {
      final q = _searchQuery.toLowerCase();
      final matchQuery = a.name.toLowerCase().contains(q) ||
          (a.focus ?? '').toLowerCase().contains(q) ||
          (a.note ?? '').toLowerCase().contains(q);
      final matchSport =
          _selectedFilterSport == 'Semua' || a.name == _selectedFilterSport;
      return matchQuery && matchSport;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Aktivitas'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Total ${_activities.length} Sesi',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.cardSurface,
        onRefresh: _loadActivities,
        child: Column(
          children: [
            // Search & Filter Toolbar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: AppColors.cardSurface,
              child: Column(
                children: [
                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText:
                          'Cari olahraga, spesifik latihan, atau catatan...',
                      hintStyle: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppColors.textSecondary, size: 20),
                      filled: true,
                      fillColor: AppColors.cardAlt,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.cardBorder)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.cardBorder)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.primary)),
                    ),
                  ),
                  if (sportsOptions.length > 2) ...[
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: sportsOptions.map((sport) {
                          final isSel = _selectedFilterSport == sport;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(sport,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: isSel
                                          ? const Color(0xFF04140E)
                                          : AppColors.textSecondary)),
                              selected: isSel,
                              selectedColor: AppColors.primary,
                              backgroundColor: AppColors.cardAlt,
                              onSelected: (_) =>
                                  setState(() => _selectedFilterSport = sport),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Content List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 54,
                              color:
                                  AppColors.textMuted.withValues(alpha: 0.5)),
                          const SizedBox(height: 14),
                          Text(
                            _activities.isEmpty
                                ? 'Belum Ada Aktivitas'
                                : 'Tidak Ada Aktivitas',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _activities.isEmpty
                                ? 'Aktivitas yang kamu simpan akan muncul di sini.'
                                : 'Belum ada data yang sesuai dengan pencarianmu.',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final act = filtered[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardSurface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.cardAlt,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: AppColors.cardBorder),
                                    ),
                                    child: Icon(_getSportIcon(act.name),
                                        color: AppColors.primary, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          act.name,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.textPrimary),
                                        ),
                                        if (act.focus != null &&
                                            act.focus!.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            act.focus!,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.secondary,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.accentAmber
                                          .withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${act.caloriesBurned.round()} kkal',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.accentAmber),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.timer_outlined,
                                      size: 14, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Text('${act.durationMinutes} menit',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary)),
                                  const SizedBox(width: 14),
                                  const Icon(Icons.calendar_today_outlined,
                                      size: 14, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Text(
                                      '${act.date.day}/${act.date.month}/${act.date.year}',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary)),
                                  if (act.slot != null) ...[
                                    const SizedBox(width: 14),
                                    const Icon(Icons.schedule_rounded,
                                        size: 14, color: AppColors.textMuted),
                                    const SizedBox(width: 4),
                                    Text(act.slot!,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textMuted)),
                                  ],
                                ],
                              ),
                              if (act.note != null && act.note!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  '"${act.note}"',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.textMuted),
                                ),
                              ],
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FoodRecommendationScreen(
                                            caloriesBurned: act.caloriesBurned,
                                            durationMinutes:
                                                act.durationMinutes,
                                            sportName: act.name,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.restaurant_rounded,
                                        size: 14),
                                    label: const Text('Saran Nutrisi',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700)),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  IconButton(
                                    icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: AppColors.error,
                                        size: 18),
                                    onPressed: () => _deleteActivity(act.id),
                                    tooltip: 'Hapus Sesi Ini',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
