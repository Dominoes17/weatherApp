import 'dart:developer';

import 'package:dominic_weather_app/models/weather_model.dart';
import 'package:dominic_weather_app/providers/location_provider.dart';
import 'package:dominic_weather_app/providers/weather_provider.dart';
import 'package:dominic_weather_app/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class CurrentWeather extends ConsumerStatefulWidget {
  const CurrentWeather({super.key});

  @override
  ConsumerState<CurrentWeather> createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends ConsumerState<CurrentWeather> {
  bool isLoading = false;

  final WeatherService weatherService = WeatherService();

  Position? position;
  WeatherModel? weatherModel;

  @override
  void initState() {
    super.initState();
    Future(() async {
      await initializeWeatherServices();
    });
  }

  Future<void> getCityLocation(String city) async {
    await weatherService.getCityLocation(city);
  }

  Future<void> getCurrentLocation() async {
    try {
      position = await weatherService.getCurrentLocation();
    } catch (e) {
      log('current_weather.dart :: getCurrentLocation() :: $e');
    }
  }

  Future<void> getCurrentWeather() async {
    try {
      final positionPrvider = ref.watch(positionProvider);
      if (positionPrvider != null) {
        weatherModel = await weatherService.fetchWeather(
          positionPrvider.latitude,
          positionPrvider.longitude,
        );
      } else {
        if (position != null) {
          weatherModel = await weatherService.fetchWeather(
            position!.latitude,
            position!.longitude,
          );
        } else {
          ref.read(errorProvider.notifier).state = true;
        }
      }
      ref.read(weatherProvider.notifier).setWeather(weatherModel);
    } catch (e) {
      log('current_weather.dart :: getCurrentWeather() :: $e');
    }
  }

  Future<void> initializeWeatherServices() async {
    ref.read(loadingProvider.notifier).state = true;
    await getCurrentLocation();
    await getCurrentWeather();
    ref.read(loadingProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(loadingProvider) == true) {
      return const Center(child: CircularProgressIndicator());
    }

    final weatherNotif = ref.watch(weatherProvider);

    if (weatherNotif != null) {
      weatherModel = weatherNotif;
    }

    final errorNotif = ref.watch(errorProvider);

    return errorNotif == true
        ? Column(
            children: [
              Image.asset('assets/images/error.png'),
              SizedBox(height: 16),
              Text(
                'Oops! Unable to load weather data.',
                style: TextStyle(fontWeight: FontWeight.w500),
                textScaler: TextScaler.linear(1.5),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weatherModel?.name ?? 'No City',
                    style: TextStyle(fontWeight: FontWeight.w500),
                    textScaler: TextScaler.linear(1.2),
                  ),
                  Text(" ,${weatherModel?.sys.country}"),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: imageToShow(weatherModel?.weather[0].main ?? ''),
              ),
              SizedBox(height: 10),
              Text(
                "${weatherModel?.main.tempRounded ?? '--'}°C",
                style: TextStyle(fontWeight: FontWeight.w600),
                textScaler: TextScaler.linear(2),
              ),
              SizedBox(height: 10),

              Text(
                weatherModel?.weather[0].description.toUpperCase() ?? '',
                textScaler: TextScaler.linear(1.1),
              ),
              SizedBox(height: 10),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Max : ${weatherModel?.main.tempMax ?? '--'}°C"),
                    Text("Min : ${weatherModel?.main.tempMax ?? '--'}°C"),
                    Text(
                      "Feels Like : ${weatherModel?.main.feelsLikeRounded ?? '--'}°C",
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Widget imageToShow(String condition) {
    switch (condition) {
      case "Clouds":
        return Image.asset("assets/images/cloud.png");
      case "Clear":
        return Image.asset("assets/images/sun.png");
      case "Rain":
        return Image.asset("assets/images/rain.png");
      case "Snow":
        return Image.asset("assets/images/snow.png");
      case "Thunderstorm":
        return Image.asset("assets/images/thunder.jpeg");
      case "Drizzle":
        return Image.asset("assets/drizzle.png");
      case "Mist":
        return Image.asset("assets/mist.png");
      case "Smoke":
        return Image.asset("assets/smoke.png");
      case "Haze":
        return Image.asset("assets/haze.png");
      case "Dust":
        return Container(); // Return an empty container or a default image
      default:
        return Container(); // Handle any unexpected conditions
    }
  }
}
