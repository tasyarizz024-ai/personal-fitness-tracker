// lib/screens/add_activity_screen.dart
import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../services/storage_service.dart';
import '../main.dart';
import 'food_recommendation_screen.dart';

class AddActivityScreen extends StatefulWidget {
  final VoidCallback? onSaved;
  const AddActivityScreen({Key? key, this.onSaved}) : super(key: key);

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final StorageService _storageService = StorageService();

  final List<Map<String, dynamic>> _sportsList = [
    {
      'id': 'lari',
      'name': 'Lari',
      'rate': 8.0,
      'rateLabel': '~8 kkal/m',
      'icon': Icons.directions_run_rounded,
    },
    {
      'id': 'bersepeda',
      'name': 'Bersepeda',
      'rate': 6.5,
      'rateLabel': '~6.5 kkal/m',
      'icon': Icons.directions_bike_rounded,
    },
    {
      'id': 'renang',
      'name': 'Renang',
      'rate': 9.0,
      'rateLabel': '~9 kkal/m',
      'icon': Icons.pool_rounded,
    },
    {
      'id': 'yoga',
      'name': 'Yoga',
      'rate': 4.0,
      'rateLabel': '~4 kkal/m',
      'icon': Icons.self_improvement_rounded,
    },
    {
      'id': 'beban',
      'name': 'Beban',
      'rate': 5.5,
      'rateLabel': '~5.5 kkal/m',
      'icon': Icons.fitness_center_rounded,
    },
    {
      'id': 'jalan',
      'name': 'Jalan Kaki',
      'rate': 3.8,
      'rateLabel': '~3.8 kkal/m',
      'icon': Icons.directions_walk_rounded,
    },
  ];

  late Map<String, dynamic> _selectedSport;
  int _durationMinutes = 45;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedSport = _sportsList[0]; // Default: Lari
  }

  void _adjustDuration(int delta) {
    setState(() {
      _durationMinutes = (_durationMinutes + delta).clamp(5, 240);
    });
  }

  void _setQuickDuration(int mins) {
    setState(() {
      _durationMinutes = mins;
    });
  }

  Future<void> _saveActivity() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final cal = (_selectedSport['rate'] as double) * _durationMinutes;
    final now = DateTime.now();

    final newAct = Activity(
      id: 'act_${now.millisecondsSinceEpoch}',
      name: _selectedSport['name'] as String,
      focus: 'Sesi Latihan ${_selectedSport['name']}',
      durationMinutes: _durationMinutes,
      caloriesBurned: cal,
      date: now,
      slot: 'Sore',
      note: 'Latihan intensitas optimal ${_selectedSport['name']}',
    );

    await _storageService.saveActivity(newAct);

    if (!mounted) return;
    setState(() => _isSaving = false);

    // Buka Sesi Latihan Aktif / Food Recommendation
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => FoodRecommendationScreen(
          caloriesBurned: cal,
          durationMinutes: _durationMinutes,
          sportName: _selectedSport['name'] as String,
          onBackToHome: () {
            Navigator.of(ctx).pop(); // Tutup layar rekomendasi makanan
            if (widget.onSaved != null) {
              widget.onSaved!(); // Pindah ke tab Beranda
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cal = ((_selectedSport['rate'] as double) * _durationMinutes).round();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leadingWidth: 70,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Center(
              child: InkWell(
                onTap: () {
                  if (widget.onSaved != null) {
                    widget.onSaved!();
                  } else if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFECEFF8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: Color(0xFF1E2434), size: 20),
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Icon(Icons.all_inclusive_rounded,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('FITTRACK',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E2434))),
                  Text('Tambah',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80'),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Bar
            const Text(
              'Tambah Aktivitas',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF151828)),
            ),
            const SizedBox(height: 3),
            const Text(
              'Catat latihan yang baru kamu selesaikan',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),

            // Section: Pilih Jenis Olahraga
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Pilih Jenis Olahraga',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF151828))),
                Text('6 Pilihan',
                    style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 3),
            const Text('Pilih kategori latihan untuk estimasi akurat',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 14),

            // Grid 6 Pilihan
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _sportsList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.88,
              ),
              itemBuilder: (ctx, idx) {
                final sport = _sportsList[idx];
                final isSelected = sport['name'] == _selectedSport['name'];

                return GestureDetector(
                  onTap: () => setState(() => _selectedSport = sport),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFFF1EFFE) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.4)
                            : AppColors.cardBorder,
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (isSelected)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check_rounded,
                                  color: Color(0xFF264005), size: 12),
                            ),
                          ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : const Color(0xFFF3F5FA),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                sport['icon'] as IconData,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF1E2434),
                                size: 22,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              sport['name'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isSelected
                                    ? AppColors.primary
                                    : const Color(0xFF151828),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              sport['rateLabel'] as String,
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),

            // Card: Durasi Latihan
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 16,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1EFFE),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.timer_outlined,
                                color: AppColors.primary, size: 18),
                          ),
                          const SizedBox(width: 10),
                          const Text('Durasi Latihan',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF151828))),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Target: 30–60m',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF264005))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Stepper Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStepperBtn('−', () => _adjustDuration(-5)),
                      Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: '$_durationMinutes ',
                              style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF151828)),
                              children: const [
                                TextSpan(
                                    text: 'menit',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(Icons.circle,
                                  color: Color(0xFF65A30D), size: 7),
                              SizedBox(width: 6),
                              Text('Tempo Latihan Optimal',
                                  style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                      _buildStepperBtn('+', () => _adjustDuration(5)),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Quick Pills (15, 30, 45, 60 mnt)
                  Row(
                    children: [15, 30, 45, 60].map((mins) {
                      final isActive = _durationMinutes == mins;
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () => _setQuickDuration(mins),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.primary
                                    : const Color(0xFFF1F4FB),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  '$mins mnt',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                    color: isActive
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Card: Estimasi Kalori Terbakar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 16,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEEDE9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                                Icons.local_fire_department_rounded,
                                color: Color(0xFFEA580C),
                                size: 18),
                          ),
                          const SizedBox(width: 10),
                          const Text('Estimasi Kalori Terbakar',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF151828))),
                        ],
                      ),
                      const Icon(Icons.circle,
                          color: Color(0xFF65A30D), size: 9),
                    ],
                  ),
                  const SizedBox(height: 14),
                  RichText(
                    text: TextSpan(
                      text: '$cal ',
                      style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary),
                      children: const [
                        TextSpan(
                            text: 'kkal',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Dihitung otomatis berdasarkan intensitas ${_selectedSport['name']} selama $_durationMinutes menit.',
                    style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                        height: 1.45),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildCalTag(
                          Icons.bolt_rounded, 'Intensitas: Sedang-Tinggi'),
                      _buildCalTag(Icons.favorite_rounded,
                          'Detak Jantung est.: 135 bpm'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Simpan Aktivitas & Batal
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _saveActivity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  textStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w800),
                ),
                icon: const Icon(Icons.save_rounded, size: 20),
                label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Aktivitas'),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  if (widget.onSaved != null) {
                    widget.onSaved!();
                  } else if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Batal',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF151828))),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperBtn(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFEDF0FA),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(label,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF151828))),
        ),
      ),
    );
  }

  Widget _buildCalTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EFFE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 14),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
        ],
      ),
    );
  }
}
