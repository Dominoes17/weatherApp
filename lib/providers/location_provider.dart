import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class PositionNotifier extends StateNotifier<Position?> {
  PositionNotifier() : super(null);

  void setPosition(Position newPosition) {
    state = newPosition;
  }

  void clear() {
    state = null;
  }
}

// Provider
final positionProvider = StateNotifierProvider<PositionNotifier, Position?>(
  (ref) => PositionNotifier(),
);

//Additional Providers

final errorProvider = StateProvider<bool>((ref) => false);

final loadingProvider = StateProvider<bool>((ref) => false);

final errorMessageProvider = StateProvider<String>((ref) => '');
