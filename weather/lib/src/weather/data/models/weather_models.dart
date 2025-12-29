/// Lớp đại diện cho phản hồi từ API thời tiết
class WeatherResponse {
  /// Dữ liệu thời tiết hiện tại
  final CurrentWeather currentWeather;

  /// Constructor nhận thời tiết hiện tại
  WeatherResponse({required this.currentWeather});

  /// Factory để tạo đối tượng từ JSON
  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    /// Trả về đối tượng WeatherResponse với dữ liệu thời tiết được parse từ JSON
    return WeatherResponse(
      /// Lấy 'current_weather' từ JSON (nếu null thì dùng map rỗng)
      currentWeather: CurrentWeather.fromJson(
        (json['current_weather'] as Map<String, dynamic>?) ?? const {},
      ),
    );
  }
}

/// Lớp đại diện cho dữ liệu thời tiết hiện tại
class CurrentWeather {
  /// Nhiệt độ hiện tại (tính bằng độ)
  final double temperature;

  /// Mã thời tiết (dùng để xác định tình trạng thời tiết)
  final double weatherCode;

  /// Constructor nhận nhiệt độ và mã thời tiết
  CurrentWeather({required this.temperature, required this.weatherCode});

  /// Factory để tạo đối tượng từ JSON
  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    /// Trả về đối tượng CurrentWeather với giá trị được parse từ JSON
    return CurrentWeather(
      /// Lấy 'temperature' từ JSON, nếu null dùng 0, rồi chuyển thành double
      temperature: ((json['temperature'] as num?) ?? 0).toDouble(),

      /// Lấy 'weathercode' từ JSON, nếu null dùng 0, rồi chuyển thành double
      weatherCode: ((json['weathercode'] as num?) ?? 0).toDouble(),
    );
  }
}
