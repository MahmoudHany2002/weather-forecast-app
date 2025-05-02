import 'package:dio/dio.dart';
import 'package:weatherapp/Models/weather_model.dart';

class WeatherServices {
  final Dio dio;
  final String baseUrl = 'http://api.weatherapi.com/v1';
  final String apiKey = '4cc2a16b4b0c4e4cbcf11143252804';

  WeatherServices(this.dio);

  Future<WeatherModel> getCurrentWeather({required String cityName}) async {
    try {
      // Fetch 3 days of forecast data (today + 2 more days)
      Response response = await dio.get(
        '$baseUrl/forecast.json?key=$apiKey&q=$cityName&days=3',
      );

      WeatherModel weatherModel = WeatherModel.fromJson(response.data);
      return weatherModel;
    } on DioException catch (e) {
      final String errorMessage = e.response?.data['error']['message'] ??
          "Oops! There was an error. Please try again later.";
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Oops! There was an error. Please try again later.");
    }
  }
}