import 'package:flutter/material.dart';
import 'package:weatherapp/Models/weather_model.dart';
import 'package:intl/intl.dart';

class WeatherInfoBody extends StatelessWidget {
  const WeatherInfoBody({super.key, required this.weatherModel});
  final WeatherModel weatherModel;

  String _getWeatherImage(String condition) {
    final lowerCondition = condition.toLowerCase();
    if (lowerCondition.contains('rain') || lowerCondition.contains('drizzle')) {
      return 'assets/rainy.png';
    } else if (lowerCondition.contains('snow') || lowerCondition.contains('sleet')) {
      return 'assets/snow.png';
    } else if (lowerCondition.contains('thunder') || lowerCondition.contains('storm')) {
      return 'assets/thunderstorm.png';
    } else {
      return 'assets/clear.png';
    }
  }

  String _formatDate(String date, {bool showTime = true}) {
    try {
      final dateTime = DateTime.parse(date);
      if (showTime) {
        return DateFormat('EEE, MMM d • h:mm a').format(dateTime);
      } else {
        return DateFormat('EEE, MMM d').format(dateTime);
      }
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // City Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    weatherModel.cityName,
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Updated: ${_formatDate(weatherModel.date)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Temperature Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      _getWeatherImage(weatherModel.weatherCondition),
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '${weatherModel.temp.round()}°C',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    weatherModel.weatherCondition,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTemperatureInfo(
                        context,
                        'Min',
                        '${weatherModel.minTemp.round()}°C',
                        Icons.arrow_downward,
                        Colors.blue,
                      ),
                      _buildTemperatureInfo(
                        context,
                        'Max',
                        '${weatherModel.maxTemp.round()}°C',
                        Icons.arrow_upward,
                        Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Weather Details Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weather Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildWeatherDetailRow(
                    context,
                    'Condition',
                    weatherModel.weatherCondition,
                    Icons.cloud,
                  ),
                  const Divider(),
                  _buildWeatherDetailRow(
                    context,
                    'Temperature',
                    '${weatherModel.temp.round()}°C',
                    Icons.thermostat,
                  ),
                  const Divider(),
                  _buildWeatherDetailRow(
                    context,
                    'Min Temperature',
                    '${weatherModel.minTemp.round()}°C',
                    Icons.arrow_downward,
                  ),
                  const Divider(),
                  _buildWeatherDetailRow(
                    context,
                    'Max Temperature',
                    '${weatherModel.maxTemp.round()}°C',
                    Icons.arrow_upward,
                  ),
                ],
              ),
            ),

            // Forecast Section
            if (weatherModel.forecastDays.isNotEmpty) ...[
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Forecast',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...weatherModel.forecastDays.map((forecastDay) => _buildForecastDay(context, forecastDay)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureInfo(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildWeatherDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildForecastDay(BuildContext context, ForecastDay forecastDay) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Date
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(forecastDay.date, showTime: false),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  forecastDay.condition,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Weather icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              _getWeatherImage(forecastDay.condition),
              width: 40,
              height: 40,
            ),
          ),

          const SizedBox(width: 16),

          // Temperature
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${forecastDay.maxTemp.round()}°C',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_downward,
                      color: Colors.blue,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${forecastDay.minTemp.round()}°C',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}