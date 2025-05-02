import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/cubits/get_weather_cubit/get_weather_cubit.dart';
import 'package:weatherapp/cubits/get_weather_cubit/get_weather_states.dart';
import 'package:weatherapp/views/search_view.dart';
import 'package:weatherapp/widgets/no_weather_body.dart';
import 'package:weatherapp/widgets/weather_info_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.wb_sunny_rounded,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Weather Forecast',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const SearchView();
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background with animated gradient
          const AnimatedGradientBackground(),

          // Content
          SafeArea(
            child: BlocBuilder<GetWeatherCubit, WeatherStates>(
              builder: (context, state) {
                if (state is InitialState) {
                  return const NoWeatherBody();
                } else if (state is WeatherLoadingState) {
                  return _buildLoadingState(context);
                } else if (state is WeatherLoadState) {
                  return WeatherInfoBody(
                    weatherModel: state.weatherModel,
                  );
                } else {
                  return _buildErrorState(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Loading Weather Data',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Please wait while we fetch the latest weather information for your location.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black87,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Oops! Something went wrong',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.red.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'We couldn\'t find the weather information for this city. Please try searching for a different location.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black87,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const SearchView();
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Search Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({super.key});

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<List<Color>> _colorSets = [
    [
      const Color(0xFF1565C0),
      const Color(0xFF64B5F6),
      Colors.white,
    ],
    [
      const Color(0xFF0D47A1),
      const Color(0xFF42A5F5),
      Colors.white,
    ],
  ];

  int _currentColorSet = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        setState(() {
          _currentColorSet = (_currentColorSet + 1) % _colorSets.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final nextColorSetIndex = (_currentColorSet + 1) % _colorSets.length;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.lerp(
                  _colorSets[_currentColorSet][0],
                  _colorSets[nextColorSetIndex][0],
                  _animation.value,
                )!,
                Color.lerp(
                  _colorSets[_currentColorSet][1],
                  _colorSets[nextColorSetIndex][1],
                  _animation.value,
                )!,
                Color.lerp(
                  _colorSets[_currentColorSet][2],
                  _colorSets[nextColorSetIndex][2],
                  _animation.value,
                )!,
              ],
            ),
          ),
        );
      },
    );
  }
}