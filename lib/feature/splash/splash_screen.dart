import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/const/colors.dart';
import 'package:quran_app/feature/home/view/home_screen.dart';
import 'package:quran_app/theme/theme_modal.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TheamModal>(builder: (context, theamNotifier, child) {
      return Scaffold(
        backgroundColor:
            theamNotifier.isDark ? darkThemeBackgroundColor : whiteColor,
        appBar: AppBar(
          backgroundColor:
              theamNotifier.isDark ? darkThemeBackgroundColor : whiteColor,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
                child: "Quran App"
                    .text
                    .bold
                    .color(theamNotifier.isDark ? whiteColor : mainColor)
                    .size(35)
                    .make()),
            const SizedBox(
              height: 14,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  theamNotifier.isDark = !theamNotifier.isDark;
                });
              },
              child: const Text(
                "Learn Quran and",
                style: TextStyle(color: lightTextColor, fontSize: 22),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
            const Text(
              "Recite once everyday",
              style: TextStyle(color: lightTextColor, fontSize: 22),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 400,
              height: 470,
              // color: Colors.amberAccent,
              child: Stack(
                children: [
                  const SizedBox(
                    width: 400,
                    height: 470,
                  ),
                  SizedBox(
                    width: 400,
                    height: 440,
                    child: Image.asset(
                      "asset/images/main.png",
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    left: context.screenWidth * 0.29,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                      },
                      child: Container(
                        width: 170,
                        height: 62,
                        decoration: BoxDecoration(
                          color: orangeColor,
                          borderRadius: BorderRadius.circular(45),
                        ),
                        child: "Get Started"
                            .text
                            .color(theamNotifier.isDark
                                ? darkThemeBackgroundColor
                                : whiteColor)
                            .size(19)
                            .bold
                            .makeCentered(),
                      ),
                    ),
                  ),
                ],
              ).centered(),
            ).centered()
          ],
        ),
      );
    });
  }
}
