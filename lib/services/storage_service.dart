import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity.dart';

class StorageService {
  static const String _activitiesKey = 'activities_data';

  Future<void> saveActivities(List<Activity> activities) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList = activities.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList(_activitiesKey, jsonList);
  }

  Future<List<Activity>> getActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_activitiesKey);
    if (jsonList == null) return [];

    return jsonList.map((jsonStr) => Activity.fromJson(jsonDecode(jsonStr))).toList();
  }

  Future<void> addActivity(Activity activity) async {
    final activities = await getActivities();
    activities.insert(0, activity); // Add to the top
    await saveActivities(activities);
  }

  Future<void> updateActivity(Activity activity) async {
    final activities = await getActivities();
    final index = activities.indexWhere((a) => a.id == activity.id);
    if (index != -1) {
      activities[index] = activity;
      await saveActivities(activities);
    }
  }

  Future<void> deleteActivity(String id) async {
    final activities = await getActivities();
    activities.removeWhere((a) => a.id == id);
    await saveActivities(activities);
  }
}
