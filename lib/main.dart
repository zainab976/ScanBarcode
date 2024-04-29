// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:price_scanner_app/setting.dart';
// import 'vendor/resize/resize.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:easy_localization/easy_localization.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await EasyLocalization.ensureInitialized();
//   //runApp(MyApp());
//   runApp(
//     EasyLocalization(
//         supportedLocales: const [Locale('en'), Locale('ar')],
//         path:
//             'assets/translations', // <-- change the path of the translation files
//         fallbackLocale: const Locale('en'),
//         child: MyApp()),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setEnabledSystemUIMode(
//       SystemUiMode.immersiveSticky,
//     );
//     // Initialize ResizeUtil using Resize()
//     return Resize(
//       size: const Size(1280, 800),
//       allowtextScaling: false,
//       builder: () {
//         return const MaterialApp(
//           localizationsDelegates: context.localizationDelegates,
//           supportedLocales: context.supportedLocales,
//           locale: context.locale,
//           debugShowCheckedModeBanner: false,
//           home: SettingPage(),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:price_scanner_app/setting.dart';
import 'vendor/resize/resize.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
          home: SettingPage(),
        );
      },
    );
  }
}
