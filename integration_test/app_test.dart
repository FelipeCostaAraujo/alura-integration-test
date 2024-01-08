import 'package:client_control/components/hamburger_menu.dart';
import 'package:client_control/models/clients.dart';
import 'package:client_control/models/types.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:client_control/main.dart' as app;
import 'package:provider/provider.dart';

void main() {
  String clientType = faker.lorem.word();
  String name = faker.person.name();
  String email = faker.internet.email();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('UI testing', () {
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
      app.main([], GlobalKey());
      await tester.pumpAndSettle();
      expect(find.text('Clientes'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });
  });

  group('Navigation', () {
    testWidgets('Testing navigation of menu "Gerenciar Clientes"',
        (tester) async {
          app.main([], GlobalKey());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Gerenciar clientes'));
      await tester.pumpAndSettle();
      expect(find.text('Clientes'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('Testing navigation of menu "Tipos de Clientes"',
        (tester) async {
          app.main([], GlobalKey());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tipos de clientes'));
      await tester.pumpAndSettle();
      expect(find.text('Tipos de cliente'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });
  });

  group('Actions', () {
    testWidgets('Testing open menu', (tester) async {
      app.main([], GlobalKey());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      expect(find.text('Menu'), findsOneWidget);
      expect(find.text('Gerenciar clientes'), findsOneWidget);
      expect(find.text('Tipos de clientes'), findsOneWidget);
      expect(find.text('Sair'), findsOneWidget);
    });
  });

  testWidgets('Testing create client type', (tester) async {
    app.main([], GlobalKey());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tipos de clientes'));
    await tester.pumpAndSettle();
    expect(find.text('Tipos de cliente'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Cadastrar tipo'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), clientType);
    await tester.pump();
    await tester.tap(find.text('Selecionar icone'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.ac_unit));
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text(clientType), findsOneWidget);
  });

  testWidgets('Testing create new client', (tester) async {
    app.main([], GlobalKey());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Cadastrar cliente'), findsOneWidget);
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text(name + ' (Platinum)'), findsOneWidget);
  });

  testWidgets('Testing Client feature', (tester) async {
    final providerKey = GlobalKey();
    app.main([], providerKey);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tipos de clientes'));
    await tester.pumpAndSettle();

    expect(find.text('Tipos de cliente'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Cadastrar tipo'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), clientType);
    await tester.pump();
    await tester.tap(find.text('Selecionar icone'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.ac_unit));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text(clientType), findsOneWidget);
    expect(Provider.of<Types>(providerKey.currentContext!, listen: false).types.last.name, clientType);

    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gerenciar clientes'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Cadastrar cliente'), findsOneWidget);
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    await tester.pump();
    await tester.tap(find.byIcon(Icons.arrow_downward));
    await tester.pumpAndSettle();
    await tester.tap(find.text(clientType));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(Provider.of<Clients>(providerKey.currentContext!, listen: false).clients.last.name, name);

    expect(find.text(name + ' ($clientType)'), findsOneWidget);

    final clientTileFinder = find.text(name + ' ($clientType)');

    expect(clientTileFinder, findsOneWidget);
    await tester.drag(clientTileFinder, const Offset(500.0, 0.0));
    await tester.pumpAndSettle();

    expect(find.text(name + ' ($clientType)'), findsNothing);
  });
}
