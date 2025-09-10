import 'package:flutter/material.dart';
import 'package:flutter_age_calculator/flutter_age_calculator.dart';

void main() {
  runApp(const AdvancedAgeCalculatorApp());
}

class AdvancedAgeCalculatorApp extends StatelessWidget {
  const AdvancedAgeCalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Age Calculator Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const AgeCalculatorDemo(),
    );
  }
}

class AgeCalculatorDemo extends StatefulWidget {
  const AgeCalculatorDemo({Key? key}) : super(key: key);

  @override
  State<AgeCalculatorDemo> createState() => _AgeCalculatorDemoState();
}

class _AgeCalculatorDemoState extends State<AgeCalculatorDemo> {
  DateTime? selectedDate;
  Map<String, dynamic>? ageStats;
  CalendarSystem selectedCalendar = CalendarSystem.gregorian;
  AgeFormat selectedFormat = AgeFormat.full;
  bool includeTime = false;

  final Map<CalendarSystem, String> calendarNames = {
    CalendarSystem.gregorian: 'Gregorian',
    CalendarSystem.hijri: 'Hijri',
    CalendarSystem.persian: 'Persian',
    CalendarSystem.buddhist: 'Buddhist',
    CalendarSystem.hebrew: 'Hebrew',
  };

  final Map<AgeFormat, String> formatNames = {
    AgeFormat.full: 'Full',
    AgeFormat.yearsOnly: 'Years Only',
    AgeFormat.yearsMonths: 'Years & Months',
    AgeFormat.detailed: 'Detailed',
    AgeFormat.arabic: 'Arabic',
    AgeFormat.compact: 'Compact',
  };

  void _calculateAge() {
    if (selectedDate != null) {
      try {
        setState(() {
          ageStats = AdvancedAgeCalculator.getAgeStatistics(
            birthDate: selectedDate!,
            calendarSystem: selectedCalendar,
          );
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎂 Advanced Age Calculator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDateSelection(),
            const SizedBox(height: 16),
            _buildCalendarSelection(),
            const SizedBox(height: 16),
            _buildOptionsSection(),
            const SizedBox(height: 20),
            if (ageStats != null) ...[
              _buildAgeStatistics(),
              const SizedBox(height: 16),
              _buildFormattedAges(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Birth Date',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime(2000, 1, 1),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  helpText: 'Select your birth date',
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                  _calculateAge();
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(
                selectedDate == null
                    ? 'Select Birth Date'
                    : 'Birth Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSelection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendar System',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<CalendarSystem>(
              value: selectedCalendar,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: calendarNames.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (CalendarSystem? value) {
                if (value != null) {
                  setState(() {
                    selectedCalendar = value;
                  });
                  _calculateAge();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Options',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Include Time'),
              subtitle: const Text('Include hours, minutes, and seconds'),
              value: includeTime,
              onChanged: (bool? value) {
                setState(() {
                  includeTime = value ?? false;
                });
                _calculateAge();
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeStatistics() {
    final age = AgeDuration.fromJson(ageStats!['age']);

    return Card(
      elevation: 4,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cake, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Age Statistics',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                ),
              ],
            ),
            const Divider(),
            _buildStatRow('📅 Age',
                '${age.years} years, ${age.months} months, ${age.days} days'),
            _buildStatRow('🎈 Days until birthday',
                '${ageStats!['daysUntilBirthday']} days'),
            _buildStatRow('⭐ Zodiac Sign', ageStats!['zodiacSign']),
            _buildStatRow('📍 Born on', ageStats!['weekdayBorn']),
            _buildStatRow('🗓️ Leap Year Born',
                ageStats!['isLeapYearBorn'] ? 'Yes' : 'No'),
            _buildStatRow(
                '📊 Total Days Lived', '${age.totalDays.toString()} days'),
            _buildStatRow(
                '⏰ Total Hours Lived', '${age.totalHours.toString()} hours'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedAges() {
    final formattedAges = ageStats!['formattedAges'] as Map<String, dynamic>;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📝 Formatted Ages',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...formattedAges.entries.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        entry.key.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
