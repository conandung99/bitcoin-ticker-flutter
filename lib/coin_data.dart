import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const kCoinAPIKey = 'YOUR-API-KEY';
const baseCoinUrl = 'rest.coinapi.io';

class CoinData {
  Future<dynamic> getCoinData({String from, String to}) async {
    Uri uri = Uri.https(baseCoinUrl, '/v1/exchangerate/$from/$to');
    try {
      var response =
          await http.get(uri, headers: {'X-CoinAPI-Key': kCoinAPIKey});
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        print('getSpecificRate error ${response.statusCode}');
      }
    } on Exception catch (e) {
      print('getSpecificRate exception: $e');
    }
  }
}
