/// Lớp đại diện cho phản hồi từ API geocoding
class LocationResponse {
  /// Danh sách các kết quả tìm kiếm địa điểm
  final List<LocationResult> results;

  /// Constructor nhận danh sách kết quả
  LocationResponse({required this.results});

  /// Factory để tạo đối tượng từ JSON
  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    /// Lấy danh sách results từ JSON, mặc định là danh sách rỗng nếu null
    final raw = (json['results'] as List?) ?? const [];

    /// Trả về đối tượng LocationResponse với danh sách LocationResult được parse từ JSON
    return LocationResponse(
      /// Map danh sách raw thành danh sách LocationResult bằng cách gọi fromJson cho mỗi phần tử
      results: raw
          .map((e) => LocationResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Lớp đại diện cho một kết quả tìm kiếm địa điểm
class LocationResult {
  /// Mã định danh của địa điểm
  final int id;

  /// Tên của địa điểm
  final String name;

  /// Vĩ độ của địa điểm
  final double latitude;

  /// Kinh độ của địa điểm
  final double longitude;

  /// Constructor nhận tất cả các tham số bắt buộc
  LocationResult({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  /// Factory để tạo đối tượng từ JSON
  factory LocationResult.fromJson(Map<String, dynamic> json) {
    /// Trả về đối tượng LocationResult với các giá trị được parse từ JSON
    return LocationResult(
      /// Lấy 'id' từ JSON, ép kiểu num rồi chuyển thành int
      id: (json['id'] as num).toInt(),

      /// Lấy 'name' từ JSON và ép kiểu thành String
      name: json['name'] as String,

      /// Lấy 'latitude' từ JSON, ép kiểu num rồi chuyển thành double
      latitude: (json['latitude'] as num).toDouble(),

      /// Lấy 'longitude' từ JSON, ép kiểu num rồi chuyển thành double
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
