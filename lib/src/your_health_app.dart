import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:your_health_ex/src/ui/ui.dart';

import 'features/features.dart';

class YourHealthApp extends StatelessWidget {
  const YourHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Health',
      theme: ThemeData(
        fontFamily: YourHealthAppFonts.manrope,
        useMaterial3: true,
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
      ],
      home: Scaffold(
        body: DynamicScreen(),
      ),
    );
  }
}
