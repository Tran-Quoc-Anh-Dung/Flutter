// Import thư viện Dio để gọi HTTP
import 'package:dio/dio.dart';

// Thư viện Retrofit giúp tự sinh code API từ interface
import 'package:retrofit/retrofit.dart';

// Model dùng để ánh xạ dữ liệu JSON trả về từ API
import '../models/location_models.dart';

// Khai báo rằng file này có phần code sinh tự động đi kèm
// Build Runner sẽ tạo file location.g.dart
part 'location.g.dart';

// Đánh dấu class này là một REST API Client
// baseUrl là địa chỉ API gốc (mặc định)
@RestApi(baseUrl: 'https://geocoding-api.open-meteo.com/')
abstract class GeocodingApi {
  // Constructor dạng factory
  // Retrofit sẽ generate (tự tạo) class _GeocodingApi trong file *.g.dart
  // và class đó sẽ triển khai (implement) GeocodingApi
  factory GeocodingApi(Dio dio, {String baseUrl}) = _GeocodingApi;

  // Gửi request HTTP GET đến endpoint /v1/search
  @GET('/v1/search')
  Future<LocationResponse> searchCity(
    // Tham số truy vấn (query param) ?name=...
    // Dùng để truyền tên thành phố cần tìm
    @Query('name') String name,

    // Tham số truy vấn (query param) ?count=...
    // Dùng để giới hạn số lượng kết quả trả về
    @Query('count') int count,
  );
}
