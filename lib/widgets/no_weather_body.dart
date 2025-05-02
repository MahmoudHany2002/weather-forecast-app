import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weatherapp/views/search_view.dart';

class NoWeatherBody extends StatefulWidget {
  const NoWeatherBody({super.key});

  @override
  State<NoWeatherBody> createState() => _NoWeatherBodyState();
}

class _NoWeatherBodyState extends State<NoWeatherBody> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(32),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(24),
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
                // Sun animation
                _buildSunAnimation(context),

                const SizedBox(height: 32),

                Text(
                  'Welcome to Weather Forecast',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1565C0),
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                Text(
                  'Get accurate weather information for any location around the world',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black87,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Features section
                _buildFeaturesList(context),

                const SizedBox(height: 32),

                // Search button
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
                  label: const Text('Search City'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSunAnimation(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated outer glow
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 180 * _pulseAnimation.value,
                height: 180 * _pulseAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFFD700).withOpacity(0.7),
                      const Color(0xFFFFD700).withOpacity(0.0),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              );
            },
          ),

          // Sun image with pulsating effect
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.5 * _pulseAnimation.value),
                      blurRadius: 20 * _pulseAnimation.value,
                      spreadRadius: 5 * _pulseAnimation.value,
                    ),
                  ],
                ),
                child: child,
              );
            },
            child: Image.asset(
              'assets/clear.png',
              width: 100,
              height: 100,
            ),
          ),

          // Animated clouds
          SizedBox(
            width: 220,
            height: 220,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Small cloud 1 - moves horizontally
                    Positioned(
                      top: 20,
                      right: 20 + (10 * _controller.value),
                      child: _buildCloud(40, 20),
                    ),

                    // Small cloud 2 - moves vertically
                    Positioned(
                      bottom: 30 + (5 * _controller.value),
                      left: 10,
                      child: _buildCloud(50, 25),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloud(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    return Column(
      children: [
        _buildFeatureItem(
          context,
          Icons.location_on,
          'Search any city worldwide',
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          context,
          Icons.calendar_today,
          'Get 2-day weather forecast',
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          context,
          Icons.thermostat,
          'Detailed temperature information',
        ),
      ],
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}
