// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:quran_app/feature/model/quran_model.dart';

// class QuranApp extends StatefulWidget {
//   @override
//   _QuranAppState createState() => _QuranAppState();
// }

// class _QuranAppState extends State<QuranApp> {
//   late Future<QuranData> futureQuranData;

//   Future<QuranData> loadQuranData() async {
//     final String response =
//         await rootBundle.loadString('asset/json/quran_&_audio.json');
//     final data = json.decode(response); // Parse JSON
//     return QuranData.fromJson(data); // Convert to Dart Object
//   }

//   @override
//   void initState() {
//     super.initState();
//     futureQuranData = loadQuranData(); // Load JSON
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Quran App")),
//       body: FutureBuilder<QuranData>(
//         future: futureQuranData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             print(snapshot.error);
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (snapshot.hasData) {
//             final surahs = snapshot.data!.data.surahs;

//             return ListView.builder(
//               itemCount: surahs.length,
//               itemBuilder: (context, index) {
//                 final surah = surahs[index];
//                 return ListTile(
//                   title: Text(surah.englishName),
//                   subtitle: Text(surah.name),
//                   trailing: Text(surah.revelationType),
//                   onTap: () {
//                     // Navigate to surah details
//                   },
//                 );
//               },
//             );
//           }
//           return Center(child: Text("No Data"));
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:quran_app/feature/model/quran_model.dart';
import 'package:quran_app/feature/quran_cache.dart';

class QuranPage extends StatefulWidget {
  @override
  const QuranPage({
    super.key,
  });
  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  late Future<QuranData> _quranData;

  @override
  void initState() {
    super.initState();
    _quranData = QuranCache.instance.getQuranData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holy Quran'),
      ),
      body: FutureBuilder<QuranData>(
        future: _quranData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final surahs = snapshot.data!.surahs;
            return ListView.builder(
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                final surah = surahs[index];
                return ListTile(
                  title: Text('${surah.name} (${surah.englishName})'),
                  subtitle: Text(surah.englishNameTranslation),
                  onTap: () {
                    // Navigate to surah details or display ayahs
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
