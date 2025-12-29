// Import Material Design widgets
import 'package:flutter/material.dart';

// Import flutter_bloc để quản lý state
import 'package:flutter_bloc/flutter_bloc.dart';

// Import các data models
import '../../data/models/location_models.dart';

// Import weather code mapper để lấy icon
import '../../data/utils/weather_code_mapper.dart';

// Import BLoC
import '../bloc/weather_bloc.dart';

/// Widget chính để hiển thị thời tiết
/// Là StatefulWidget để quản lý TextEditingController
class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

/// State class cho WeatherPage
class _WeatherPageState extends State<WeatherPage> {
  /// Controller để quản lý input text tìm kiếm
  final _searchController = TextEditingController();

  /// Tên thành phố được chọn
  String? _selectedCityName;

  /// Latitude và longitude của thành phố được chọn (để lấy geolocation)
  double? _selectedLatitude;
  double? _selectedLongitude;

  @override
  void dispose() {
    /// Giải phóng resources của TextEditingController
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// AppBar - thanh tiêu đề
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.blue.shade400,
        elevation: 0,
        actions: [
          /// Button để lấy vị trí hiện tại
          IconButton(
            icon: const Icon(Icons.location_on),
            tooltip: 'Lấy vị trí hiện tại',
            onPressed: () {
              /// Gửi event để lấy vị trí hiện tại
              context.read<WeatherBloc>().add(
                    const FetchCurrentLocationEvent(),
                  );
            },
          ),
        ],
      ),

      /// Body - nội dung chính
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              /// Phần tìm kiếm thành phố
              _buildSearchSection(),

              const SizedBox(height: 24),

              /// Phần hiển thị thông tin thời tiết
              _buildWeatherSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// Xây dựng phần tìm kiếm thành phố
  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Tiêu đề "Tìm kiếm thành phố"
        const Text(
          'Tìm kiếm thành phố',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        /// TextField để nhập tên thành phố
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Nhập tên thành phố',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),

            /// Icon tìm kiếm ở bên phải
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                if (_searchController.text.isNotEmpty) {
                  /// Gửi event tìm kiếm thành phố
                  context.read<WeatherBloc>().add(
                        SearchCityEvent(_searchController.text),
                      );
                }
              },
            ),
          ),

          /// Khi người dùng nhấn Enter, tìm kiếm
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              context.read<WeatherBloc>().add(SearchCityEvent(value));
            }
          },
        ),

        const SizedBox(height: 16),

        /// BlocBuilder để hiển thị kết quả tìm kiếm
        BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            /// Nếu đang loading, hiển thị spinner
            if (state is SearchLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );

              /// Nếu tìm kiếm thành công, hiển thị danh sách thành phố
            } else if (state is SearchSuccess) {
              return _buildSearchResults(state.locationResponse);

              /// Nếu có lỗi, hiển thị error message
            } else if (state is SearchFailure) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade600,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            /// Mặc định không hiển thị gì
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  /// Xây dựng danh sách kết quả tìm kiếm
  Widget _buildSearchResults(LocationResponse locationResponse) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Tiêu đề
        const Text(
          'Chọn thành phố:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        /// Danh sách các thành phố
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: locationResponse.results.length,
          itemBuilder: (context, index) {
            final location = locationResponse.results[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                /// Icon để phân biệt
                leading: const Icon(Icons.location_on),

                /// Tên thành phố
                title: Text(
                  location.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                /// Hiển thị tọa độ
                subtitle: Text(
                  'Lat: ${location.latitude.toStringAsFixed(2)}, '
                  'Lon: ${location.longitude.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 12),
                ),

                /// Khi tap vào, lấy dữ liệu thời tiết
                onTap: () {
                  setState(() {
                    _selectedCityName = location.name;
                    _selectedLatitude = location.latitude;
                    _selectedLongitude = location.longitude;
                  });

                  /// Gửi event để lấy dữ liệu thời tiết
                  context.read<WeatherBloc>().add(
                        FetchWeatherEvent(
                          latitude: location.latitude,
                          longitude: location.longitude,
                          cityName: location.name,
                        ),
                      );

                  /// Đóng bàn phím
                  FocusScope.of(context).unfocus();
                },
              ),
            );
          },
        ),
      ],
    );
  }

  /// Xây dựng phần hiển thị thông tin thời tiết
  Widget _buildWeatherSection() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        /// Nếu đang loading, hiển thị spinner
        if (state is WeatherLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );

          /// Nếu tải thành công, hiển thị thông tin thời tiết
        } else if (state is WeatherSuccess) {
          return _buildWeatherDisplay(state);

          /// Nếu có lỗi, hiển thị error message
        } else if (state is WeatherFailure) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: Colors.red.shade600,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Lỗi khi tải dữ liệu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    /// Nếu có tọa độ đã lưu, thử lại
                    if (_selectedLatitude != null &&
                        _selectedLongitude != null) {
                      context.read<WeatherBloc>().add(
                            FetchWeatherEvent(
                              latitude: _selectedLatitude!,
                              longitude: _selectedLongitude!,
                              cityName: _selectedCityName,
                            ),
                          );
                    }
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thử lại'),
                )
              ],
            ),
          );
        } else {
          /// Mặc định: hiển thị placeholder
          return _buildPlaceholder();
        }
      },
    );
  }

  /// Xây dựng UI hiển thị thông tin thời tiết
  Widget _buildWeatherDisplay(WeatherSuccess state) {
    /// Lấy icon và mô tả từ weather code
    final weatherIcon = WeatherCodeMapper.getWeatherIcon(state.weatherCode);
    final weatherDescription =
        WeatherCodeMapper.getWeatherDescription(state.weatherCode);
    final weatherColor = WeatherCodeMapper.getWeatherColor(state.weatherCode);

    return Container(
      /// Gradient background - tạo hiệu ứng đẹp
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [weatherColor.withValues(alpha: 0.6), weatherColor],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: weatherColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),

      padding: const EdgeInsets.all(24),

      child: Column(
        children: [
          /// Tên thành phố
          Text(
            state.cityName,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 24),

          /// Container chứa thông tin chi tiết
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                /// Icon thời tiết lớn
                Icon(
                  weatherIcon,
                  size: 80,
                  color: Colors.white,
                ),

                const SizedBox(height: 16),

                /// Mô tả thời tiết
                Text(
                  weatherDescription,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 24),

                /// Nhiệt độ to đổi
                Text(
                  '${state.temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                /// Mã thời tiết (để tham khảo)
                Text(
                  'Mã: ${state.weatherCode.toInt()}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// Button xóa kết quả
          ElevatedButton.icon(
            onPressed: () {
              context.read<WeatherBloc>().add(const ClearSearchEvent());
              _searchController.clear();
              setState(() {
                _selectedCityName = null;
                _selectedLatitude = null;
                _selectedLongitude = null;
              });
            },
            icon: const Icon(Icons.clear),
            label: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  /// Xây dựng placeholder khi chưa chọn thành phố
  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Icon placeholder
          Icon(
            Icons.cloud_queue,
            size: 80,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 24),

          /// Text hướng dẫn
          Text(
            'Chọn một thành phố để xem thời tiết',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          /// Hoặc dùng vị trí hiện tại
          Text(
            'hoặc nhấn nút vị trí để dùng vị trí hiện tại',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
