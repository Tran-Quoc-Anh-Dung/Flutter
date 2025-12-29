// Utility để map mã thời tiết thành icon và mô tả
import 'package:flutter/material.dart';

/// Lớp để ánh xạ mã thời tiết (từ API) thành icon và mô tả
/// Tham khảo: https://www.open-meteo.com/en/docs
class WeatherCodeMapper {
  /// Map weather code thành IconData
  /// Tham số [weatherCode]: mã thời tiết từ API
  /// Trả về: IconData tương ứng với mã thời tiết
  static IconData getWeatherIcon(double weatherCode) {
    final code = weatherCode.toInt();

    switch (code) {
      // 0: Trong lành
      case 0:
        return Icons.wb_sunny;

      // 1, 2, 3: Có mây
      case 1:
      case 2:
      case 3:
        return Icons.wb_cloudy;

      // 45, 48: Sương mù
      case 45:
      case 48:
        return Icons.cloud_queue;

      // 51-67: Mưa
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
      case 71:
      case 73:
      case 75:
      case 80:
      case 81:
      case 82:
        return Icons.grain;

      // 85, 86: Mưa tuyết
      case 85:
      case 86:
        return Icons.ac_unit;

      // 95, 96, 99: Giông
      case 95:
      case 96:
      case 99:
        return Icons.flash_on;

      // Mặc định: Mây
      default:
        return Icons.cloud;
    }
  }

  /// Map weather code thành mô tả text
  /// Tham số [weatherCode]: mã thời tiết từ API
  /// Trả về: Mô tả tiếng Việt của thời tiết
  static String getWeatherDescription(double weatherCode) {
    final code = weatherCode.toInt();

    switch (code) {
      case 0:
        return 'Trong lành';
      case 1:
        return 'Chủ yếu trong lành';
      case 2:
        return 'Phần lớn có mây';
      case 3:
        return 'Có mây';
      case 45:
        return 'Sương mù';
      case 48:
        return 'Sương giá';
      case 51:
        return 'Mưa nhẹ';
      case 53:
        return 'Mưa vừa';
      case 55:
        return 'Mưa nặng';
      case 61:
        return 'Mưa nhẹ';
      case 63:
        return 'Mưa vừa';
      case 65:
        return 'Mưa nặng';
      case 71:
        return 'Tuyết nhẹ';
      case 73:
        return 'Tuyết vừa';
      case 75:
        return 'Tuyết nặng';
      case 80:
        return 'Mưa rải rác nhẹ';
      case 81:
        return 'Mưa rải rác vừa';
      case 82:
        return 'Mưa rải rác nặng';
      case 85:
        return 'Mưa tuyết nhẹ';
      case 86:
        return 'Mưa tuyết nặng';
      case 95:
        return 'Giông (nhẹ hoặc vừa)';
      case 96:
        return 'Giông với mưa đá nhẹ';
      case 99:
        return 'Giông với mưa đá nặng';
      default:
        return 'Không xác định';
    }
  }

  /// Map weather code thành màu sắc
  /// Tham số [weatherCode]: mã thời tiết từ API
  /// Trả về: Màu sắc tương ứng
  static Color getWeatherColor(double weatherCode) {
    final code = weatherCode.toInt();

    switch (code) {
      // Trong lành: vàng
      case 0:
        return Colors.amber;

      // Có mây: xám
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
        return Colors.grey;

      // Mưa: xanh dương
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return Colors.blue;

      // Tuyết: xanh dương nhạt
      case 71:
      case 73:
      case 75:
      case 85:
      case 86:
        return Colors.lightBlue;

      // Giông: tím
      case 95:
      case 96:
      case 99:
        return Colors.purple;

      // Mặc định
      default:
        return Colors.grey;
    }
  }
}
