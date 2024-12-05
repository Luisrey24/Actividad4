import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:myapp/main.dart';  // Importación basada en paquete correcta

void main() {
  testWidgets('Dashboard screen renders correctly', (WidgetTester tester) async {
    // Construye nuestra aplicación y dispara un frame
    await tester.pumpWidget(const DashboardApp());

    // Verifica que aparezcan elementos clave del dashboard
    expect(find.text('Dashboard Multiplataforma'), findsOneWidget);
    expect(find.byType(CircularPercentIndicator), findsWidgets);
    expect(find.byType(SfRadialGauge), findsWidgets);
  });

  testWidgets('Dashboard adapta layout según tamaño de pantalla', (WidgetTester tester) async {
    // Simular pantalla pequeña
    await tester.binding.setSurfaceSize(const Size(300, 600));
    await tester.pumpWidget(const DashboardApp());

    var listView = find.byType(ListView);
    expect(listView, findsOneWidget);

    // Simular pantalla ancha
    await tester.binding.setSurfaceSize(const Size(800, 600));
    await tester.pumpWidget(const DashboardApp());

    var gridView = find.byType(GridView);
    expect(gridView, findsOneWidget);
  });
}