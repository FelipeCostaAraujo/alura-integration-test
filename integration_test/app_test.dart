import 'package:client_control/components/hamburger_menu.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:client_control/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Integration test', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text("Menu"), findsNothing);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.text("Menu"), findsOneWidget);
  });

  testWidgets('Testing create new client', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Cadastrar cliente'), findsOneWidget);
    var email = faker.internet.email();
    var name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text(name + ' (Platinum)'), findsOneWidget);
  });

  testWidgets('Testing create client type', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tipos de clientes'));
    await tester.pumpAndSettle();
    expect(find.text('Tipos de cliente'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Cadastrar tipo'), findsOneWidget);
    var name = faker.lorem.word();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    await tester.tap(find.text('Selecionar ícone'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.ac_unit));
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text(name), findsOneWidget);
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
