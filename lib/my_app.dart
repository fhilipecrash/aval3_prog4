import 'imports/imports.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NASA API',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        colorScheme: const ColorScheme.dark(
          background: Color(0xFF0D1212),
        ),
      ),
      home: const HomePage(),
      routes: {
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
