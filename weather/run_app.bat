@echo off
REM ==========================================
REM Script để chạy Flutter Weather App
REM ==========================================

echo.
echo ====================================
echo  FLUTTER WEATHER APP - BUILD SCRIPT
echo ====================================
echo.

REM Chuyển vào thư mục dự án
cd /d c:\Users\LOQ\Downloads\weather_exam\weather

REM Step 1: Clean
echo Step 1: Cleaning project...
flutter clean
echo ✅ Clean completed
echo.

REM Step 2: Get dependencies
echo Step 2: Getting dependencies...
flutter pub get
echo ✅ Dependencies installed
echo.

REM Step 3: Build runner (generate code)
echo Step 3: Running build_runner...
flutter pub run build_runner build --delete-conflicting-outputs
echo ✅ Code generation completed
echo.

REM Step 4: Check devices
echo Step 4: Checking connected devices...
flutter devices
echo.

REM Step 5: Run app
echo Step 5: Running app on emulator...
echo.
flutter run -v

echo.
echo ====================================
echo  Build completed!
echo ====================================
pause
