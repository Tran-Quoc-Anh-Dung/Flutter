// Import các data model từ data layer
import '../../data/models/location_models.dart';
import '../../data/models/weather_models.dart';

/// Abstract class định nghĩa các hợp đồng (contract) cho repository
/// Lớp này tuân theo Repository Pattern - là lớp trung gian giữa domain và data layer
/// Mục đích: tách biệt logic kinh doanh khỏi chi tiết cài đặt dữ liệu
abstract class WeatherRepository {
  /// Phương thức abstract để tìm kiếm thành phố theo tên
  /// Tham số [name]: tên thành phố cần tìm
  /// Trả về: Future chứa LocationResponse (danh sách kết quả tìm kiếm)
  /// Ghi chú: Lớp con phải cài đặt phương thức này
  Future<LocationResponse> searchCity(String name);

  /// Phương thức abstract để lấy dữ liệu thời tiết theo tọa độ
  /// Tham số [latitude]: vĩ độ của địa điểm (ví dụ: 21.0285 cho Hà Nội)
  /// Tham số [longitude]: kinh độ của địa điểm (ví dụ: 105.8542 cho Hà Nội)
  /// Tham số [temperatureUnit]: đơn vị nhiệt độ - có thể null (mặc định là celsius)
  /// Trả về: Future chứa WeatherResponse (dữ liệu thời tiết hiện tại)
  /// Ghi chú: Lớp con phải cài đặt phương thức này
  Future<WeatherResponse> getWeatherByCoordinates(
    double latitude,
    double longitude,
    String? temperatureUnit,
  );
}
