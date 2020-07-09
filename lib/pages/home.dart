import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wgmon/data.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  Data dtObj;

  @override
  void initState() {
    dtObj = Data();
    super.initState();
  }

  Future<dynamic> fetchData () async {
    final response = await http.get("https://docs.google.com/spreadsheet/ccc?key=1AdN0lmke6nHZO-g3-xH8laX_s7cdKbxXNEmtUxsIp2o&output=csv");
    if (response.statusCode == 200) {
      return response.body.toString();
    } else {
      throw Exception("Falha no download dos dados");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2c274c),
      drawerScrimColor: Color(0xff2c274c),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: dtObj.prepareToServe(),
            builder: ( context, snapshot ) {
              if ( snapshot.hasData ) {
                return WeightChart(dtObjt: dtObj);
              }
              if ( snapshot.hasError ) {
                return Center(child: Text('Um erro ocorreu no carregamento dos dados'));
              }
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator()
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}

class WeightChart extends StatefulWidget {

  final Data dtObjt;

  const WeightChart({
    Key key,
    @required this.dtObjt
  }) : super(key: key);

  @override
  _WeightChartState createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {

  List<Map<String, dynamic>> _data;

  bool _barAreaReal = false;
  bool _barAreaPred = false;

  int _counter = 0;

  Data dtObj;

  final int limite = 50;
  final int offset = 10;

  @override
  void initState() {
    dtObj = widget.dtObjt;
    _data = dtObj.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.65,
      child: Container(
        padding: EdgeInsets.only(bottom: 15, top: 15),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Tooltip(
                    message: 'Mostrar/Esconder área do gráfico',
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          if (_counter == 0) {
                            _barAreaReal = false;
                            _barAreaPred = false;
                          } else if ( _counter == 1 ) {
                            _barAreaReal = true;
                            _barAreaPred = false;
                          } else if ( _counter == 2 ) {
                            _barAreaReal = false;
                            _barAreaPred = true;
                          } else {
                            _barAreaReal = true;
                            _barAreaPred = true;
                          }
                          _counter = ( _counter + 1 ) % 4;
                        });
                      },
                    ),
                  ),
                )
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
            _data.sublist(_data.length - limite).reduce((a, b) {
              if ( a['index'] < b['index'] )
                return a;
              else 
                return b;
            })['index'] + 0.0,
      maxX: ((_data.length <= limite) ? _data.reduce((a, b) {
              if ( a['index'] > b['index'] )
                return a;
              else 
                return b;
            })['index'] + 0.0 :
            _data.sublist(_data.length - limite).reduce((a, b) {
              if ( a['index'] > b['index'] )
                return a;
              else 
                return b;
            })['index'] + 0.0 ) + offset,
      maxY: (_data.length <= limite) ? _data.reduce((a, b) {
              if ( a['peso'] > b['peso'] )
                return a;
              else 
                return b;
            })['peso'] + 2.0 :
            _data.sublist(_data.length - limite).reduce((a, b) {
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
            _data.sublist(_data.length - limite).reduce((a, b) {
              if ( a['peso'] < b['peso'] )
                return a;
              else 
                return b;
            })['peso'] - 2.0,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {

    Map<String, double> params = dtObj.getParams();
    List<FlSpot> dataList = [];
    
    for ( int i = 1; i <= ( _data.length + offset ); i++ )  {
      dataList.add(FlSpot(
        i.toDouble(),
        params['a'] * i + params['b']
      ));
    }

    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: (_data.length <= limite) ? _data.map((Map<String,dynamic> item ) => 
          FlSpot(
            item['index'].toDouble(), 
            item['peso']),
        ).toList()
        : _data.sublist(_data.length - limite).map((Map<String,dynamic> item ) => 
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
        show: _barAreaReal,
        colors: [
          const Color(0xff4af699).withOpacity(0.1)
        ]
      ),
    );
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: (dataList.length <= ( limite + offset )) ?
        dataList :
        dataList.sublist(_data.length - limite ),
      isCurved: true,
      colors: [
        const Color(0xffaa4cfc),
      ],
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: _barAreaPred,
        colors: [
          const Color(0xffaa4cfc).withOpacity(0.1),
        ]
      ),
    );
    return [
      lineChartBarData1,
      lineChartBarData2,
    ];
  }
}
