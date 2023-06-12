import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// import 'package:flutter/src/widgets/framework.dart';

// import 'package:flutter/src/widgets/container.dart';

class AnimatedLineChart extends StatefulWidget {
  const AnimatedLineChart({super.key});

  @override
  State<AnimatedLineChart> createState() => _AnimatedLineChartState();
}

class _AnimatedLineChartState extends State<AnimatedLineChart> {
  List<double> randomList = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startAddingData();
  }

  void deposeStates() {
    stopAddingData();
    super.dispose();
  }

  void startAddingData() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (randomList.length < 100) {
        randomList.add(Random().nextDouble() * 100);
        print('List length: ${randomList.length}');
      } else {
        stopAddingData();
        // print('List complete');
      }
    });
  }

  void stopAddingData() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test2 Animation ${randomList.length}'),
      ),
      body: LineChart(LineChartData(
        lineTouchData: LineTouchData(enabled: false),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: randomList.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value);
            }).toList(),
            isCurved: true,
            color: Colors.blue,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            // colorStops: [0.0],
          ),
        ],
      )),
    );
  }
}
