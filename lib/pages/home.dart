import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wgmon/data.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wgtmon"),
        elevation: 0,
        backgroundColor: Color(0xFF9e77e0),
      ),
      drawerScrimColor: Color(0xFF9e77e0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: WeightChart(),
        ),
      ),
    );
  }
}

class WeightChart extends StatefulWidget {

  const WeightChart({
    Key key,
  }) : super(key: key);

  @override
  _WeightChartState createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {

  List<Map<String, dynamic>> _data;

  final limite = 50;

  @override
  void initState() {
    _data = Data().getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
          // borderRadius: const BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: const [
              Color(0xff2c274c),
              Color(0xff46426c),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 37,
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Peso (kg)',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 37,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(
                      sampleData1(),
                      swapAnimationDuration: const Duration(milliseconds: 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            if ( value.toInt() % 10 == 0 ) {
              List<Map<String, dynamic>> item = _data.where((element) => element['index'] == value.toInt()).toList();
              if ( item.length > 0 ) {
                int month = int.parse(item[0]['date'].substring(3, 5));
                switch ( month ) {
                  case 1:
                    return 'JAN';
                  case 2:
                    return 'FEV';
                  case 3:
                    return 'MAR';
                  case 4:
                    return 'ABR';
                  case 5:
                    return 'MAI';
                  case 6:
                    return 'JUN';
                  case 7:
                    return 'JUL';
                  case 8:
                    return 'AGO';
                  case 9:
                    return 'SET';
                  case 10:
                    return 'OUT';
                  case 11:
                    return 'NOV';
                  case 12:
                    return 'DEZ';
                }
              } 
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            if ( value.toInt() % 2 == 0 )
              return value.toInt().toString();
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 3,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: (_data.length <= limite) ? _data.reduce((a, b) {
              if ( a['index'] < b['index'] )
                return a;
              else 
                return b;
            })['index'] + 0.0 : 
            _data.sublist(limite).reduce((a, b) {
              if ( a['index'] < b['index'] )
                return a;
              else 
                return b;
            })['index'] + 0.0,
      maxX: (_data.length <= limite) ? _data.reduce((a, b) {
              if ( a['index'] > b['index'] )
                return a;
              else 
                return b;
            })['index'] + 0.0 :
            _data.sublist(limite).reduce((a, b) {
              if ( a['index'] > b['index'] )
                return a;
              else 
                return b;
            })['index'] + 0.0,
      maxY: (_data.length <= limite) ? _data.reduce((a, b) {
              if ( a['peso'] > b['peso'] )
                return a;
              else 
                return b;
            })['peso'] + 2.0 :
            _data.sublist(limite).reduce((a, b) {
              if ( a['peso'] > b['peso'] )
                return a;
              else 
                return b;
            })['peso'] + 2.0,
      minY: (_data.length <= limite) ? _data.reduce((a, b) {
              if ( a['peso'] < b['peso'] )
                return a;
              else 
                return b;
            })['peso'] - 2.0 :
            _data.sublist(limite).reduce((a, b) {
              if ( a['peso'] < b['peso'] )
                return a;
              else 
                return b;
            })['peso'] - 2.0,
      lineBarsData: linesBarData1(),
    );
  }

  

  List<LineChartBarData> linesBarData1() {

    var alpha = _data.length * _data.reduce((a, b) => { 'r' : a['index'] * a['peso'] + b['index'] * b['peso'] })['r'];
    var betha = _data.reduce((a, b) => { 'r' : a['index'] + b['index'] })['r'] * _data.reduce((a, b) => { 'r' : a['peso'] + b['peso'] })['r']; 
    var ghama = _data.length * _data.reduce((a, b) => { 'r' : a['index'] * a['index'] + b['index'] * b['index'] })['r'];
    var theta = _data.reduce((a, b) => { 'r' : a['index'] + b['index']})['r'] * _data.reduce((a, b) => { 'r' : a['index'] + b['index']})['r'];

    var medX  = _data.reduce((a, b) => { 'r' : a['index'] + b['index']})['r'] / _data.length;
    var medY  = _data.reduce((a, b) => { 'r' : a['peso'] + b['peso']})['r'] / _data.length;

    var a = ( alpha - betha ) / ( ghama - theta );
    var b = medY - a * medX;


    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: (_data.length <= limite) ? _data.map((Map<String,dynamic> item ) => 
          FlSpot(
            item['index'].toDouble(), 
            item['peso']),
        ).toList()
        : _data.sublist(limite).map((Map<String,dynamic> item ) => 
          FlSpot(
            item['index'].toDouble(), 
            item['peso']),
        ).toList(),
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 2.8),
        FlSpot(7, 1.2),
        FlSpot(10, 2.8),
        FlSpot(12, 2.6),
        FlSpot(13, 3.9),
      ],
      isCurved: true,
      colors: [
        const Color(0xffaa4cfc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );
    final LineChartBarData lineChartBarData3 = LineChartBarData(
      spots: [
        FlSpot(1, 2.8),
        FlSpot(3, 1.9),
        FlSpot(6, 3),
        FlSpot(10, 1.3),
        FlSpot(13, 2.5),
      ],
      isCurved: true,
      colors: const [
        Color(0xff27b6fc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
      lineChartBarData2,
      lineChartBarData3,
    ];
  }

}
