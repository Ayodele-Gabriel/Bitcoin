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
  'NGN',
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

const apiKey = '830E3F23-EDF9-4C8F-8273-F933551E5CA1';
const coinApiUrl = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  Future<dynamic> getCoinData(String pickedCurrency) async {
    Map<String, String> cryptoPrice = {};

    for (String crypto in cryptoList) {
      String url = '$coinApiUrl/$crypto/$pickedCurrency?apikey=$apiKey';
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var decodeData = jsonDecode(response.body);
        //var currency = decodeData['asset_id_quote'];
        var lastPrice = decodeData['rate'];
        cryptoPrice[crypto] = lastPrice.toStringAsFixed(0);
        // print(currency);
        // print(cryptoPrice);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrice;
  }
}
