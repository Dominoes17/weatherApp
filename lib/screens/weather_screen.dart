import 'package:dominic_weather_app/providers/location_provider.dart';
import 'package:dominic_weather_app/providers/weather_provider.dart';
import 'package:dominic_weather_app/services/weather_service.dart';
import 'package:dominic_weather_app/widgets/current_weather.dart';
import 'package:dominic_weather_app/widgets/input_controller.dart';
import 'package:dominic_weather_app/widgets/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class WeatherScreen extends ConsumerWidget {
  WeatherScreen({super.key});

  WeatherService weatherService = WeatherService();
  Position? position;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(child: MySearchController(controller: controller)),
                    IconButton(
                      onPressed: () async {
                        if (controller.text.isNotEmpty) {
                          ref.read(loadingProvider.notifier).state = true;
                          position = await weatherService.getCityLocation(
                            controller.text,
                          );

                          if (position != null) {
                            ref
                                .read(positionProvider.notifier)
                                .setPosition(position!);

                            ref
                                .read(weatherProvider.notifier)
                                .setWeather(
                                  await weatherService.fetchWeather(
                                    position!.latitude,
                                    position!.longitude,
                                  ),
                                );
                            ref.read(errorProvider.notifier).state = false;
                          } else {
                            ref.read(errorProvider.notifier).state = true;
                          }
                          ref.read(loadingProvider.notifier).state = false;
                        }
                      },
                      icon: Icon(Icons.search),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                CurrentWeather(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
