
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/Models/weather_model.dart';
import 'package:weatherapp/cubits/get_weather_cubit/get_weather_states.dart';
import 'package:weatherapp/services/weather_services.dart';


class GetWeatherCubit extends Cubit <WeatherStates> {
  GetWeatherCubit() : super(InitialState());

  Future<void> getWeather({required String cityName}) async {
    try {
      // Emit loading state to indicate that data is being fetched
      emit(WeatherLoadingState());

      // Get weather data
      WeatherModel weatherModel = await WeatherServices(Dio())
          .getCurrentWeather(cityName: cityName);

      // Emit success state with the weather model
      emit(WeatherLoadState(weatherModel));
    } catch (e) {
      // Emit failure state if there's an error
      emit(WeatherFailureState());
    }
  }
}