// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

// import 'dart:ffi';

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:syncfusion_flutter_charts/charts.dart'
// import 'PrincePoint.dart';
// import 'AnimatedLineChart.dart';

import 'dart:async';
import 'dart:math';

import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Line Chart',
      home: LineChartPage(),
    );
  }
}

class LineChartPage extends StatefulWidget {
  @override
  _LineChartPageState createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage> {
  List<FlSpot> dataPoints = [];
  Timer? timer;
  double keyfl = 0;
  double _fanvalue = 50;
  double _temvalue = 50;

  // var value = 0.0;

  @override
  void initState() {
    super.initState();
    startUpdatingData();
  }

  @override
  void dispose() {
    stopUpdatingData();
    super.dispose();
  }

  void startUpdatingData() {
    timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        dataPoints.add(FlSpot(
            keyfl, (_fanvalue / 10) + (_temvalue / 10) + (keyfl / 1000)));
        if (dataPoints.length > 3000) {
          dataPoints = [];
        }
        keyfl++;
      });
    });
  }

  void stopUpdatingData() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Line Chart'),
        backgroundColor: Color.fromRGBO(255, 76, 0, 1),
      ),
      //
      body: Row(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: double.infinity,
              child: BorderPading(
                  child: Padding(
                padding: EdgeInsets.all(20),
                child: MyLineWidget(value: dataPoints),
                // child: LineChart(
                //   LineChartData(
                //     lineTouchData: LineTouchData(enabled: false),
                //     gridData: FlGridData(show: false),
                //     titlesData: FlTitlesData(show: false),
                //     borderData: FlBorderData(show: false),
                //     lineBarsData: [
                //       LineChartBarData(
                //         spots: dataPoints.asMap().entries.map((entry) {
                //           return FlSpot(entry.key.toDouble(), entry.value);
                //         }).toList(),
                //         isCurved: true,
                //         color: Colors.blue,
                //         dotData: FlDotData(show: false),
                //         belowBarData: BarAreaData(show: false),
                //       ),
                //     ],
                //   ),
                // ),
              ))),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              height: double.infinity,
              child: BorderPading(
                  child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: SliderCustom(
                        title: "測試風扇",
                        value: 0.0,
                        callback: (newvalue) => {_fanvalue = newvalue},
                      )),
                  Expanded(
                      flex: 1,
                      child: SliderCustom(
                        title: "測試轉速",
                        value: 0.0,
                        callback: (newvalue) => {_temvalue = newvalue},
                      ))
                ],
              )))
        ],
      ),
    );
  }
}

class BorderPading extends StatelessWidget {
  const BorderPading({super.key, this.child = const Placeholder()});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 20, color: Color.fromRGBO(36, 43, 60, 1)),
            borderRadius: BorderRadius.circular(20),
            // color: Color.fromRGBO(36, 43, 60, 1),
          ),
          child: child,
        ));
  }
}

class SliderCustom extends StatefulWidget {
  // const sliderCustom({super.key});
  const SliderCustom(
      {super.key, required this.callback, this.title = "測試", this.value = 0.0});

  final void Function(double newvalue) callback;
  final String title;
  final dynamic value;

  @override
  State<SliderCustom> createState() => _SliderCustomState();
}

class _SliderCustomState extends State<SliderCustom> {
  // dynamic _value get  => widget.value;
  get _title => widget.title;
  dynamic _value2 = 50;

  void initState() {
    // TODO: implement initState
    // _value2 = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Center(
              child: Text(_title),
            )),
        Expanded(
            flex: 9,
            child: SfSlider.vertical(
              min: 0.0,
              max: 100.0,
              value: _value2,
              interval: 20,
              showTicks: true,
              showLabels: true,
              // showDividers: true,
              minorTicksPerInterval: 1,
              // onChangeStart: (value) => _value,
              onChanged: (dynamic value) async {
                _value2 = value;
                widget.callback(value);
                setState(() {});
              },
            ))
      ],
    );
  }
}

class MyLineWidget extends StatefulWidget {
  const MyLineWidget({super.key, this.value});

  final List<FlSpot>? value;

