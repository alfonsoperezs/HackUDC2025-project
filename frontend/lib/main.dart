import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskinator',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget{
  MyHomePage({super.key});

  final ValueNotifier<DateTime> _selectedDay = ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<CalendarFormat> _calendarFormat = ValueNotifier<CalendarFormat>(CalendarFormat.week);

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Taskinator")),
      body: Center(
        child: ValueListenableBuilder<DateTime>(
          valueListenable: _selectedDay, 
          builder: (context, selectedDay, _) {
            return TableCalendar(
              focusedDay: _focusedDay.value, 
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              firstDay: DateTime.utc(2025, 1, 1), 
              lastDay: DateTime.utc(2025, 12, 31),
              calendarFormat: _calendarFormat.value,
              onDaySelected: (selectedDay, focusedDay) {
                _selectedDay.value = selectedDay;
                _focusedDay.value = focusedDay;
              },
              onFormatChanged: (format) {
                _calendarFormat.value = format;
              },
            );
          }
        ),
      )
    );
  }



}


