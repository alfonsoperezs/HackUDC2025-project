import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Home(),
    );
  }
}


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  int index = 0;

  final List<Widget> screens = [
    homePage(), 
    buildList()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Barra superior
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),

            child: const Center(
              child: Text(
                "Taskinator",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                )
              )
            )
          ),

          Expanded(child: _getScreen(index)),
        ],
      ),
      
      bottomNavigationBar: CurvedNavigationBar(
            onTap: (int newIndex) {
              setState(() {
                index = newIndex;
              });
            },

            height: 60,
            backgroundColor: Colors.white,
            color: Colors.indigo,
            buttonBackgroundColor: Colors.indigoAccent,
            animationDuration: const Duration(milliseconds: 300),
            animationCurve: Curves.decelerate,
            items: const [
              Icon(Icons.home, color: Colors.white),
              Icon(Icons.add, color: Colors.white),
            ],
          ),
    );
  }
}


Widget _getScreen(int index) {
  if(index == 0) {
    return homePage();
  } else {
    return buildList();
  }
    
}


Widget homePage() {
  final ValueNotifier<DateTime> _selectedDay = ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<CalendarFormat> _calendarFormat = ValueNotifier<CalendarFormat>(CalendarFormat.week);

  return Column(
    children: [
      ValueListenableBuilder<DateTime>(
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

      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Divider(),
            buildList(),
          ],
        )
      )
    ],
  );
  
  
  
  
}


Widget buildList() {
  // Lista de tareas
  final List<String> _tasks = [
    'Study',
    'Buy groceries',
    'Walk the dog',
    'Homework',
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Tasks for today:',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      ListView.builder(
        shrinkWrap: true,
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(_tasks[index]),
          );
        },
      )
    ],
  );
}


