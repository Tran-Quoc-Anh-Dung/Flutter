part of 'weather_bloc.dart';

abstract class WeatherState
    extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props =>
      [];
}

class WeatherInitial
    extends WeatherState {
  const WeatherInitial();
}

class SearchLoading
    extends WeatherState {
  const SearchLoading();
}

class SearchSuccess
    extends WeatherState {
  final LocationResponse
      locationResponse;

  const SearchSuccess(
      this.locationResponse);

  @override
  List<Object?> get props =>
      [
        locationResponse
      ];
}

class SearchFailure
    extends WeatherState {
  final String
      message;

  const SearchFailure(
      this.message);

  @override
  List<Object?> get props =>
      [
        message
      ];
}

class WeatherLoading
    extends WeatherState {
  const WeatherLoading();
}

class WeatherSuccess
    extends WeatherState {
  final WeatherResponse
      weatherResponse;
  final String
      cityName;
  final double
      temperature;
  final double
      weatherCode;

  const WeatherSuccess({
    required this.weatherResponse,
    required this.cityName,
    required this.temperature,
    required this.weatherCode,
  });

  @override
  List<Object?> get props =>
      [
        weatherResponse,
        cityName,
        temperature,
        weatherCode
      ];
}

class WeatherFailure
    extends WeatherState {
  final String
      message;

  const WeatherFailure(
      this.message);

  @override
  List<Object?> get props =>
      [
        message
      ];
}
