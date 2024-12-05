import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Importación de Syncfusion Charts

void main() {
  runApp(const DashboardApp());
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Multiplataforma',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Random _random = Random();
  List<double> randomData = [];
  double percentage = 0.0;
  double gaugeValue = 0.0;
  Timer? _timer;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _generateRandomData();
    _startDataUpdates();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _generateRandomData() {
    try {
      setState(() {
        randomData = List.generate(7, (_) => _random.nextDouble() * 100);
        percentage = _random.nextDouble();
        gaugeValue = _random.nextDouble() * 100;
        hasError = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
      });
    }
  }

  void _startDataUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _generateRandomData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Multiplataforma')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (hasError) {
            return const Center(
              child: Text(
                'Error al generar datos. Por favor, inténtalo de nuevo.',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }
          if (constraints.maxWidth > 1200) {
            // Escritorio
            return _buildDesktopLayout();
          } else if (constraints.maxWidth > 800) {
            // Web
            return _buildWebLayout();
          } else {
            // Móvil
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        _buildInfoCards(),
        const SizedBox(height: 20),
        _buildCircularIndicator(),
        const SizedBox(height: 20),
        _buildTemperatureGauge(),
        const SizedBox(height: 20),
        _buildBarChart(),
        const SizedBox(height: 20),
        _buildPieChart(),
        const SizedBox(height: 20),
        _buildThermometer(),
        const SizedBox(height: 20),
        _buildDataTable(),
        const SizedBox(height: 20),
        _buildLineChart(),
      ],
    );
  }

  Widget _buildWebLayout() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      children: [
        _buildInfoCards(),
        _buildCircularIndicator(),
        _buildTemperatureGauge(),
        _buildBarChart(),
        _buildPieChart(),
        _buildThermometer(),
        _buildDataTable(),
        _buildLineChart(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return GridView.count(
      crossAxisCount: 4,
      childAspectRatio: 1.2,
      children: [
        _buildInfoCards(),
        _buildCircularIndicator(),
        _buildTemperatureGauge(),
        _buildBarChart(),
        _buildPieChart(),
        _buildThermometer(),
        _buildDataTable(),
        _buildLineChart(),
      ],
    );
  }

  Widget _buildInfoCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 3,
      children: [
        _buildInfoCard('Completitud', '${(percentage * 100).toStringAsFixed(1)}%', Colors.green),
        _buildInfoCard('Temperatura', '${gaugeValue.toStringAsFixed(1)}°C', Colors.red),
        // Puedes añadir más tarjetas según sea necesario
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularIndicator() {
    return AspectRatio(
      aspectRatio: 1,
      child: FittedBox(
        child: CircularPercentIndicator(
          radius: 100.0,
          lineWidth: 10.0,
          percent: percentage,
          center: Text('${(percentage * 100).toStringAsFixed(1)}%'),
          progressColor: Colors.green,
        ),
      ),
    );
  }

  Widget _buildTemperatureGauge() {
    return AspectRatio(
      aspectRatio: 1,
      child: FittedBox(
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 100,
              ranges: <GaugeRange>[
                GaugeRange(startValue: 0, endValue: 33, color: Colors.green),
                GaugeRange(startValue: 33, endValue: 66, color: Colors.orange),
                GaugeRange(startValue: 66, endValue: 100, color: Colors.red)
              ],
              pointers: <GaugePointer>[
                NeedlePointer(value: gaugeValue)
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Text('${gaugeValue.toStringAsFixed(1)}°C'),
                  angle: 90,
                  positionFactor: 0.5,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(minimum: 0, maximum: 100),
          // ignore: prefer_const_constructors
          title: ChartTitle(text: 'Gráfico de Barras'),
          legend: Legend(isVisible: false),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries>[
            ColumnSeries<ChartData, String>(
              dataSource: List.generate(
                randomData.length,
                (index) => ChartData('Ítem ${index + 1}', randomData[index]),
              ),
              xValueMapper: (ChartData data, _) => data.category,
              yValueMapper: (ChartData data, _) => data.value,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return AspectRatio(
      aspectRatio: 1,
      child: SfCircularChart(
        title: ChartTitle(text: 'Gráfico de Pastel'),
        legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        series: <CircularSeries>[
          PieSeries<ChartData, String>(
            dataSource: List.generate(
              randomData.length,
              (index) => ChartData('Ítem ${index + 1}', randomData[index]),
            ),
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.value,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }

  Widget _buildThermometer() {
    return AspectRatio(
      aspectRatio: 1,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 100,
            ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 30, color: Colors.blue),
              GaugeRange(startValue: 30, endValue: 70, color: Colors.orange),
              GaugeRange(startValue: 70, endValue: 100, color: Colors.red),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(value: gaugeValue)
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text('${gaugeValue.toStringAsFixed(1)}°C'),
                angle: 90,
                positionFactor: 0.5,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(minimum: 0, maximum: 100),
        // ignore: prefer_const_constructors
        title: ChartTitle(text: 'Gráfico de Líneas'),
        legend: Legend(isVisible: false),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries>[
          LineSeries<ChartData, String>(
            dataSource: List.generate(
              randomData.length,
              (index) => ChartData('Ítem ${index + 1}', randomData[index]),
            ),
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.value,
            color: Colors.purple,
            width: 4,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Índice')),
          DataColumn(label: Text('Valor')),
        ],
        rows: randomData.asMap().entries.map((entry) {
          return DataRow(
            cells: [
              DataCell(Text(entry.key.toString())),
              DataCell(Text(entry.value.toStringAsFixed(2))),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class ChartData {
  final String category;
  final double value;

  ChartData(this.category, this.value);
}
