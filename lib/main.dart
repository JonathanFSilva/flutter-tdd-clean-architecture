import 'package:clean_architecture/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:clean_architecture/injection_container.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  runApp(App());
}

class App extends StatelessWidget {
  final ThemeData theme = ThemeData(
    primaryColor: Colors.green.shade800,
    accentColor: Colors.green.shade600,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: theme,
      home: NumberTriviaPage(),
    );
  }
}
