import 'package:weatherapp/Models/weather_model.dart';

class WeatherStates{}
class InitialState extends WeatherStates{}
class WeatherLoadingState extends WeatherStates{}
class WeatherLoadState extends WeatherStates{
    final WeatherModel weatherModel ;

  WeatherLoadState(this.weatherModel);
}
class WeatherFailureState extends WeatherStates{}