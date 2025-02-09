class QuranData {
  final int code;
  final String status;
  final List<Surah> surahs;

  QuranData({
    required this.code,
    required this.status,
    required this.surahs,
  });

  factory QuranData.fromJson(Map<String, dynamic> json) {
    return QuranData(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      surahs: (json['data']['surahs'] as List)
          .map((e) => Surah.fromJson(e))
          .toList(),
    );
  }
}

class Surah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final List<Ayah> ayahs;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      englishNameTranslation: json['englishNameTranslation'] ?? '',
      revelationType: json['revelationType'] ?? '',
      ayahs: (json['ayahs'] as List).map((e) => Ayah.fromJson(e)).toList(),
    );
  }
}

class Ayah {
  final int number;
  final String text;
  final String audio;
  final List<String> audioSecondary;
  final bool sajda;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;

  Ayah({
    required this.number,
    required this.text,
    required this.audio,
    required this.audioSecondary,
    required this.sajda,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['number'] ?? 0,
      text: json['text'] ?? '',
      audio: json['audio'] ?? '',
      audioSecondary: List<String>.from(json['audioSecondary'] ?? []),
      numberInSurah: json['numberInSurah'],
      juz: json['juz'],
      manzil: json['manzil'],
      page: json['page'],
      ruku: json['ruku'],
      hizbQuarter: json['hizbQuarter'],
      sajda: json['sajda'] is bool
          ? json['sajda']
          : false, // Handle the type mismatch
    );
  }
}
