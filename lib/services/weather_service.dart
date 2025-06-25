import 'dart:convert';
import 'dart:developer';
import 'package:dominic_weather_app/models/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherService {
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  Future<WeatherModel?> fetchWeather(double lat, double lon) async {
    try {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
      );

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          log("what is weather :: ${response.body}");
          final Map<String, dynamic> data = jsonDecode(response.body);

          return WeatherModel.fromJson(data);
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception: $e');
      }
      return null;
    } catch (e) {
      log('weather_service.dart :: fetchWeather() :: $e');
      return null;
    }
  }

  Future<WeatherModel?> fetchWeatherOverview(double lat, double lon) async {
    try {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/3.0/onecall/overview?lat=$lat&lon=$lon&appid=$apiKey',
        //  'https://api.openweathermap.org/data/3.0/onecall/overview?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
      );

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          log("what is weather overview :: ${response.body}");
          final Map<String, dynamic> data = jsonDecode(response.body);
          return WeatherModel.fromJson(data);
        } else {
          print('fetchWeatherOverview: ${response.statusCode}');
        }
      } catch (e) {
        print('fetchWeatherOverview : Exception: $e');
      }
      return null;
    } catch (e) {
      log('weather_service.dart :: fetchWeatherOverview() :: $e');
      return null;
    }
  }

  Future<Position?> getCityLocation(String city) async {
    try {
      final url = Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=1&appid=$apiKey',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          final locationData = data[0]; // Get first result

          // Create Position with required parameters
          Position position = Position(
            latitude: locationData['lat'].toDouble(),
            longitude: locationData['lon'].toDouble(),
            timestamp: DateTime.now(),
            accuracy: 0.0,
            altitude: 0.0,
            heading: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
            altitudeAccuracy: 0.0,
            headingAccuracy: 0.0,
          );

          return position;
        }
        return null;
      }
    } catch (e) {
      log('ERROR :: $e');
      return null;
    }
    return null;
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      return null;
    }

    // Get current location
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
