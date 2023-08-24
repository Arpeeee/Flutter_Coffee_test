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
  double _tongvalue = 50;
  //是否正在烘豆
  final ValueNotifier<bool> _isStart = ValueNotifier<bool>(false);

  // var value = 0.0;

  @override
  void initState() {
    super.initState();

    _isStart.addListener(() {
      if (_isStart.value) {
        // 正在烘豆
        startUpdatingData();
      } else {
        stopUpdatingData();
      }
    });
  }

  @override
  void dispose() {
    stopUpdatingData();
    super.dispose();
  }

  // 計算series
  void startUpdatingData() {
    timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      double barvalue =
          1 + (_temvalue / 10000) - (_fanvalue / 20000) - (_tongvalue / 20000);
      if (dataPoints.length <= 92) {
        // 負斜率

        keyfl != 0
            ? dataPoints.add(FlSpot(
                keyfl,
                Random().nextDouble() * 0.3 +
                    (barvalue - 0.01) * (dataPoints[(keyfl - 1).toInt()].y)))
            : dataPoints.add(const FlSpot(0, 40));
        keyfl++;
      } else if (dataPoints.length > 92 && dataPoints.length < 200) {
        // 正斜率
        dataPoints.add(FlSpot(
            keyfl,
            -Random().nextDouble() * 0.1 +
                0.05 +
                (keyfl / 10000) +
                (barvalue * dataPoints[(keyfl - 1).toInt()].y)));
        keyfl++;
      } else {
        // 超過時間就停止
        dataPoints = [];
        _isStart.value = false;
        keyfl = 0;
      }
      setState(() {});
    });
  }

  void stopUpdatingData() {
    timer?.cancel();
    dataPoints = [];
    keyfl = 0;
    setState(() {});
  }

  void _toggleCook() {
    // 如果沒再轟
    _isStart.value ? _endCook() : _startCook();
    setState(() {});
  }

  void _startCook() {
    if (_isStart.value) {
      showAlertDialog(
        context,
        "錯誤",
        "已下豆 正在烘豆中",
        () => Navigator.pop(context),
        () => Navigator.pop(context),
      );
    } else {
      showAlertDialog(
        context,
        "警告",
        "請確認是否下豆",
        () {
          setState(() {
            _isStart.value = true;
            Navigator.pop(context);
          });
        },
        () {
          Navigator.pop(context);
        },
      );
    }
  }

  void _endCook() {
    if (!_isStart.value) {
      showAlertDialog(
        context,
        "錯誤",
        "已出豆或未開始烘豆",
        () => Navigator.pop(context),
        () => Navigator.pop(context),
      );
    } else {
      showAlertDialog(
        context,
        "警告",
        "請確認是否出豆",
        () {
          setState(() {
            _isStart.value = false;
            Navigator.pop(context);
          });
        },
        () {
          Navigator.pop(context);
        },
      );
    }
  }

  // 框框
  Widget _borderPadding(Widget childWidget) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          border:
              Border.all(width: 20, color: const Color.fromRGBO(36, 43, 60, 1)),
          borderRadius: BorderRadius.circular(20),
          // color: Color.fromRGBO(36, 43, 60, 1),
        ),
        child: childWidget,
      ),
    );
  }

  // 出豆下豆按鈕
  Widget _beansBtn(String activeText, IconData icon, bool isactive,
      void Function() onpress) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: double.infinity,
      child: ElevatedButton(
        onPressed: onpress,
        style: const ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(Color.fromRGBO(248, 167, 69, 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              activeText,
              style: const TextStyle(color: Colors.black87, fontSize: 25),
            ),
            Icon(
              icon,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '瑞提娜咖啡機',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 5),
        ),
        backgroundColor: const Color.fromRGBO(255, 76, 0, 1),
      ),
      //
      body: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: double.infinity,
            child: _borderPadding(
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/Retina.png"),
                        opacity: 0.7,
                        fit: BoxFit.scaleDown)),
                child: MyLineWidget(value: dataPoints),
              ),
            ),
          ),
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
                            callback: (newvalue) => {_fanvalue = newvalue},
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SliderCustom(
                            title: "瓦斯火力",
                            callback: (newvalue) => {_temvalue = newvalue},
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SliderCustom(
                            title: "滚筒转速",
                            callback: (newvalue) => {_tongvalue = newvalue},
                          ),
                        )
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                            child: _beansBtn(
                                "入豆", Icons.filter_alt, true, _startCook)),
                        Expanded(
                            child: _beansBtn(
                                "出豆", Icons.coffee_outlined, false, _endCook))
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        height: double.infinity,
                        child: TextButton(
                          onPressed: () => _toggleCook(),
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  !_isStart.value
                                      ? const Color.fromRGBO(155, 0, 0, 1)
                                      : const Color.fromRGBO(176, 43, 59, 0.8)),
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.all(0))),
                          child: Text(
                            _isStart.value ? "結束烘豆" : "開始烘豆",
                            style: TextStyle(
                                fontSize: 22,
                                color: _isStart.value
                                    ? Colors.black
                                    : Colors.white),
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
  const SliderCustom({
    super.key,
    required this.callback,
    this.title = "測試",
    this.value = 50,
  });

  final void Function(double newvalue) callback;
  final String title;
  final double value;

  @override
  State<SliderCustom> createState() => _SliderCustomState();
}

class _SliderCustomState extends State<SliderCustom> {
  // dynamic _value get  => widget.value;
  late String _title;
  late double _value2;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _value2 = widget.value;
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
                style: const TextStyle(fontSize: 20),
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
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            getTitlesWidget: (value, meta) {
              return const Text(
                "123",
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
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: FlGridData(show: true),
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: [lineBarsData2],
        minX: 0,
        maxX: 1500,
        maxY: 100,
        minY: 0,
      );
  LineChartBarData get lineBarsData2 => LineChartBarData(
        show: widget.value!.isNotEmpty,
        spots: widget.value,
        isCurved: true,
        color: Color.fromARGB(255, 243, 68, 33),
        barWidth: 5,
        dotData: FlDotData(show: false),
        // belowBarData: BarAreaData(show: true),
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

void showAlertDialog(
  BuildContext context,
  String title,
  String content,
  void Function() yesbutton,
  void Function() nobutton,
) {
  // Init
  AlertDialog dialog = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      ElevatedButton(child: const Text("OK"), onPressed: yesbutton),
      ElevatedButton(child: const Text("Cancel"), onPressed: nobutton),
    ],
  );

  // Show the dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      });
}
