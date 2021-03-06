import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;

class Data {

  final String _url = "https://docs.google.com/spreadsheet/ccc?key=1AdN0lmke6nHZO-g3-xH8laX_s7cdKbxXNEmtUxsIp2o&output=csv";

  List<List<dynamic>> rowsAsListOfValues = [];

  List<Map<String,dynamic>> _data = [];

  List<Map<String,dynamic>> getData () {
    return _data;
  }

  /**
   * Faz o download dos dados na internet;
   */
  Future<dynamic> fetchData () async {
    final response = await http.get(_url);
    if (response.statusCode == 200) {
      return response.body.toString();
    } else {
      throw Exception("Falha no download dos dados");
    }
  }

  /**
   * Carrega os dados em csv e faz parsing
   * para uma Lista;
   */
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

  /**
   * Calcula os parâmetros da regressão
   * linear a partir da fórmula:
   * 
   * a = [ n * ( Σ ( x_i * y_i ))] - [ Σ x_i * Σ y_i ]
   *     ----------------------------------------------
   *         [ n * ( Σ ( x_i^2 ))] - [( Σ x_i)^2 ]
   * 
   * b = avg(y) - a * avg(x)
   */
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
}
