// Import thư viện HTTP client
import 'package:dio/dio.dart';

// Import Flutter framework
import 'package:flutter/material.dart';

// Import thư viện state management
import 'package:flutter_bloc/flutter_bloc.dart';

// Import SharedPreferences cho caching
import 'package:shared_preferences/shared_preferences.dart';

// Import các API client cho gọi API
import 'src/weather/data/api/location.dart';
import 'src/weather/data/api/weather.dart';

// Import repository implementation
import 'src/weather/data/repositories/weather_repository_impl.dart';

// Import BLoC (Business Logic Component)
import 'src/weather/presentation/bloc/weather_bloc.dart';

// Import trang chính của ứng dụng
import 'src/weather/presentation/pages/weather_page.dart';

/// Hàm main - điểm khởi động của ứng dụng Flutter
void main() async {
  /// Khởi tạo SharedPreferences trước khi chạy app
  /// Điều này là bắt buộc vì SharedPreferences cần được khởi tạo async
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  /// Chạy ứng dụng MyApp với SharedPreferences
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

/// Widget gốc của ứng dụng - StatelessWidget
/// Lớp này thiết lập cấu trúc toàn ứng dụng
class MyApp extends StatelessWidget {
  /// SharedPreferences instance
  final SharedPreferences sharedPreferences;

  /// Constructor với super.key và SharedPreferences
  const MyApp({super.key, required this.sharedPreferences});

  /// Build method - xây dựng UI cho ứng dụng
  @override
  Widget build(BuildContext context) {
    // Tạo instance Dio - HTTP client
    final dio = Dio();

    // Tạo instance WeatherApi với Dio
    final weatherApi = WeatherApi(dio);

    // Tạo instance GeocodingApi với Dio
    final geocodingApi = GeocodingApi(dio);

    // Tạo instance repository và inject các API client + SharedPreferences
    final weatherRepository = WeatherRepositoryImpl(
      weatherApi: weatherApi,
      geocodingApi: geocodingApi,
      sharedPreferences: sharedPreferences,
    );

    // Trả về MaterialApp - ứng dụng Material Design
    return MaterialApp(
      // Tiêu đề ứng dụng
      title: 'Weather App',

      // Thiết lập theme cho ứng dụng
      theme: ThemeData(
        // Chọn màu scheme từ seed color
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),

        // Sử dụng Material Design 3
        useMaterial3: true,
      ),

      // Trang chính của ứng dụng
      home: BlocProvider(
        // Tạo WeatherBloc và inject repository
        create: (context) => WeatherBloc(weatherRepository: weatherRepository),

        // Child widget - trang hiển thị thời tiết
        child: const WeatherPage(),
      ),
    );
  }
}
