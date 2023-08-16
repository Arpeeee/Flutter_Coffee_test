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
import 'package:intl/intl.dart';
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
  bool isStart = false; //是否正在烘豆

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

  // 計算series
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

  void _startCook() {
    // 如果沒再轟
    isStart ? isStart = false : isStart = true;
    setState(() {});
  }

  // 框框
  Widget _borderPadding(Widget childWidget) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 20, color: Color.fromRGBO(36, 43, 60, 1)),
            borderRadius: BorderRadius.circular(20),
            // color: Color.fromRGBO(36, 43, 60, 1),
          ),
          child: childWidget,
        ));
  }

  Widget _beansBtn(String activeText, String deactiveText, bool isactive) {
    return Container(
      margin: EdgeInsets.all(10),
      height: double.infinity,
      child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Color.fromRGBO(248, 167, 69, 1))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isactive ? activeText : deactiveText,
                style: TextStyle(color: Colors.black87, fontSize: 25),
              ),
              Icon(
                Icons.filter_alt,
                color: Colors.black87,
              )
            ],
          )),
    );
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
              child: _borderPadding(Padding(
                padding: EdgeInsets.all(20),
                child: MyLineWidget(value: dataPoints),
              ))),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            height: double.infinity,
            child: _borderPadding(Column(
              children: [
                Expanded(
                    flex: 8,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: SliderCustom(
                              title: "风扇转速",
                              value: 0.0,
                              callback: (newvalue) => {_fanvalue = newvalue},
                            )),
                        Expanded(
                            flex: 1,
                            child: SliderCustom(
                              title: "瓦斯火力",
                              value: 0.0,
                              callback: (newvalue) => {_temvalue = newvalue},
                            )),
                        Expanded(
                            flex: 1,
                            child: SliderCustom(
                              title: "滚筒转速",
                              value: 0.0,
                              callback: (newvalue) => {_temvalue = newvalue},
                            ))
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(child: _beansBtn("下豆", "測試", true)),
                        Expanded(child: _beansBtn("出豆", "測試", true))
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        height: double.infinity,
                        child: TextButton(
                          onPressed: () => _startCook(),
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(!isStart
                                  ? Color.fromRGBO(155, 0, 0, 1)
                                  : Color.fromRGBO(176, 43, 59, 0.8)),
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.all(0))),
                          child: Text(
                            isStart ? "結束烘豆" : "開始烘豆",
                            style: TextStyle(
                                fontSize: 22,
                                color: isStart ? Colors.black : Colors.white),
                          ),
                        )))
              ],
            )),
          )
        ],
      ),
    );
  }
}

// slider
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
              child: Text(
                _title,
                style: TextStyle(fontSize: 20),
              ),
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
              numberFormat: NumberFormat(""),
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
        maxX: 5000,
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
