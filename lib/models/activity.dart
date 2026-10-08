// lib/models/activity.dart

/// Daftar pengali kalori per menit berdasarkan jenis olahraga.
/// Nilai MET (Metabolic Equivalent of Task) yang disederhanakan,
/// diasumsikan untuk berat badan rata-rata 70 kg.
const Map<String, double> _caloriesPerMinute = {
  'Lari': 11.0,              // ~11 kkal/menit
  'Bersepeda': 8.0,          // ~8 kkal/menit
  'Jalan Santai': 4.0,       // ~4 kkal/menit
  'Berenang': 9.5,           // ~9.5 kkal/menit
  'Gym / Angkat Beban': 6.0, // ~6 kkal/menit
  'Yoga': 3.0,               // ~3 kkal/menit
  'Senam': 5.5,              // ~5.5 kkal/menit
  'HIIT': 12.5,              // ~12.5 kkal/menit
};

/// Pengali kalori default untuk jenis olahraga yang tidak terdaftar.
const double _defaultCaloriesPerMinute = 5.0;

/// Menghitung estimasi kalori yang terbakar berdasarkan jenis olahraga
/// dan durasi dalam menit.
double estimateCalories(String name, int durationMinutes) {
  final double multiplier =
      _caloriesPerMinute[name] ?? _defaultCaloriesPerMinute;
  return multiplier * durationMinutes;
}

/// Model yang merepresentasikan satu sesi aktivitas olahraga.
class Activity {
  final String id;
  final String name;
  final int durationMinutes;
  final double caloriesBurned;
  final DateTime date;
  final String? note;

  Activity({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.date,
    this.note,
    double? caloriesBurned,
  }) : caloriesBurned =
           caloriesBurned ?? estimateCalories(name, durationMinutes);

  static Map<String, double> get availableActivities => _caloriesPerMinute;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] as String,
      name: map['name'] as String,
      durationMinutes: map['durationMinutes'] as int,
      caloriesBurned: (map['caloriesBurned'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      note: map['note'] as String?,
    );
  }

  @override
  String toString() {
    return 'Activity(id: $id, name: $name, duration: ${durationMinutes}min, calories: ${caloriesBurned.toStringAsFixed(1)} kkal, date: $date, note: $note)';
  }

  factory Activity.fromJson(Map<String, dynamic> json) => Activity.fromMap(json);
  Map<String, dynamic> toJson() => toMap();
}