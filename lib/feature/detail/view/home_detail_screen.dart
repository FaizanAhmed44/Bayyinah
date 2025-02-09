import 'package:audioplayers/audioplayers.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/feature/model/quran_model.dart';
import 'package:quran_app/feature/model/quran_translation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:quran_app/const/colors.dart';
import 'package:quran_app/theme/theme_modal.dart';

class HomeDetailScreen extends StatefulWidget {
  final Surah surah;
  final SurahForTranslation surahTrans;

  const HomeDetailScreen({
    super.key,
    required this.surah,
    required this.surahTrans,
  });

  @override
  State<HomeDetailScreen> createState() => _HomeDetailScreenState();
}

class _HomeDetailScreenState extends State<HomeDetailScreen> {
  late AudioPlayer _audioPlayer;
  Map<int, bool> playingAyahs = {};
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _ayahKeys = {};

  int? lastSeenAyah;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadLastSeenAyah();

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        playingAyahs.clear();
      });
    });

    // Create unique keys for each Ayah
    for (int i = 0; i < widget.surah.ayahs.length; i++) {
      _ayahKeys[i] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadLastSeenAyah() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSurah = prefs.getString('lastSurah');
    final lastAyah = prefs.getInt('lastAyah');

    if (lastSurah == widget.surah.englishName && lastAyah != null) {
      setState(() {
        lastSeenAyah = lastAyah + 1;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToLastSeenAyah();
      });
    }
  }

  Future<void> _saveLastSeenAyah(int ayahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSurah', widget.surah.englishName);
    await prefs.setInt('lastSurahNum', widget.surah.number);
    await prefs.setInt('lastAyah', ayahNumber);
  }

  void _scrollToLastSeenAyah() {
    if (lastSeenAyah != null) {
      final key = _ayahKeys[lastSeenAyah! - 1];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  Future<void> toggleAudio(String audioUrl, int index) async {
    if (playingAyahs[index] == true) {
      await _audioPlayer.pause();
      setState(() {
        playingAyahs[index] = false;
      });
    } else {
      await _audioPlayer.stop();
      setState(() {
        playingAyahs.clear();
        playingAyahs[index] = true;
      });

      try {
        await _audioPlayer.play(UrlSource(audioUrl));
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to play audio: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Scaffold(
        backgroundColor:
            theamNotifier.isDark ? darkThemeBackgroundColor : whiteColor,
        appBar: AppBar(
          backgroundColor:
              theamNotifier.isDark ? darkThemeBackgroundColor : whiteColor,
          title: widget.surah.englishName.text.bold
              .color(theamNotifier.isDark ? whiteColor : purpleColor)
              .size(20)
              .make(),
          actions: [
            const Icon(
              FluentIcons.search_32_regular,
              color: lightTextColor,
            ).px16(),
          ],
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Image.asset(
                      "asset/images/ayah_start.png",
                      width: context.screenWidth,
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 28),
                          widget.surah.englishName.text.bold
                              .color(whiteColor)
                              .size(31)
                              .make(),
                          const SizedBox(height: 8),
                          widget.surah.englishNameTranslation.text
                              .color(whiteColor)
                              .size(19.5)
                              .make(),
                          const SizedBox(height: 12),
                          Container(
                            width: context.screenWidth * 0.6,
                            height: 0.7,
                            color: whiteColor,
                          ),
                          const SizedBox(height: 12),
                          "${widget.surah.revelationType} • ${widget.surah.ayahs.length} Verses"
                              .text
                              .color(whiteColor)
                              .size(19.5)
                              .make(),
                        ],
                      ),
                    ),
                  ],
                ),
              ).px16(),
              const SizedBox(height: 20),
              ListView.builder(
                itemCount: widget.surah.ayahs.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final ayah = widget.surah.ayahs[index];
                  final isLastSeen = lastSeenAyah == ayah.numberInSurah;
                  // final ayah = widget.surah.ayahs[index];
                  String text = ayah.text;
                  // Logic to split text only for the first ayah (index 0)
                  List<String> splitText = [];
                  if (index == 0) {
                    splitText =
                        splitTextByWords(text, 4); // Split after 5 words
                  }
                  return GestureDetector(
                    key: _ayahKeys[index],
                    onTap: () => _saveLastSeenAyah(ayah.numberInSurah),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      color: isLastSeen
                          ? purpleColor.withOpacity(0.2)
                          : Colors.transparent, // Highlight last seen
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17),
                                  color: theamNotifier.isDark
                                      ? darkdetailColor
                                      : darkdetailColor.withOpacity(.1),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: purpleColor,
                                      child: "${index + 1}"
                                          .text
                                          .color(theamNotifier.isDark
                                              ? darkThemeBackgroundColor
                                              : whiteColor)
                                          .makeCentered(),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 26,
                                            child: Image.asset(
                                                "asset/images/share.png")),
                                        const SizedBox(
                                          width: 13,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            toggleAudio(ayah.audio, index);
                                          },
                                          child: SizedBox(
                                              width: 18,
                                              child: playingAyahs[index] == true
                                                  ? const Icon(
                                                      Icons.pause,
                                                      color: purpleColor,
                                                    )
                                                  : Image.asset(
                                                      "asset/images/play.png")),
                                        ),
                                        const SizedBox(
                                          width: 13,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _saveLastSeenAyah(index);
                                            // ignore: avoid_print
                                            print("done");
                                          },
                                          child: SizedBox(
                                              width: 26,
                                              child: Image.asset(
                                                  "asset/images/bookmark.png")),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ).px12(),
                              const SizedBox(
                                height: 19,
                              ),

                              // For index 0, display split text
                              if (index == 0) ...[
                                Text(
                                  splitText[0],
                                  style: TextStyle(
                                    color: ayah.sajda
                                        ? Colors.red
                                        : theamNotifier.isDark
                                            ? whiteColor
                                            : darkdetailColor,
                                    fontSize: 26,
                                  ),
                                  textAlign: TextAlign.end,
                                ).px(20),
                                const SizedBox(height: 10),
                                Text(
                                  splitText[1],
                                  style: TextStyle(
                                    color: ayah.sajda
                                        ? Colors.red
                                        : theamNotifier.isDark
                                            ? whiteColor
                                            : darkdetailColor,
                                    fontSize: 26,
                                  ),
                                  textAlign: TextAlign.end,
                                ).px(20),
                              ] else ...[
                                // For other ayahs, display full text
                                Text(
                                  text,
                                  style: TextStyle(
                                    color: ayah.sajda
                                        ? Colors.red
                                        : theamNotifier.isDark
                                            ? whiteColor
                                            : darkdetailColor,
                                    fontSize: 26,
                                  ),
                                  textAlign: TextAlign.end,
                                ).px(20),
                              ],

                              const SizedBox(
                                height: 19,
                              ),
                              Text(
                                widget.surahTrans.ayahs[index].text,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: theamNotifier.isDark
                                      ? detailTranslationDarkColor
                                      : detailTranslationLightColor,
                                ),
                                textAlign: TextAlign.start,
                              ).px(20),
                              const SizedBox(
                                height: 19,
                              ),
                              const Divider(
                                thickness: 0.3,
                                color: lineColor,
                              ).px12(),
                            ],
                          ),
                          // Your Ayah content here
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      );
    });
  }
}

// Helper function to split text by word count
List<String> splitTextByWords(String text, int wordCount) {
  List<String> words = text.split(' '); // Split by spaces
  String firstPart = words.take(wordCount).join(' '); // First n words
  String secondPart = words.skip(wordCount).join(' '); // Remaining words
  return [firstPart, secondPart];
}
