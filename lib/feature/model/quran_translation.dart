class QuranTranslationCacheData {
  final int code;
  final String status;
  final List<SurahForTranslation> surahs;

  QuranTranslationCacheData({
    required this.code,
    required this.status,
    required this.surahs,
  });

  factory QuranTranslationCacheData.fromJson(Map<String, dynamic> json) {
    return QuranTranslationCacheData(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      surahs: (json['data']['surahs'] as List)
          .map((e) => SurahForTranslation.fromJson(e))
          .toList(),
    );
  }
}

class SurahForTranslation {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final List<Ayah> ayahs;

  SurahForTranslation({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
  });

  factory SurahForTranslation.fromJson(Map<String, dynamic> json) {
    return SurahForTranslation(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      ayahs: (json['ayahs'] as List).map((e) => Ayah.fromJson(e)).toList(),
    );
  }
}

class Ayah {
  final int number;
  final String text;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;

  Ayah({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['number'],
      text: json['text'],
      numberInSurah: json['numberInSurah'],
      juz: json['juz'],
      manzil: json['manzil'],
      page: json['page'],
      ruku: json['ruku'],
      hizbQuarter: json['hizbQuarter'],
      // sajda: json['sajda'],
      sajda: json['sajda'] is bool ? json['sajda'] : false,
    );
  }
}
