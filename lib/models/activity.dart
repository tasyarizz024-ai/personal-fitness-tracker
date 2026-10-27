// lib/models/activity.dart

/// Daftar pengali kalori per menit berdasarkan jenis olahraga (Nilai MET standar 70 kg).
const Map<String, double> _caloriesPerMinute = {
  'Gym / Angkat Beban': 6.0,
  'Lari': 11.0,
  'Sepak Bola / Futsal': 9.0,
  'Badminton': 7.0,
  'Bersepeda': 8.2,
  'Renang': 9.5,
  'Basket': 8.0,
  'HIIT / Kardio Intensif': 12.5,
  'Yoga & Peregangan': 3.5,
  'Jalan Santai / Kaki': 4.0,
  'Senam / Aerobik': 5.5,
  'Lainnya / Sparring': 6.5,
};

const double _defaultCaloriesPerMinute = 5.0;

double estimateCalories(String name, int durationMinutes) {
  final double multiplier =
      _caloriesPerMinute[name] ?? _defaultCaloriesPerMinute;
  return multiplier * durationMinutes;
}

/// Model sesi latihan kebugaran dengan detail fokus latihan spesifik
class Activity {
  final String id;
  final String name;
  final String?
      focus; // Detail spesifik latihan (misal: Chest Day, Lari Cepat Sprint, Tanding 5v5)
  final int durationMinutes;
  final double caloriesBurned;
  final DateTime date;
  final String? slot; // Pagi / Siang / Sore / Malam
  final String? note;

  Activity({
    required this.id,
    required this.name,
    this.focus,
    required this.durationMinutes,
    required this.date,
    this.slot,
    this.note,
    double? caloriesBurned,
  }) : caloriesBurned =
            caloriesBurned ?? estimateCalories(name, durationMinutes);

  static Map<String, double> get availableActivities => _caloriesPerMinute;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'focus': focus,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'date': date.toIso8601String(),
      'slot': slot,
      'note': note,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] as String,
      name: map['name'] as String,
      focus: map['focus'] as String?,
      durationMinutes: map['durationMinutes'] as int,
      caloriesBurned: (map['caloriesBurned'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      slot: map['slot'] as String?,
      note: map['note'] as String?,
    );
  }

  factory Activity.fromJson(Map<String, dynamic> json) =>
      Activity.fromMap(json);
  Map<String, dynamic> toJson() => toMap();
}
