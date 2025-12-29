part of 'weather_bloc.dart';

/// Abstract class đại diện cho các sự kiện (events)
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

/// Event tìm kiếm thành phố
class SearchCityEvent extends WeatherEvent {
  /// Tên thành phố cần tìm
  final String cityName;

  const SearchCityEvent(this.cityName);

  @override
  List<Object?> get props => [cityName];
}

/// Event lấy dữ liệu thời tiết
class FetchWeatherEvent extends WeatherEvent {
  /// Vĩ độ của địa điểm
  final double latitude;

  /// Kinh độ của địa điểm
  final double longitude;

  /// Đơn vị nhiệt độ (celsius/fahrenheit)
  final String? temperatureUnit;

  /// Tên thành phố (để hiển thị trên UI)
  final String? cityName;

  const FetchWeatherEvent({
    required this.latitude,
    required this.longitude,
    this.temperatureUnit,
    this.cityName,
  });

  @override
  List<Object?> get props => [latitude, longitude, temperatureUnit, cityName];
}

/// Event xóa kết quả tìm kiếm
class ClearSearchEvent extends WeatherEvent {
  const ClearSearchEvent();
}

/// Event lấy vị trí hiện tại của user
class FetchCurrentLocationEvent extends WeatherEvent {
  const FetchCurrentLocationEvent();
}
