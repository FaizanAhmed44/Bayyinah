import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/const/colors.dart';
import 'package:quran_app/feature/detail/view/home_detail_screen.dart';
import 'package:quran_app/feature/model/quran_model.dart';
import 'package:quran_app/feature/model/quran_translation.dart';
import 'package:quran_app/feature/quran_cache.dart';
import 'package:quran_app/theme/theme_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  late Future<QuranData> _quranData;
  late Future<QuranTranslationCacheData> _quranTranslationData;
  bool isLastAyah = false;
  String? lastSurah;
  int? lastAyah;

  @override
  void initState() {
    super.initState();
    _loadLastSeenAyah();
    _quranData = QuranCache.instance.getQuranData();
    _quranTranslationData =
        QuranTranslationCache.instance.getQuranDataTranslation();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  Future<void> _loadLastSeenAyah() async {
    final prefs = await SharedPreferences.getInstance();
    lastSurah = prefs.getString('lastSurah');
    lastAyah = prefs.getInt('lastAyah');

    if (lastSurah != null && lastAyah != null) {
      setState(() {
        isLastAyah = true;
      });
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
          title: "Quran App"
              .text
              .bold
              .color(theamNotifier.isDark ? whiteColor : purpleColor)
              .size(20)
              .make(),
          actions: [
            const Icon(
              FluentIcons.search_32_regular,
              color: lightTextColor,
            ).px16()
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "AssalamuAlaikum"
                .text
                .bold
                .color(lightTextColor)
                .size(17.5)
                .make()
                .px(20),
            "Faizan Ahmed"
                .text
                .bold
                .color(theamNotifier.isDark
                    ? whiteColor
                    : darkThemeBackgroundColor)
                .size(25)
                .make()
                .px(20),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              child: Stack(
                children: [
                  Image.asset("asset/images/home_main.png"),
                  Positioned(
                      left: 60,
                      top: 20.5,
                      child: "Last Read"
                          .text
                          .bold
                          .color(whiteColor)
                          // .size(15)
                          .make()),
                  Positioned(
                    left: 20,
                    top: 62,
                    child: isLastAyah
                        ? lastSurah
                            .toString()
                            .text
                            .bold
                            .color(whiteColor)
                            .size(22)
                            .make()
                        : "Al-Fatiah"
                            .text
                            .bold
                            .color(whiteColor)
                            .size(22)
                            .make(),
                  ),
                  Positioned(
                      left: 20,
                      top: 96.5,
                      child: isLastAyah
                          ? "Ayah No: $lastAyah"
                              .toString()
                              .text
                              .color(whiteColor)
                              .size(16)
                              .make()
                          : "Ayah No: 1"
                              .text
                              .color(whiteColor)
                              .size(16)
                              .make()),
                ],
              ),
            ).px16(),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                dividerHeight: 0,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  "Surah"
                      .text
                      .color(theamNotifier.isDark
                          ? whiteColor
                          : darkThemeBackgroundColor)
                      // .bold
                      .size(17)
                      .make(),
                  "Para"
                      .text
                      .color(theamNotifier.isDark
                          ? whiteColor
                          : darkThemeBackgroundColor)
                      // .bold
                      .size(17)
                      .make(),
                  "Favorite"
                      .text
                      .size(17)
                      .color(theamNotifier.isDark
                          ? whiteColor
                          : darkThemeBackgroundColor)
                      // .bold
                      .make(),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTabContent(theamNotifier),
                  _buildTabContent(theamNotifier),
                  _buildTabContent(theamNotifier),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTabContent(TheamModal theamNotifier) {
    return FutureBuilder<List<dynamic>>(
        future: Future.wait([
          _quranData, // First API call
          _quranTranslationData, // Second API call
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final QuranData quranData = snapshot.data![0] as QuranData;
            final QuranTranslationCacheData translationData =
                snapshot.data![1] as QuranTranslationCacheData;

            final surahs = quranData.surahs;
            final surahsTranslation = translationData.surahs;

            return ListView.builder(
                itemCount: surahs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final surah = surahs[index];
                  final surahTrans = surahsTranslation[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomeDetailScreen(
                                surah: surah,
                                surahTrans: surahTrans,
                              )));
                    },
                    child: Container(
                      width: double.maxFinite,
                      margin: index == 0
                          ? const EdgeInsets.only(bottom: 0, top: 12)
                          : const EdgeInsets.only(bottom: 0),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      width: 44,
                                      child: Stack(
                                        children: [
                                          Image.asset(
                                              "asset/images/starticon.png"),
                                          Positioned(
                                            top: 11,
                                            left: (index + 1) >= 100
                                                ? 12.5
                                                : (index + 1) >= 20
                                                    ? 15
                                                    : (index + 1) >= 10
                                                        ? 16.5
                                                        : 18.5,
                                            child: "${index + 1}"
                                                .text
                                                .bold
                                                .color(theamNotifier.isDark
                                                    ? whiteColor
                                                    : darkThemeBackgroundColor)
                                                .make(),
                                          )
                                        ],
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      surah.englishName
                                          .toString()
                                          .text
                                          .color(theamNotifier.isDark
                                              ? whiteColor
                                              : darkThemeBackgroundColor)
                                          .bold
                                          .size(17)
                                          .make(),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      "${surah.revelationType} . ${surah.ayahs.length} verses"
                                          .text
                                          .color(lightTextColor)
                                          .size(13)
                                          .make(),
                                    ],
                                  )
                                ],
                              ),
                              surah.name.text
                                  .color(purpleColor)
                                  .size(17)
                                  .bold
                                  .make(),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Divider(
                            thickness: 0.5,
                            color: lineColor,
                          )
                        ],
                      ),
                    ).px12(),
                  );
                });
          } else {
            return const Center(child: Text('No data available'));
          }
        });
  }
}
