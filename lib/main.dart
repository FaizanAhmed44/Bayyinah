import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/feature/splash/splash_screen.dart';
import 'package:quran_app/theme/theme_modal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider(
      create: (_) => TheamModal(),
      child: Consumer<TheamModal>(
          builder: (context, TheamModal theamModal, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theamModal.isDark
              ? ThemeData.dark().copyWith(
                  textTheme: GoogleFonts.poppinsTextTheme(textTheme),
                  primaryTextTheme: const TextTheme(),
                )
              : ThemeData.light().copyWith(
                  textTheme: GoogleFonts.poppinsTextTheme(textTheme),
                  primaryTextTheme: const TextTheme(),
                ),
          home: const SplashScreen(),
        );
      }),
    );
  }
}
