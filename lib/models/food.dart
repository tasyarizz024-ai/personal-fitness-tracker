// lib/models/food.dart

/// Model yang merepresentasikan satu item rekomendasi makanan pasca-olahraga.
class FoodRecommendation {
  final String id;
  final String name;
  final String category;
  final String description;
  final String protein;
  final String calories;
  final String timing;

  const FoodRecommendation({
    this.id = '',
    required this.name,
    required this.category,
    required this.description,
    this.protein = '',
    this.calories = '',
    this.timing = '30-45 mnt pasca-latihan',
  });

  @override
  String toString() {
    return 'FoodRecommendation(name: $name, category: $category)';
  }
}

/// Kumpulan data rekomendasi makanan siap pakai pasca-olahraga
class FoodData {
  FoodData._();

  /// Rekomendasi untuk sesi olahraga berat (>= 300 kkal terbakar).
  static const List<FoodRecommendation> highCalorieBurned = [
    FoodRecommendation(
      id: 'food_1',
      name: 'Dada Ayam Panggang & Nasi Merah',
      category: 'Tinggi Protein',
      protein: '32g Protein',
      calories: '420 kkal',
      timing: '30-45 mnt pasca-latihan',
      description:
          'Sumber protein lengkap rendah lemak dipadukan karbohidrat kompleks. Ideal untuk perbaikan serat otot dan mengisi ulang glikogen setelah latihan intensitas tinggi.',
    ),
    FoodRecommendation(
      id: 'food_2',
      name: 'Telur Rebus (2-3 butir) & Roti Gandum',
      category: 'Tinggi Protein',
      protein: '14g Protein',
      calories: '210 kkal',
      timing: '20-40 mnt pasca-latihan',
      description:
          'Mengandung protein berkualitas tinggi dan lemak sehat. Cepat diserap tubuh untuk merangsang sintesis protein otot tanpa lemak berlebih.',
    ),
    FoodRecommendation(
      id: 'food_3',
      name: 'Nasi Merah + Tempe & Tahu Panggang',
      category: 'Tinggi Karbohidrat',
      protein: '18g Protein',
      calories: '310 kkal',
      timing: '30-60 mnt pasca-latihan',
      description:
          'Kombinasi karbohidrat kompleks dan protein nabati untuk mengisi kembali simpanan glikogen otot serta menstabilkan metabolisme.',
    ),
    FoodRecommendation(
      id: 'food_4',
      name: 'Smoothie Pisang, Susu & Selai Kacang',
      category: 'Tinggi Karbohidrat',
      protein: '16g Protein',
      calories: '280 kkal',
      timing: '15-30 mnt pasca-latihan',
      description:
          'Karbohidrat cepat dari pisang membantu pemulihan energi segera, sementara susu menyumbang protein kasein dan kalsium.',
    ),
    FoodRecommendation(
      id: 'food_5',
      name: 'Greek Yogurt + Granola & Berries',
      category: 'Tinggi Protein',
      protein: '20g Protein',
      calories: '260 kkal',
      timing: '30 mnt pasca-latihan',
      description:
          'Yogurt tinggi protein dan probiotik dipadukan granola renyah sebagai sumber karbohidrat dan serat yang mengenyangkan.',
    ),
  ];

  /// Rekomendasi untuk sesi olahraga ringan (< 300 kkal terbakar).
  static const List<FoodRecommendation> lowCalorieBurned = [
    FoodRecommendation(
      id: 'food_6',
      name: 'Air Kelapa Muda Segar',
      category: 'Hidrasi Elektrolit',
      protein: '1g Protein',
      calories: '45 kkal',
      timing: 'Segera pasca-latihan',
      description:
          'Mengandung elektrolit alami (kalium, natrium, magnesium) yang cepat menggantikan cairan tubuh dan mencegah kram otot.',
    ),
    FoodRecommendation(
      id: 'food_7',
      name: 'Buah Semangka Segar (2 Potong Tebal)',
      category: 'Hidrasi & Anti-Kram',
      protein: '2g Protein',
      calories: '60 kkal',
      timing: '10-20 mnt pasca-latihan',
      description:
          'Kandungan air ~92% membantu rehidrasi optimal. Mengandung L-citrulline alami yang efektif mengurangi nyeri otot.',
    ),
    FoodRecommendation(
      id: 'food_8',
      name: 'Pisang Cavendish & 10 Butir Almond',
      category: 'Camilan Sehat',
      protein: '4g Protein',
      calories: '150 kkal',
      timing: '15-30 mnt pasca-latihan',
      description:
          'Sumber kalium untuk menstabilkan denyut jantung serta asam lemak sehat dari almond untuk meredakan inflamasi ringan.',
    ),
    FoodRecommendation(
      id: 'food_9',
      name: 'Air Putih Rehidrasi Bertahap (750 ml)',
      category: 'Hidrasi Primer',
      protein: '0g Protein',
      calories: '0 kkal',
      timing: 'Sepanjang pemulihan',
      description:
          'Cairan vital untuk memulihkan volume plasma darah dan sirkulasi oksigen ke seluruh sel tubuh. Minum bertahap bukan sekaligus.',
    ),
    FoodRecommendation(
      id: 'food_10',
      name: 'Teh Jahe Hangat & Madu Alami',
      category: 'Hidrasi Anti-Inflamasi',
      protein: '0g Protein',
      calories: '35 kkal',
      timing: '20-40 mnt pasca-latihan',
      description:
          'Sifat anti-inflamasi alami dari gingerol membantu menghangatkan tubuh, merelaksasi otot yang tegang, dan mempercepat pemulihan.',
    ),
  ];

  static List<FoodRecommendation> getRecommendations(double caloriesBurned) {
    if (caloriesBurned >= 300) {
      return highCalorieBurned;
    }
    return lowCalorieBurned;
  }
}
