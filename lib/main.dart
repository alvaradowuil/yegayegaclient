import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yegayega/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]).then((_){
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {

  final routes = <String, WidgetBuilder> {
    HomePage.tag: (context) => HomePage(),

  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: routes,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
          const Locale('es'),
        ],
    );
  }
}
