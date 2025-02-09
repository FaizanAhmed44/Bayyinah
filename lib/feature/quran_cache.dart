import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quran_app/feature/model/quran_model.dart';
import 'package:quran_app/feature/model/quran_translation.dart';

class QuranCache {
  static final QuranCache _instance = QuranCache._internal();
  QuranData? cachedData;

  QuranCache._internal();

  static QuranCache get instance => _instance;

  Future<QuranData> getQuranData() async {
    if (cachedData != null) {
      return cachedData!;
    }
    cachedData = await loadQuranData();
    return cachedData!;
  }

  Future<QuranData> loadQuranData() async {
    try {
      final String response =
          await rootBundle.loadString('asset/json/quran_&_audio.json');

      final data = json.decode(response) as Map<String, dynamic>;
      return QuranData.fromJson(data);
    } catch (e) {
      // print('Error parsing JSON: $e');
      rethrow;
    }
  }
}

class QuranTranslationCache {
  static final QuranTranslationCache _instance =
      QuranTranslationCache._internal();
  QuranTranslationCacheData? _cachedData;

  QuranTranslationCache._internal();
  static QuranTranslationCache get instance => _instance;

  Future<QuranTranslationCacheData> getQuranDataTranslation() async {
    if (_cachedData != null) {
      return _cachedData!;
    }

    // Otherwise, load and cache data
    _cachedData = await _loadQuranDataTranslation();
    return _cachedData!;
  }

  /// Loads data from JSON file in assets
  Future<QuranTranslationCacheData> _loadQuranDataTranslation() async {
    try {
      final String response =
          await rootBundle.loadString('asset/json/quran_translation.json');

      final data = json.decode(response) as Map<String, dynamic>;

      return QuranTranslationCacheData.fromJson(data);
    } catch (e) {
      // Log and rethrow in case of an error
      // ignore: avoid_print
      print('Error loading JSON: $e');
      rethrow;
    }
  }
}
