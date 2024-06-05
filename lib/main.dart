import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('MMMM yyyy');
  final CalendarController _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildCustomHeader(),
            _buildWeekView(),
            Expanded(
              child: SfCalendar(
                headerHeight: 0,
                viewHeaderHeight: 0,
                view: CalendarView.day,
                controller: _calendarController,
                initialDisplayDate: selectedDate,
                dataSource: _getCalendarDataSource(),
                timeSlotViewSettings: const TimeSlotViewSettings(
                  startHour: 00,
                  endHour: 24,
                  timeIntervalHeight: 60,
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Handle back button action
                },
              ),
              Text(
                formatter.format(selectedDate),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Row(
            children: [
              Icon(Icons.insert_drive_file),
              SizedBox(width: 10),
              Icon(Icons.add),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekView() {
    DateTime startDate = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          DateTime currentDate = startDate.add(Duration(days: index));
          bool isSelected = currentDate.day == selectedDate.day &&
              currentDate.month == selectedDate.month &&
              currentDate.year == selectedDate.year;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = currentDate;
                _calendarController.displayDate = selectedDate;
              });
            },
            child: SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E().format(currentDate).substring(0, 1) == 'S'
                        ? DateFormat.E().format(currentDate).substring(0, 2)
                        : DateFormat.E().format(currentDate).substring(0, 1),
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.black,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Colors.purple : Colors.transparent,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      currentDate.day.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: 393,
      height: 83.29,
      padding: const EdgeInsets.only(top: 12),
      child: const Center(
        child: Text(
          'Calendars',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  MeetingDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 1)),
      endTime: DateTime.now().add(const Duration(hours: 2)),
      subject: 'Dentist Appointment',
      location: '16 Bishop\'s Bridge Road, London',
      color: Colors.purple,
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 2)),
      endTime: DateTime.now().add(const Duration(hours: 3)),
      subject: 'Dentist Appointment',
      location: '16 Bishop\'s Bridge Road, London',
      color: Colors.purple,
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 7)),
      endTime: DateTime.now().add(const Duration(hours: 8)),
      subject: 'Dentist Appointment',
      location: '16 Bishop\'s Bridge Road, London',
      color: Colors.purple,
    ));
    return MeetingDataSource(appointments);
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
