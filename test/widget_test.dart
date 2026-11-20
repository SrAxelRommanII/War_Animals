import 'package:flutter_test/flutter_test.dart';
import 'package:war_animals/main.dart';

void main() {
  testWidgets('WarAnimalsApp carga correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const WarAnimalsApp());
    expect(find.byType(WarAnimalsApp), findsOneWidget);
  });
}