  @override
  State<MyLineWidget> createState() => _MyLineWidgetState();
}

class _MyLineWidgetState extends State<MyLineWidget> {
  List<double> list = [1, 2, 4, 6, 7, 3, 2, 6, 2];

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: FlGridData(show: true),
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: [lineBarsData2],
        minX: 0,
        maxX: 3000,
        maxY: 20,
        minY: 0,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border.all(
            color: Colors.deepOrange,
            width: 1.0,
            strokeAlign: BorderSide.strokeAlignCenter),
      );

  LineTouchData get lineTouchData2 => LineTouchData(
        touchTooltipData: LineTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(3),
            tooltipBgColor: Colors.amberAccent),
        enabled: true,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        show: false,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            getTitlesWidget: (value, meta) {
              return const Text(
                "123",
                style: TextStyle(),
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            getTitlesWidget: (value, meta) {
              return const Text(
                "123",
                style: TextStyle(color: Colors.black, fontSize: 20),
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
      );

  LineChartBarData get lineBarsData2 => LineChartBarData(
        spots: widget.value,
        isCurved: true,
        color: Colors.blue,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: true),
      );

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData2,
      swapAnimationCurve: Curves.linear,
      swapAnimationDuration: Duration(milliseconds: 100),
    );
  }
}

// const Placeholder()

// class SunflowerPainter extends CustomPainter {
//   static const seedRadius = 2.0;
//   static const scaleFactor = 4;
//   static const tau = math.pi * 2;

//   static final phi = (math.sqrt(5) + 1) / 2;

//   final int seeds;

//   SunflowerPainter(this.seeds);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = size.width / 2;

//     for (var i = 0; i < seeds; i++) {
//       final theta = i * tau / phi;
//       final r = math.sqrt(i) * scaleFactor;
//       final x = center + r * math.cos(theta);
//       final y = center - r * math.sin(theta);
//       final offset = Offset(x, y);
//       if (!size.contains(offset)) {
//         continue;
//       }
//       drawSeed(canvas, x, y);
//     }
//   }

//   @override
//   bool shouldRepaint(SunflowerPainter oldDelegate) {
//     return oldDelegate.seeds != seeds;
//   }

//   // Draw a small circle representing a seed centered at (x,y).
//   void drawSeed(Canvas canvas, double x, double y) {
//     final paint = Paint()
//       ..strokeWidth = 2
//       ..style = PaintingStyle.fill
//       ..color = primaryColor;
//     canvas.drawCircle(Offset(x, y), seedRadius, paint);
//   }
// }

// class Sunflower extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _SunflowerState();
//   }
// }

// class _SunflowerState extends State<Sunflower> {
//   double seeds = 100.0;

//   int get seedCount => seeds.floor();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData().copyWith(
//         platform: platform,
//         brightness: Brightness.dark,
//         sliderTheme: SliderThemeData.fromPrimaryColors(
//           primaryColor: primaryColor,
//           primaryColorLight: primaryColor,
//           primaryColorDark: primaryColor,
//           valueIndicatorTextStyle: const DefaultTextStyle.fallback().style,
//         ),
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text("Sunflower"),
//         ),
//         drawer: Drawer(
//           child: ListView(
//             children: const [
//               DrawerHeader(
//                 child: Center(
//                   child: Text(
//                     "Sunflower 🌻",
//                     style: TextStyle(fontSize: 32),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: Container(
//           constraints: const BoxConstraints.expand(),
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Colors.transparent,
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.blue,
//                   ),
//                 ),
//                 child: SizedBox(
//                   width: 400,
//                   height: 400,
//                   child: CustomPaint(
//                     painter: SunflowerPainter(seedCount),
//                   ),
//                 ),
//               ),
//               Text("Showing $seedCount seeds"),
//               ConstrainedBox(
//                 constraints: const BoxConstraints.tightFor(width: 400),
//                 child: Slider.adaptive(
//                   min: 20,
//                   max: 2000,
//                   value: seeds,
//                   onChanged: (newValue) {
//                     setState(() {
//                       seeds = newValue;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
