class Data {

  List<Map<String,dynamic>> _data = [
    { 'index' : 1,	'date' : '18/05/2020', 'peso' :	105.000, 'tag' :	'BD' },
    { 'index' : 2,	'date' : '20/05/2020', 'peso' :	105.100, 'tag' :	'BD' },
    { 'index' : 3,	'date' : '22/05/2020', 'peso' :	105.100, 'tag' :	'BD' },
    { 'index' : 4,	'date' : '23/05/2020', 'peso' :	105.500, 'tag' :	'BD' },
    { 'index' : 5,	'date' : '24/05/2020', 'peso' :	105.500, 'tag' :	'BD' },
    { 'index' : 6,	'date' : '25/05/2020', 'peso' :	105.400, 'tag' :	'BD' },
    { 'index' : 7,	'date' : '26/05/2020', 'peso' :	104.900, 'tag' :	'BD' },
    { 'index' : 8,	'date' : '27/05/2020', 'peso' :	105.800, 'tag' :	'AD' },
    { 'index' : 9,	'date' : '28/05/2020', 'peso' :	104.800, 'tag' :	'BD' },
    { 'index' : 10,	'date' : '29/05/2020', 'peso' :	104.900, 'tag' :	'BD' },
    { 'index' : 11,	'date' : '30/05/2020', 'peso' :	104.500, 'tag' :	'BD' },
    { 'index' : 12,	'date' : '31/05/2020', 'peso' :	104.300, 'tag' :	'BD' },
    { 'index' : 13,	'date' : '01/06/2020', 'peso' :	105.000, 'tag' :	'BD' },
    { 'index' : 14,	'date' : '02/06/2020', 'peso' :	105.100, 'tag' :	'BD' },
    { 'index' : 15,	'date' : '03/06/2020', 'peso' :	104.500, 'tag' :	'BD' },
    { 'index' : 16,	'date' : '04/06/2020', 'peso' :	102.800, 'tag' :	'BD' },
    { 'index' : 17,	'date' : '05/06/2020', 'peso' :	103.700, 'tag' :	'BD' },
    { 'index' : 18,	'date' : '06/06/2020', 'peso' :	104.600, 'tag' :	'BD' },
    { 'index' : 19,	'date' : '07/06/2020', 'peso' :	104.000, 'tag' :	'BD' },
    { 'index' : 20,	'date' : '08/06/2020', 'peso' :	103.800, 'tag' :	'BD' },
    { 'index' : 21,	'date' : '09/06/2020', 'peso' :	105.400, 'tag' :	'AD' },
    { 'index' : 22,	'date' : '10/06/2020', 'peso' :	103.900, 'tag' :	'BD' },
    { 'index' : 23,	'date' : '11/06/2020', 'peso' :	103.200, 'tag' :	'BD' },
    { 'index' : 24,	'date' : '12/06/2020', 'peso' :	104.200, 'tag' :	'BD' },
    { 'index' : 25,	'date' : '13/06/2020', 'peso' :	104.100, 'tag' :	'BD' },
    { 'index' : 26,	'date' : '14/06/2020', 'peso' :	103.400, 'tag' :	'BD' },
    { 'index' : 27,	'date' : '15/06/2020', 'peso' :	103.600, 'tag' :	'BD' },
    { 'index' : 28,	'date' : '16/06/2020', 'peso' :	103.300, 'tag' :	'BD' },
    { 'index' : 29,	'date' : '17/06/2020', 'peso' :	103.300, 'tag' :	'BD' },
    { 'index' : 30,	'date' : '18/06/2020', 'peso' :	102.900, 'tag' :	'BD' },
    { 'index' : 31,	'date' : '19/06/2020', 'peso' :	103.400, 'tag' :	'BD' },
    { 'index' : 32,	'date' : '20/06/2020', 'peso' :	103.500, 'tag' :	'BD' },
    { 'index' : 33,	'date' : '21/06/2020', 'peso' :	103.600, 'tag' :	'BD' },
    { 'index' : 34,	'date' : '22/06/2020', 'peso' :	103.000, 'tag' :	'BD' },
    { 'index' : 35,	'date' : '23/06/2020', 'peso' :	103.600, 'tag' :	'BD' },
    { 'index' : 36,	'date' : '24/06/2020', 'peso' :	103.500, 'tag' :	'BD' },
    { 'index' : 37,	'date' : '25/06/2020', 'peso' :	102.700, 'tag' :	'BD' },
    { 'index' : 38,	'date' : '26/06/2020', 'peso' :	103.400, 'tag' :	'BD' },
    { 'index' : 39,	'date' : '27/06/2020', 'peso' :	103.300, 'tag' :	'BD' },
  ];

  List<Map<String,dynamic>> getData () {
    return _data;
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

}
