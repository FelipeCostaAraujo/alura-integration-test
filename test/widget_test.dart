import 'package:client_control/components/hamburger_menu.dart';
import 'package:client_control/models/client_type.dart';
import 'package:client_control/models/clients.dart';
import 'package:client_control/models/types.dart';
import 'package:client_control/pages/client_types_page.dart';
import 'package:client_control/pages/clients_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:client_control/components/icon_picker.dart';

void main() {
  group('Testing the Menu', () {
    testWidgets('Hamburguer Menu should have "Menu"', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: HamburgerMenu(),
      ));
      expect(find.text('Menu'), findsOneWidget);
    });

    testWidgets('Hamburguer Menu should have "Gerenciar clientes"',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: HamburgerMenu(),
      ));
      expect(find.text('Gerenciar clientes'), findsOneWidget);
    });

    testWidgets('Hamburguer Menu should have "Tipos de clientes"',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: HamburgerMenu(),
      ));
      expect(find.text('Tipos de clientes'), findsOneWidget);
    });

    testWidgets('Hamburguer Menu should have "Sair"', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: HamburgerMenu(),
      ));
      expect(find.text('Sair'), findsOneWidget);
    });
  });

  group('Client Page', () {
    Future<void> loadPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => Clients(clients: [])),
            ChangeNotifierProvider(
                create: (context) => Types(types: [
                      ClientType(name: 'Platinum', icon: Icons.credit_card),
                      ClientType(name: 'Golden', icon: Icons.card_membership),
                      ClientType(name: 'Titanium', icon: Icons.credit_score),
                      ClientType(name: 'Diamond', icon: Icons.diamond),
                    ]))
          ],
          child: const MaterialApp(
            home: ClientsPage(title: 'Clientes'),
          ),
        ),
      );
    }

    testWidgets('Clients Page should have "Clientes"',
        (WidgetTester tester) async {
      await loadPage(tester);
      expect(find.text('Clientes'), findsOneWidget);
    });

    testWidgets('Clients Page should have "Add"', (WidgetTester tester) async {
      await loadPage(tester);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Clients Page should have "Menu"', (WidgetTester tester) async {
      await loadPage(tester);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('Should show snack after tap into client', (tester)  async {
      await loadPage(tester);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('Cadastrar cliente'), findsOneWidget);
      await tester.enterText(find.bySemanticsLabel('Nome'), 'Novo Cliente');
      await tester.pump();
      await tester.enterText(find.bySemanticsLabel('Email'), 'novo@cliente.com');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.arrow_downward));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Golden'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();
      expect(find.text('Novo Cliente (Golden)'), findsOneWidget);
      await tester.tap(find.text('Novo Cliente (Golden)'));
      await tester.pumpAndSettle();
      expect(find.byType(ScaffoldMessenger), findsOneWidget);
      expect(find.text('novo@cliente.com'), findsOneWidget);
    });
  });

  group('Clients type page', () {
    Future<void> loadPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => Clients(clients: [])),
            ChangeNotifierProvider(
                create: (context) => Types(types: [
                      ClientType(name: 'Platinum', icon: Icons.credit_card),
                      ClientType(name: 'Golden', icon: Icons.card_membership),
                      ClientType(name: 'Titanium', icon: Icons.credit_score),
                      ClientType(name: 'Diamond', icon: Icons.diamond),
                    ]))
          ],
          child: const MaterialApp(
            home: ClientTypesPage(title: 'Tipos de cliente'),
          ),
        ),
      );
    }

    testWidgets('ClientTypesPage should have "Tipos de cliente"',
        (WidgetTester tester) async {
      await loadPage(tester);
      expect(find.text('Tipos de cliente'), findsOneWidget);
    });

    testWidgets('ClientTypesPage should have "Add"',
        (WidgetTester tester) async {
      await loadPage(tester);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('ClientTypesPage should have "Menu"',
        (WidgetTester tester) async {
      await loadPage(tester);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('ClientTypesPage should default types', (tester) async {
      await loadPage(tester);
      expect(find.text('Platinum'), findsOneWidget);
      expect(find.text('Golden'), findsOneWidget);
      expect(find.text('Titanium'), findsOneWidget);
      expect(find.text('Diamond'), findsOneWidget);
    });

    testWidgets('ClientTypesPage adds a new type', (WidgetTester tester) async {
      await loadPage(tester);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('Cadastrar tipo'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'Novo Tipo');
      await tester.pump();

      await tester.tap(find.text('Selecionar icone'));
      await tester.pumpAndSettle();

      expect(find.text('Escolha um ícone'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.card_giftcard));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.card_giftcard), findsOneWidget);

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();
      expect(find.text('Novo Tipo'), findsOneWidget);
    });
  });

  group('Icon picker', () {
    testWidgets('showIconPicker displays icons and returns selected icon',
        (WidgetTester tester) async {
      IconData? selectedIcon;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () async {
                  selectedIcon = await showIconPicker(context: context);
                },
                child: const Text('Show Icon Picker'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Icon Picker'));
      await tester.pumpAndSettle();
      expect(find.text('Escolha um ícone'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.card_giftcard));
      await tester.pumpAndSettle();
      expect(selectedIcon, equals(Icons.card_giftcard));
    });
  });
}
