class WeatherModel {
  final String cityName;
  final String date;
  final String? image;
  final double temp;
  final double maxTemp;
  final double minTemp;
  final String weatherCondition;
  final List<ForecastDay> forecastDays;

  WeatherModel({
    required this.cityName,
    required this.date,
    this.image,
    required this.temp,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCondition,
    required this.forecastDays,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json){
    // Parse forecast days
    List<ForecastDay> forecastDays = [];
    if (json['forecast'] != null &&
        json['forecast']['forecastday'] != null) {
      final forecastData = json['forecast']['forecastday'] as List;
      // Skip the first day (today) as we already have that data
      for (int i = 1; i < forecastData.length; i++) {
        forecastDays.add(ForecastDay.fromJson(forecastData[i]));
      }
    }

    return WeatherModel(
      cityName: json['location']['name'],
      date: json['current']['last_updated'],
      temp: json['forecast']['forecastday'][0]['day']['avgtemp_c'],
      maxTemp: json['forecast']['forecastday'][0]['day']['maxtemp_c'],
      minTemp: json['forecast']['forecastday'][0]['day']['mintemp_c'],
      weatherCondition: json['forecast']['forecastday'][0]['day']['condition']['text'],
      image: json['forecast']['forecastday'][0]['day']['condition']['icon'],
      forecastDays: forecastDays,
    );
  }
}

class ForecastDay {
  final String date;
  final double maxTemp;
  final double minTemp;
  final double avgTemp;
  final String condition;
  final String? iconUrl;

  ForecastDay({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.avgTemp,
    required this.condition,
    this.iconUrl,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      maxTemp: json['day']['maxtemp_c'],
      minTemp: json['day']['mintemp_c'],
      avgTemp: json['day']['avgtemp_c'],
      condition: json['day']['condition']['text'],
      iconUrl: json['day']['condition']['icon'],
    );
  }
}