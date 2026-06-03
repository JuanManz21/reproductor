import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lark_player_clone/main.dart';
import 'package:lark_player_clone/providers/song_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App loads and shows home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SongProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that the title is shown.
    expect(find.text('My Music'), findsOneWidget);
  });
}
