// lib/screens/food_recommendation_screen.dart
import 'package:flutter/material.dart';
import '../main.dart';
import '../services/storage_service.dart';

class FoodRecommendationScreen extends StatefulWidget {
  final double caloriesBurned;
  final int durationMinutes;
  final String sportName;
  final VoidCallback? onBackToHome;

  const FoodRecommendationScreen({
    Key? key,
    this.caloriesBurned = 360,
    this.durationMinutes = 45,
    this.sportName = 'Lari',
    this.onBackToHome,
  }) : super(key: key);

  @override
  State<FoodRecommendationScreen> createState() =>
      _FoodRecommendationScreenState();
}

class _FoodRecommendationScreenState extends State<FoodRecommendationScreen> {
  String _activeTab = 'heavy'; // 'heavy' atau 'snack'
  final StorageService _storageService = StorageService();

  final List<Map<String, dynamic>> _foodList = [
    {
      'id': 'f1',
      'name': 'Dada Ayam Panggang & Nasi Merah',
      'category': 'MAKANAN UTAMA • Pemulihan Otot',
      'tab': 'heavy',
      'protein': '32g Protein',
      'calories': '420 kkal',
      'desc':
          'Sumber protein tanpa lemak dipadukan karbohidrat kompleks untuk regenerasi otot.',
      'image':
          'https://images.unsplash.com/photo-1543339308-43e59d6b73a6?auto=format&fit=crop&w=300&q=80',
      'isFav': true,
    },
    {
      'id': 'f2',
      'name': 'Telur Rebus (2 butir) & Roti Gandum',
      'category': 'CAMILAN SEHAT • Cepat Disajikan',
      'tab': 'heavy',
      'protein': '14g Protein',
      'calories': '210 kkal',
      'desc':
          'Praktis, kaya asam amino esensial dan serat untuk menjaga rasa kenyang dan pemulihan cepat.',
      'image':
          'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=300&q=80',
      'isFav': false,
    },
    {
      'id': 'f3',
      'name': 'Pisang Cavendish & Selai Kacang',
      'category': 'ENERGI CEPAT • Anti Kram',
      'tab': 'snack',
      'protein': '6g Protein',
      'calories': '190 kkal',
      'desc':
          'Mengembalikan glikogen dan mencegah kram otot berkat kandungan kalium dan magnesium.',
      'image':
          'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?auto=format&fit=crop&w=300&q=80',
      'isFav': true,
    },
    {
      'id': 'f4',
      'name': 'Air Kelapa & Greek Yogurt Smoothie',
      'category': 'HIDRASI ELEKTROLIT • Segar Alami',
      'tab': 'snack',
      'protein': '15g Protein',
      'calories': '180 kkal',
      'desc':
          'Elektrolit alami untuk rehidrasi sel tubuh seketika dan probiotik untuk imunitas prima.',
      'image':
          'https://images.unsplash.com/photo-1553530666-ba11a7da3888?auto=format&fit=crop&w=300&q=80',
      'isFav': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _foodList.where((f) => f['tab'] == _activeTab).toList();
    final calBurned = widget.caloriesBurned.round();

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
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else if (widget.onBackToHome != null) {
                    widget.onBackToHome!();
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
              const Text(
                'Sesi Latihan Aktif',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E2434)),
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
            // Banner Selamat
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE4E2FD), Color(0xFFF4FBF0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.campaign_rounded,
                              color: AppColors.primary, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'SELESAI BEROLAHRAGA',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                letterSpacing: 0.8),
                          ),
                        ],
                      ),
                      const Text('✦',
                          style: TextStyle(
                              fontSize: 22, color: Color(0xFF8B75F8))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Kerja Bagus, Tasya! 👏',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF151828)),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '🔥 $calBurned kkal terbakar dalam ${widget.durationMinutes} mnt!',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF264005)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Section Rekomendasi Menu
            Row(
              children: const [
                Icon(Icons.circle, color: AppColors.primary, size: 7),
                SizedBox(width: 8),
                Text(
                  'Rekomendasi Menu: Pemulihan Optimal',
                  style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF151828)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Kombinasi tinggi protein untuk regenerasi otot dan karbohidrat kompleks untuk mengisi ulang energi tubuh setelah sesi ${widget.sportName.toLowerCase()}.',
              style: const TextStyle(
                  fontSize: 12.5, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 16),

            // Tabs: Pemulihan Berat / Hidrasi & Camilan
            Row(
              children: [
                _buildTabPill('Pemulihan Berat', 'heavy'),
                const SizedBox(width: 10),
                _buildTabPill('Hidrasi & Camilan', 'snack'),
              ],
            ),
            const SizedBox(height: 16),

            // Food Cards Deck
            ...filtered.map((food) {
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    // Foto Makanan
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            food['image'] as String,
                            width: 86,
                            height: 86,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              width: 86,
                              height: 86,
                              color: const Color(0xFFEEF2FA),
                              child: const Icon(Icons.restaurant_rounded,
                                  color: AppColors.primary),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 6,
                          left: 6,
                          child: InkWell(
                            onTap: () async {
                              final newFav = !(food['isFav'] as bool);
                              setState(() {
                                food['isFav'] = newFav;
                              });
                              if (newFav) {
                                // Save this food item to storage
                                final now = DateTime.now();
                                final savedItem =
                                    Map<String, dynamic>.from(food)
                                      ..['savedAt'] =
                                          '${now.day}/${now.month}/${now.year}';
                                await _storageService.saveFoodMenu(savedItem);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('${food['name']} disimpan! 🔖'),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.85),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                (food['isFav'] as bool)
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: (food['isFav'] as bool)
                                    ? Colors.redAccent
                                    : const Color(0xFF64748B),
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Info Makanan
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food['category'] as String,
                            style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            food['name'] as String,
                            style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF151828)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  food['protein'] as String,
                                  style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF264005)),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDFF6F9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  food['calories'] as String,
                                  style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0284C7)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            food['desc'] as String,
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            // Tombol Kembali ke Beranda
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (widget.onBackToHome != null) {
                    widget.onBackToHome!();
                  } else if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  textStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w800),
                ),
                icon: const Icon(Icons.home_rounded, size: 20),
                label: const Text('Kembali ke Beranda'),
              ),
            ),
            const SizedBox(height: 12),

            Center(
              child: TextButton.icon(
                onPressed: () async {
                  final now = DateTime.now();
                  final dateStr = '${now.day}/${now.month}/${now.year}';

                  setState(() {
                    for (var f in _foodList) {
                      f['isFav'] = true;
                    }
                  });

                  // Save ALL food items to storage
                  for (var f in _foodList) {
                    final savedItem = Map<String, dynamic>.from(f)
                      ..['savedAt'] = dateStr;
                    await _storageService.saveFoodMenu(savedItem);
                  }

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            const Text('Semua menu pemulihan disimpan! 🔖'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.bookmark_rounded,
                    color: AppColors.primary, size: 16),
                label: const Text(
                  'Simpan menu ke daftar favorit',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF151828)),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPill(String title, String type) {
    final isActive = _activeTab == type;
    return InkWell(
      onTap: () => setState(() => _activeTab = type),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : const Color(0xFFF1F4FB),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
