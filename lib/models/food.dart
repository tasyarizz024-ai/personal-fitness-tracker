// lib/models/food.dart

/// Model yang merepresentasikan satu item rekomendasi makanan pasca-olahraga.
class FoodRecommendation {
  /// Nama makanan atau minuman yang direkomendasikan.
  final String name;

  /// Kategori rekomendasi berdasarkan kebutuhan nutrisi.
  /// Nilai yang disarankan:
  ///   - 'Tinggi Protein'    : untuk pemulihan otot (kalori >= 300 kkal)
  ///   - 'Tinggi Karbohidrat': untuk pemulihan energi (kalori >= 300 kkal)
  ///   - 'Hidrasi'           : untuk olahraga ringan (kalori < 300 kkal)
  final String category;

  /// Penjelasan singkat mengapa makanan ini direkomendasikan.
  final String description;

  /// Membuat instance [FoodRecommendation] dengan semua parameter wajib diisi.
  const FoodRecommendation({
    required this.name,
    required this.category,
    required this.description,
  });

  @override
  String toString() {
    return 'FoodRecommendation(name: $name, category: $category)';
  }
}

/// Kumpulan data rekomendasi makanan siap pakai yang dapat digunakan
/// oleh [FoodRecommendationScreen] tanpa perlu koneksi internet.
class FoodData {
  FoodData._(); // Mencegah instansiasi

  /// Rekomendasi untuk sesi olahraga berat (>= 300 kkal terbakar).
  static const List<FoodRecommendation> highCalorieBurned = [
    FoodRecommendation(
      name: 'Dada Ayam Rebus',
      category: 'Tinggi Protein',
      description:
          'Sumber protein lengkap rendah lemak, ideal untuk perbaikan serat '
          'otot setelah latihan intensitas tinggi.',
    ),
    FoodRecommendation(
      name: 'Telur Rebus (2-3 butir)',
      category: 'Tinggi Protein',
      description:
          'Mengandung protein berkualitas tinggi dan lemak sehat. Mudah '
          'dicerna dan cepat diserap tubuh pasca-olahraga.',
    ),
    FoodRecommendation(
      name: 'Nasi Merah + Tempe Goreng',
      category: 'Tinggi Karbohidrat',
      description:
          'Kombinasi karbohidrat kompleks dan protein nabati untuk mengisi '
          'kembali simpanan glikogen otot yang terkuras.',
    ),
    FoodRecommendation(
      name: 'Smoothie Pisang dan Susu',
      category: 'Tinggi Karbohidrat',
      description:
          'Karbohidrat cepat dari pisang membantu pemulihan energi, sementara '
          'susu menyumbang protein dan kalsium.',
    ),
    FoodRecommendation(
      name: 'Greek Yogurt + Granola',
      category: 'Tinggi Protein',
      description:
          'Yogurt tinggi protein dan probiotik, dipadukan granola sebagai '
          'sumber karbohidrat dan serat yang mengenyangkan.',
    ),
  ];

  /// Rekomendasi untuk sesi olahraga ringan (< 300 kkal terbakar).
  static const List<FoodRecommendation> lowCalorieBurned = [
    FoodRecommendation(
      name: 'Air Putih (500-750 ml)',
      category: 'Hidrasi',
      description:
          'Menggantikan cairan tubuh yang hilang melalui keringat. Minum '
          'secara bertahap, bukan sekaligus.',
    ),
    FoodRecommendation(
      name: 'Air Kelapa Muda',
      category: 'Hidrasi',
      description:
          'Mengandung elektrolit alami (kalium, natrium, magnesium) yang '
          'membantu pemulihan dan mencegah kram otot.',
    ),
    FoodRecommendation(
      name: 'Buah Semangka (2 potong)',
      category: 'Hidrasi',
      description:
          'Kandungan air ~92% membantu rehidrasi. Mengandung L-citrulline '
          'yang dapat mengurangi nyeri otot.',
    ),
    FoodRecommendation(
      name: 'Pisang (1 buah)',
      category: 'Hidrasi',
      description:
          'Sumber kalium dan karbohidrat sederhana yang cepat mengisi energi '
          'setelah olahraga ringan.',
    ),
    FoodRecommendation(
      name: 'Teh Jahe Hangat',
      category: 'Hidrasi',
      description:
          'Sifat anti-inflamasi jahe membantu meredakan nyeri otot ringan '
          'dan menghangatkan tubuh pasca-olahraga.',
    ),
  ];

  /// Mengembalikan daftar rekomendasi yang sesuai berdasarkan total kalori
  /// yang terbakar dalam satu sesi olahraga.
  ///
  /// [caloriesBurned] : Total kalori terbakar (dari [Activity.caloriesBurned]).
  static List<FoodRecommendation> getRecommendations(double caloriesBurned) {
    if (caloriesBurned >= 300) {
      return highCalorieBurned;
    }
    return lowCalorieBurned;
  }
}