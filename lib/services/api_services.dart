import 'package:weatherly/models/current_weather_model.dart';
import 'package:weatherly/models/hourly_weather_model.dart';

import '../consts/strings.dart';
import 'package:http/http.dart' as http;

getCurrentWeather(city) async {
  var link =
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";
  print(link);
  var res = await http.get(Uri.parse(link));
  if (res.statusCode == 200) {
    var data = currentWeatherDataFromJson(res.body.toString());

    return data;
  }
}

getHourlyWeather(city) async {
  var link =
      "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric";
  var res = await http.get(Uri.parse(link));
  if (res.statusCode == 200) {
    var data = hourlyWeatherDataFromJson(res.body.toString());

    return data;
  }
}
