import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/firestore_service.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  double stepScore = 0;
  double waterScore = 0;
  double sleepScore = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    final step = await FirestoreService.getStepData();
    final water = await FirestoreService.getWaterData();
    final sleep = await FirestoreService.getSleepHours();

    setState(() {
      stepScore = (step / 5000 * 10).clamp(0, 10);
      waterScore = (water / 8 * 10).clamp(0, 10);
      sleepScore = (sleep / 8 * 10).clamp(0, 10);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("İstatistikler")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Bugünkü Sağlık Puanların",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: BarChart(
                      BarChartData(
                        maxY: 10,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.black87,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final label = ["Adım", "Su", "Uyku"][group.x];
                              return BarTooltipItem(
                                "$label: ${rod.toY.toStringAsFixed(1)} puan",
                                const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) => Text("${value.toInt()}"),
                              reservedSize: 28,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return const Text("Adım");
                                  case 1:
                                    return const Text("Su");
                                  case 2:
                                    return const Text("Uyku");
                                  default:
                                    return const Text("");
                                }
                              },
                            ),
                          ),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(show: true, drawVerticalLine: false),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: stepScore,
                                color: Colors.green,
                                width: 26,
                                borderRadius: BorderRadius.circular(6),
                                backDrawRodData: BackgroundBarChartRodData(show: true, toY: 10, color: Colors.grey[300]),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: waterScore,
                                color: Colors.blue,
                                width: 26,
                                borderRadius: BorderRadius.circular(6),
                                backDrawRodData: BackgroundBarChartRodData(show: true, toY: 10, color: Colors.grey[300]),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                toY: sleepScore,
                                color: Colors.purple,
                                width: 26,
                                borderRadius: BorderRadius.circular(6),
                                backDrawRodData: BackgroundBarChartRodData(show: true, toY: 10, color: Colors.grey[300]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text("Her kategori 10 üzerinden değerlendirilir."),
                ],
              ),
            ),
    );
  }
}
