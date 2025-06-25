import 'package:dominic_weather_app/providers/location_provider.dart';
import 'package:dominic_weather_app/providers/weather_provider.dart';
import 'package:dominic_weather_app/services/weather_service.dart';
import 'package:dominic_weather_app/widgets/current_weather.dart';
import 'package:dominic_weather_app/widgets/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class WeatherScreen extends ConsumerWidget {
  WeatherScreen({super.key});

  WeatherService weatherService = WeatherService();
  Position? position;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: kIsWeb
                ? MediaQuery.of(context).size.width * 0.3
                : MediaQuery.of(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                !kIsWeb ? const SizedBox(height: 20) : const SizedBox(),
                Row(
                  children: [
                    Expanded(child: MySearchController(controller: controller)),
                    IconButton(
                      onPressed: () async {
                        if (controller.text.isNotEmpty) {
                          //Initializing the loading provider state
                          ref.read(loadingProvider.notifier).state = true;
                          //Fetch location
                          position = await weatherService.getCityLocation(
                            controller.text,
                          );

                          if (position != null) {
                            ref
                                .read(positionProvider.notifier)
                                .setPosition(position!);
                            //Fetch weather data
                            ref
                                .read(weatherProvider.notifier)
                                .setWeather(
                                  await weatherService.fetchWeather(
                                    position!.latitude,
                                    position!.longitude,
                                  ),
                                );
                            //Stop Loader
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
                //Where the weather data is displayed
                CurrentWeather(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
