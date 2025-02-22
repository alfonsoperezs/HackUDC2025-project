import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:intl/intl.dart';

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
                "TASKINATOR",
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
    return addScreen();
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
  final List<Map<String, dynamic>> _tasks = [
    {'task': 'Study', 'time': '08:00 AM', 'isDone': false},
    {'task': 'Buy Groceries', 'time': '10:30 AM', 'isDone': false},
    {'task': 'Homework', 'time': '06:00 PM', 'isDone': false},
  ];

  // ValueNotifier (cambiar a Provider cuando se implemente BD) para manejar el estado de las tareas
  final ValueNotifier<List<Map<String, dynamic>>> tasksFinished = ValueNotifier(_tasks);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Tasks for today:',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),

      ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: tasksFinished, 
        builder: (context, tasks, child) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Checkbox(
                  value: tasks[index]['isDone'], 
                  onChanged: (bool? value) {
                    tasks[index]['isDone'] = value ?? false;
                    tasksFinished.notifyListeners();
                  },
                ),
                title: Text(_tasks[index]['task']!, // Muestra la tarea
                style: TextStyle(
                  decoration: tasks[index]['isDone']!
                    ? TextDecoration.lineThrough
                    : null,
                  ),
                ),
                subtitle: Text(_tasks[index]['time']!) // Muestra las horas a las que hacerse
              );
            },
          );
        }  
      )

      
    ],
  );
}


Widget addScreen() {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2025, 1, 1), 
      lastDate: DateTime(2025, 12, 31)
    );

    if(pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      dateController.text = formattedDate;
    }
  }


  return Builder(
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de nombre de la tarea
            const Text(
              "Task title",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8), // espacio entre el título y el input
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 225, 225, 225),
                hintText: "Enter task name",
                hintStyle: const TextStyle(color: Color.fromARGB(221, 97, 97, 97)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
              ),
            ),

            const SizedBox(height: 16),

            // Campo de selección de fecha límite
            const Text(
              "Due Date",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 225, 225, 225),
                hintText: "Select date",
                hintStyle: const TextStyle(color: Color.fromARGB(221, 97, 97, 97)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: const Icon(Icons.calendar_today),
              ),

              onTap:() => _selectDate(context), // Llama al selector de fecha
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {

              }, 

              child: const Center(
                child: Text(
                  'Add Task',
                  style: TextStyle(fontSize: 20)
                ),
              ),
            ),
          ],
        )
      );
    }
  );
}
