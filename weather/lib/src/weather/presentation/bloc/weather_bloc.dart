// Import các package cần thiết
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

// Import các model từ data layer
import '../../data/models/location_models.dart';
import '../../data/models/weather_models.dart';

// Import repository từ domain layer
import '../../domain/repositories/weather_repository.dart';

// Import các part file
part 'weather_event.dart';
part 'weather_state.dart';

/// BLoC để quản lý logic thời tiết
/// Lớp này xử lý các events từ UI và emit states
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  /// Repository để lấy dữ liệu
  final WeatherRepository weatherRepository;

  /// Constructor với dependency injection
  /// Khởi tạo trạng thái ban đầu là WeatherInitial
  WeatherBloc({required this.weatherRepository})
      : super(const WeatherInitial()) {
    /// Đăng ký các event handlers
    on<SearchCityEvent>(_onSearchCity);
    on<FetchWeatherEvent>(_onFetchWeather);
    on<ClearSearchEvent>(_onClearSearch);
    on<FetchCurrentLocationEvent>(_onFetchCurrentLocation);
  }

  /// Xử lý event tìm kiếm thành phố
  /// Tham số [event]: chứa tên thành phố cần tìm
  /// Tham số [emit]: dùng để phát ra states mới
  Future<void> _onSearchCity(
    SearchCityEvent event,
    Emitter<WeatherState> emit,
  ) async {
    /// Phát loading state - UI sẽ hiển thị loading indicator
    emit(const SearchLoading());

    try {
      /// Gọi repository để tìm kiếm thành phố
      final result = await weatherRepository.searchCity(event.cityName);

      /// Nếu tìm được, phát success state với kết quả
      emit(SearchSuccess(result));
    } on Exception catch (e) {
      /// Nếu có exception, phát failure state với lỗi
      /// Xử lý error handling tốt hơn với các lỗi cụ thể
      final errorMessage = _parseError(e);
      emit(SearchFailure(errorMessage));
    }
  }

  /// Xử lý event lấy dữ liệu thời tiết
  /// Tham số [event]: chứa latitude, longitude, đơn vị nhiệt độ
  /// Tham số [emit]: dùng để phát ra states mới
  Future<void> _onFetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    /// Phát loading state - UI sẽ hiển thị loading indicator
    emit(const WeatherLoading());

    try {
      /// Gọi repository để lấy dữ liệu thời tiết
      final result = await weatherRepository.getWeatherByCoordinates(
        event.latitude,
        event.longitude,
        event.temperatureUnit,
      );

      /// Phát success state với dữ liệu thời tiết
      emit(WeatherSuccess(
        weatherResponse: result,
        cityName: event.cityName ?? 'Unknown',
        temperature: result.currentWeather.temperature,
        weatherCode: result.currentWeather.weatherCode,
      ));
    } on Exception catch (e) {
      /// Nếu có lỗi, phát failure state với lỗi chi tiết
      final errorMessage = _parseError(e);
      emit(WeatherFailure(errorMessage));
    }
  }

  /// Xử lý event xóa kết quả tìm kiếm
  /// Trả về trạng thái khởi tạo
  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<WeatherState> emit,
  ) async {
    /// Phát trạng thái khởi tạo
    emit(const WeatherInitial());
  }

  /// Xử lý event lấy vị trí hiện tại của user
  /// Sử dụng geolocator package
  Future<void> _onFetchCurrentLocation(
    FetchCurrentLocationEvent event,
    Emitter<WeatherState> emit,
  ) async {
    /// Phát loading state
    emit(const WeatherLoading());

    try {
      /// Kiểm tra quyền truy cập vị trí
      LocationPermission permission = await Geolocator.checkPermission();

      /// Nếu chưa cấp quyền, yêu cầu cấp quyền
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      /// Nếu vẫn không cấp quyền, phát failure state
      if (permission == LocationPermission.deniedForever) {
        emit(const WeatherFailure('Vui lòng cấp quyền truy cập vị trí'));
        return;
      }

      /// Lấy vị trí hiện tại
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      /// Gọi API lấy dữ liệu thời tiết
      final result = await weatherRepository.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
        'celsius',
      );

      /// Phát success state
      emit(WeatherSuccess(
        weatherResponse: result,
        cityName: 'Vị trí hiện tại',
        temperature: result.currentWeather.temperature,
        weatherCode: result.currentWeather.weatherCode,
      ));
    } on Exception catch (e) {
      /// Xử lý lỗi
      final errorMessage = _parseError(e);
      emit(WeatherFailure(errorMessage));
    }
  }

  /// Hàm để parse error message thành chuỗi dễ đọc
  /// Tham số [exception]: exception cần parse
  /// Trả về: chuỗi lỗi thân thiện với user
  String _parseError(Exception exception) {
    /// Nếu là SocketException, có thể là lỗi kết nối
    if (exception.toString().contains('SocketException')) {
      return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet.';
    }

    /// Nếu là TimeoutException, API không phản hồi kịp
    if (exception.toString().contains('TimeoutException')) {
      return 'Yêu cầu hết thời gian chờ. Vui lòng thử lại.';
    }

    /// Nếu là FormatException, JSON không hợp lệ
    if (exception.toString().contains('FormatException')) {
      return 'Dữ liệu không hợp lệ. Vui lòng thử lại.';
    }

    /// Nếu không tìm được thành phố
    if (exception.toString().contains('404')) {
      return 'Không tìm thấy thành phố. Vui lòng thử tên khác.';
    }

    /// Lỗi mặc định
    return 'Có lỗi xảy ra: ${exception.toString()}';
  }
}
