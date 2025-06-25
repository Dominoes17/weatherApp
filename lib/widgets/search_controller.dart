import 'package:flutter/material.dart';

class MySearchController extends StatelessWidget {
  const MySearchController({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search for a city or location...',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
