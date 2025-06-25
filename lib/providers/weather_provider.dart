import 'package:dominic_weather_app/models/weather_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeatherNotifier extends StateNotifier<WeatherModel?> {
  WeatherNotifier() : super(null);

  void setWeather(WeatherModel? weatherModel) {
    state = weatherModel;
  }

  void clear() {
    state = null;
  }
}

// Provider
final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherModel?>(
  (ref) => WeatherNotifier(),
);
