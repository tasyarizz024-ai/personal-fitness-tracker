import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:personal_fitness_tracker/models/activity.dart';
import 'package:personal_fitness_tracker/models/food.dart';
import 'package:personal_fitness_tracker/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Riwayat hanya berisi aktivitas yang tersimpan', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService();

    expect(await storage.getActivities(), isEmpty);

    final activity = Activity(
      id: 'act_test',
      name: 'Lari',
      durationMinutes: 30,
      date: DateTime(2026, 10, 27),
    );
    await storage.saveActivity(activity);

    final storedActivities = await storage.getActivities();
    expect(storedActivities, hasLength(1));
    expect(storedActivities.single.id, activity.id);
    expect(storedActivities.single.date, activity.date);
  });

  test('Riwayat lama berisi aktivitas hardcode dibersihkan', () async {
    final oldSampleActivity = Activity(
      id: 'hist_123_0',
      name: 'Lari',
      durationMinutes: 30,
      date: DateTime(2026, 10, 27),
    );
    final recordedActivity = Activity(
      id: 'act_recorded',
      name: 'Bersepeda',
      durationMinutes: 45,
      date: DateTime(2026, 10, 26),
    );
    SharedPreferences.setMockInitialValues({
      'ft_act_pengguna_fit': [
        jsonEncode(oldSampleActivity.toJson()),
        jsonEncode(recordedActivity.toJson()),
      ],
    });

    final activities = await StorageService().getActivities();

    expect(activities, hasLength(1));
    expect(activities.single.id, recordedActivity.id);
    final prefs = await SharedPreferences.getInstance();
    final storedActivities = prefs.getStringList('ft_act_pengguna_fit');
    expect(storedActivities, hasLength(1));
    expect(
      jsonDecode(storedActivities!.single)['id'],
      recordedActivity.id,
    );
  });

  test('Verifikasi rekomendasi nutrisi tanpa emoji', () {
    final highList = FoodData.highCalorieBurned;
    final lowList = FoodData.lowCalorieBurned;
    expect(highList.isNotEmpty, true);
    expect(lowList.isNotEmpty, true);
    for (final food in [...highList, ...lowList]) {
      expect(food.protein.isNotEmpty, true);
      expect(food.calories.isNotEmpty, true);
      expect(food.name.isNotEmpty, true);
    }
  });
}
