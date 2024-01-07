import 'package:client_control/components/hamburger_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:client_control/main.dart' as app;

void main () {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Integration test', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text("Menu"), findsNothing);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.text("Menu"), findsOneWidget);
  });

  testWidgets('Testing the Menu', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: HamburgerMenu(),
    ));
    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('Gerenciar clientes'), findsOneWidget);
    expect(find.text('Tipos de clientes'), findsOneWidget);
    expect(find.text('Sair'), findsOneWidget);
  });

  testWidgets('Testing the Clients Page', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Clientes'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);
  });
}