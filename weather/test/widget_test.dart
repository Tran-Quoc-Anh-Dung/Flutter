// ====================================================================
// FILE: widget_test.dart
// MỤC ĐÍCH: Kiểm thử giao diện (UI) của ứng dụng Flutter
// ====================================================================

// Đây là một file kiểm thử cơ bản cho widget Flutter
//
// Để tương tác với widget trong kiểm thử, sử dụng WidgetTester utility
// từ package flutter_test. Ví dụ: bạn có thể gửi các gesture như tap, scroll
// Cũng có thể dùng WidgetTester để tìm widget con trong widget tree,
// đọc text, và xác minh các giá trị của widget properties là đúng

// Import Material Design widgets
import 'package:flutter/material.dart';

// Import flutter_test package - chứa các công cụ để kiểm thử
import 'package:flutter_test/flutter_test.dart';

// Import SharedPreferences
import 'package:shared_preferences/shared_preferences.dart';

// Import main.dart - ứng dụng mà chúng ta muốn kiểm thử
import 'package:flutter_weather_example/main.dart';

// Hàm main - điểm khởi động cho tất cả các bài kiểm thử
void main() async {
  /// Khởi tạo SharedPreferences cho testing
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  // testWidgets: hàm để viết widget test
  // Tham số 1: mô tả bài kiểm thử
  // Tham số 2: callback function với WidgetTester
  testWidgets(
    // Mô tả bài kiểm thử: kiểm thử tính năng tăng counter
    'Counter increments smoke test',
    // Hàm callback nhận WidgetTester để tương tác với UI
    (WidgetTester tester) async {
      // Build ứng dụng MyApp và render frame đầu tiên
      // pumpWidget: xây dựng widget và hiển thị lên screen
      await tester.pumpWidget(MyApp(sharedPreferences: sharedPreferences));

      // ============ KIỂM THỬ TRẠNG THÁI KHỞI ĐỘNG ============

      // Kiểm thử: tìm text '0' - counter phải bắt đầu từ 0
      // findsOneWidget: xác minh chỉ tìm được đúng 1 widget
      expect(find.text('0'), findsOneWidget);

      // Kiểm thử: không nên có text '1' ở trạng thái khởi động
      // findsNothing: xác minh không tìm được widget nào
      expect(find.text('1'), findsNothing);

      // ============ TƯƠNG TÁC VỚI UI ============

      // Tap (nhấn) vào icon '+' để tăng counter
      // find.byIcon: tìm widget theo icon
      // Icons.add: icon cộng (dấu +)
      await tester.tap(find.byIcon(Icons.add));

      // pump: render lại frame sau khi tương tác
      // (để UI cập nhật sau sự kiện tap)
      await tester.pump();

      // ============ KIỂM THỬ TRẠNG THÁI SAU TƯƠNG TÁC ============

      // Kiểm thử: text '0' không còn nữa (counter đã tăng)
      expect(find.text('0'), findsNothing);

      // Kiểm thử: text '1' phải xuất hiện (counter tăng thành 1)
      expect(find.text('1'), findsOneWidget);
    },
  );
}
