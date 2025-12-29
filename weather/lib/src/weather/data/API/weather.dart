import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/weather_models.dart';

part 'weather.g.dart';

@RestApi(baseUrl: 'https://api.open-meteo.com/')
abstract class WeatherApi {
  factory WeatherApi(Dio dio, {String baseUrl}) = _WeatherApi;

  @GET('/v1/forecast')
  Future<WeatherResponse> getCurrentWeather(
    @Query('latitude') double latitude,
    @Query('longitude') double longitude,
    @Query('current_weather') bool currentWeather,
    @Query('temperature_unit') String? temperatureUnit,
  );
}
