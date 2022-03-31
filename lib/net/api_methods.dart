//https://api.coingecko.com/api/v3/coins
import 'dart:convert';
import 'package:http/http.dart' as http;


Future<double> getPrice(String id) async {
  try{
    var url = 'http://api.coingecko.com/api/v3/coins/' + id;
    http.Response response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var value =json['market_data']['current_price']['usd'].toString();
    return double.parse(value);
  }catch (e) {
    print(e.toString());
    return 0.0;
  }
}