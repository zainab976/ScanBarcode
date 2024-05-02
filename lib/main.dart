import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:price_scanner_app/setting.dart';
import 'vendor/resize/resize.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar')
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    // Store the context in a local variable
    final localizationContext = context;

    return Resize(
      size: const Size(1280, 800),
      allowtextScaling: false,
      builder: () {
        // Use the stored context variable
        return MaterialApp(
          localizationsDelegates: localizationContext.localizationDelegates,
          supportedLocales: localizationContext.supportedLocales,
          locale: localizationContext.locale,
          debugShowCheckedModeBanner: false,
          home: const SettingPage(),
        );
      },
    );
  }
}
