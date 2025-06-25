import 'package:flutter/material.dart';

class SearchInputController extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onSearchPressed;
  final bool enabled;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;

  const SearchInputController({
    Key? key,
    this.controller,
    this.hintText = 'Search location...',
    this.onChanged,
    this.onSubmitted,
    this.onSearchPressed,
    this.enabled = true,
    this.backgroundColor,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.borderRadius = 25.0,
    this.contentPadding,
  }) : super(key: key);

  @override
  State<SearchInputController> createState() => _SearchInputControllerState();
}

class _SearchInputControllerState extends State<SearchInputController> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  void _clearText() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: TextStyle(
          color: widget.textColor ?? (isDark ? Colors.white : Colors.black87),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color:
                widget.hintColor ??
                (isDark ? Colors.grey[400] : Colors.grey[600]),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor:
              widget.backgroundColor ??
              (isDark ? Colors.grey[800] : Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: theme.primaryColor, width: 2),
          ),
          contentPadding:
              widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Icon(
              Icons.search,
              color:
                  widget.iconColor ??
                  (isDark ? Colors.grey[400] : Colors.grey[600]),
              size: 24,
            ),
          ),
          suffixIcon: _hasText
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color:
                          widget.iconColor ??
                          (isDark ? Colors.grey[400] : Colors.grey[600]),
                      size: 20,
                    ),
                    onPressed: _clearText,
                    splashRadius: 20,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

// Weather-specific search controller with preset styling
class WeatherSearchController extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onLocationSearch;
  final Function(String)? onChanged;
  final bool isLoading;

  const WeatherSearchController({
    Key? key,
    this.controller,
    this.onLocationSearch,
    this.onChanged,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SearchInputController(
      controller: controller,
      hintText: 'Search for a city or location...',
      onChanged: onChanged,
      onSubmitted: onLocationSearch,
      backgroundColor: Colors.white.withOpacity(0.9),
      textColor: Colors.black87,
      hintColor: Colors.grey[600],
      iconColor: Colors.blue[600],
      borderRadius: 30.0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
    );
  }
}
