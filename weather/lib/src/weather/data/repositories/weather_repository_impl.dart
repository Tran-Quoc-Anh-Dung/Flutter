// Import các lớp từ domain layer cho repository pattern
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/repositories/weather_repository.dart';

// Import các API client
import '../api/location.dart';
import '../api/weather.dart';

// Import các data model
import '../models/location_models.dart';
import '../models/weather_models.dart';

/// Lớp cài đặt WeatherRepository
/// Lớp này chịu trách nhiệm gọi API, cache dữ liệu và xử lý dữ liệu thời tiết
class WeatherRepositoryImpl extends WeatherRepository {
  /// API client để gọi các endpoint về thời tiết
  final WeatherApi weatherApi;

  /// API client để gọi các endpoint về địa danh
  final GeocodingApi geocodingApi;

  /// SharedPreferences - dùng để cache dữ liệu
  final SharedPreferences sharedPreferences;

  /// Constructor nhận hai API client và SharedPreferences
  WeatherRepositoryImpl({
    required this.weatherApi,
    required this.geocodingApi,
    required this.sharedPreferences,
  });

  /// Key để cache danh sách kết quả tìm kiếm
  static const String _searchCacheKey = 'search_results_cache';

  /// Key để cache dữ liệu thời tiết
  static const String _weatherCacheKey = 'weather_cache_';

  /// Hàm tìm kiếm thành phố theo tên
  /// Tham số [name]: tên thành phố cần tìm
  /// Trả về: danh sách các kết quả tìm kiếm
  /// Ghi chú: Nếu có lỗi API, sẽ cố gắng trả về dữ liệu từ cache
  @override
  Future<LocationResponse> searchCity(String name) async {
    try {
      /// Gọi API geocoding để tìm kiếm thành phố
      /// Tham số thứ hai là số kết quả tối đa (10)
      final result = await geocodingApi.searchCity(name, 10);

      /// Cache kết quả tìm kiếm vào SharedPreferences
      final jsonString = jsonEncode(
        result.results
            .map((r) => {
                  'id': r.id,
                  'name': r.name,
                  'latitude': r.latitude,
                  'longitude': r.longitude,
                })
            .toList(),
      );
      await sharedPreferences.setString(_searchCacheKey, jsonString);

      /// Trả về kết quả từ API
      return result;
    } catch (e) {
      /// Nếu API lỗi, cố gắng lấy dữ liệu từ cache
      final cachedData = sharedPreferences.getString(_searchCacheKey);
      if (cachedData != null) {
        try {
          final jsonList = jsonDecode(cachedData) as List;
          final results = jsonList
              .map((item) => LocationResult(
                    id: item['id'] as int,
                    name: item['name'] as String,
                    latitude: item['latitude'] as double,
                    longitude: item['longitude'] as double,
                  ))
              .toList();
          return LocationResponse(results: results);
        } catch (_) {
          /// Nếu không thể parse cache, ném lỗi gốc
          rethrow;
        }
      }

      /// Nếu không có lỗi, ném lỗi ra ngoài để lớp gọi xử lý
      rethrow;
    }
  }

  /// Hàm lấy dữ liệu thời tiết theo tọa độ
  /// Tham số [latitude]: vĩ độ của địa điểm
  /// Tham số [longitude]: kinh độ của địa điểm
  /// Tham số [temperatureUnit]: đơn vị nhiệt độ (celsius/fahrenheit)
  /// Trả về: dữ liệu thời tiết hiện tại
  /// Ghi chú: Cache dữ liệu lại để sử dụng khi API lỗi
  @override
  Future<WeatherResponse> getWeatherByCoordinates(
    double latitude,
    double longitude,
    String? temperatureUnit,
  ) async {
    /// Tạo key cache duy nhất dựa trên tọa độ
    final cacheKey = '${_weatherCacheKey}_${latitude}_$longitude';

    try {
      /// Gọi API thời tiết để lấy dữ liệu
      final result = await weatherApi.getCurrentWeather(
        /// Vĩ độ
        latitude,

        /// Kinh độ
        longitude,

        /// Tham số currentWeather = true (lấy thời tiết hiện tại)
        true,

        /// Đơn vị nhiệt độ, mặc định là 'celsius' nếu không truyền
        temperatureUnit ?? 'celsius',
      );

      /// Cache kết quả vào SharedPreferences
      final jsonString = jsonEncode({
        'temperature': result.currentWeather.temperature,
        'weatherCode': result.currentWeather.weatherCode,
      });
      await sharedPreferences.setString(cacheKey, jsonString);

      /// Trả về kết quả từ API
      return result;
    } catch (e) {
      /// Nếu API lỗi, cố gắng lấy dữ liệu từ cache
      final cachedData = sharedPreferences.getString(cacheKey);
      if (cachedData != null) {
        try {
          final jsonData = jsonDecode(cachedData) as Map<String, dynamic>;
          return WeatherResponse(
            currentWeather: CurrentWeather(
              temperature: jsonData['temperature'] as double,
              weatherCode: jsonData['weatherCode'] as double,
            ),
          );
        } catch (_) {
          /// Nếu không thể parse cache, ném lỗi gốc
          rethrow;
        }
      }

      /// Nếu không có cache, ném lỗi ra ngoài để lớp gọi xử lý
      rethrow;
    }
  }
}
