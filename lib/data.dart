import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class Data {

  List<List<dynamic>> rowsAsListOfValues = [];

  List<Map<String,dynamic>> _data = [];

  List<Map<String,dynamic>> getData () {
    return _data;
  }

  Future<dynamic> fetchData () async {
    final response = await http.get("https://docs.google.com/spreadsheet/ccc?key=1AdN0lmke6nHZO-g3-xH8laX_s7cdKbxXNEmtUxsIp2o&output=csv");
    if (response.statusCode == 200) {
      return response.body.toString();
    } else {
      throw Exception("Falha no download dos dados");
    }
  }

  Future<List<Map<String,dynamic>>> prepareToServe () async {
    return fetchData().then((result) {
      rowsAsListOfValues = const CsvToListConverter().convert(result);
      List<List<dynamic>> resultado = rowsAsListOfValues
        .where((element) { 
          if ( element.length > 2 ) {
            return element[2].runtimeType.toString() == 'double';
          }
          return false;
        })
        .toList();

      for ( int i = 0; i < resultado.length; i++) {
        // print(resultado[i].toString());
        _data.add(
          {
            'index' : resultado[i][0],
            'date'  : resultado[i][1],
            'peso'  : resultado[i][2],
            'tag'   : resultado[i][3],
          }
        );
      }
      return _data;
    });
  }

  Map<String, double> getParams () {
    
    double alpha = 0.0, betha = 0.0, ghama = 0.0, theta = 0.0, medX = 0.0, medY = 0.0;
    double sumX = 0.0, sumY = 0.0;

    for ( int i = 0; i < _data.length; i++ ) {
      sumX += _data[i]['index'];
      sumY += _data[i]['peso'];
      alpha += ( _data[i]['index'] * _data[i]['peso'] );
      ghama += ( _data[i]['index'] * _data[i]['index'] );
    }

    alpha *=  _data.length;
    betha =   sumX * sumY;
    ghama *=  _data.length;
    theta =   sumX * sumX;

    medX = sumX / _data.length;
    medY = sumY / _data.length;

    double a = ( alpha - betha ) / ( ghama - theta );
    double b = medY - a * medX;

    return {
      'a' : a,
      'b' : b
    };

  }

  Future<dynamic> getDataFromWeb () async {
    String url = "https://docs.google.com/spreadsheet/ccc?key=1AdN0lmke6nHZO-g3-xH8laX_s7cdKbxXNEmtUxsIp2o&output=csv";
    HttpClient client = new HttpClient();
    HttpClientRequest req = await client.getUrl(Uri.parse(url));
    HttpClientResponse res = await req.close();
    String result = '';
    res.transform(Utf8Decoder()).listen(( data ) {
      result += data;
    }).onDone(() { 
      write(result).then((value){
        return value;
      });
    });
  }

  Future<String> write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/wgt.csv');
    await file.writeAsString(text);
    return "ok";
  }

  Future<String> read() async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/wgt.csv');
      text = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
    }
    return text;
  }

}
