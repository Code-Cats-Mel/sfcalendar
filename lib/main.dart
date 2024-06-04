import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  return runApp(CalendarApp());
}

/// The app which hosts the home page which contains the calendar on it.
class CalendarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Calendar Demo', home: MyHomePage());
  }
}

/// The hove page which hosts the calendar
class MyHomePage extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 100,
              child: SfCalendar(
                initialSelectedDate: DateTime(2024, 6, 3),
                view: CalendarView.week,
              ),
            ),
            Expanded(
              child: SfCalendar(
                initialSelectedDate: DateTime(2024, 6, 3),
                showNavigationArrow: true,
                showTodayButton: true,
                firstDayOfWeek: 1,
                resourceViewHeaderBuilder:
                    (BuildContext context, ResourceViewHeaderDetails details) {
                  return Container(
                    color: Colors.blue,
                    child: const Text('Resource'),
                  );
                },
                headerHeight: 0,
                viewHeaderHeight: 0,
                view: CalendarView.day,
                timeSlotViewSettings: const TimeSlotViewSettings(
                    startHour: 0,
                    endHour: 24,
                    timeInterval: Duration(hours: 1)),
                headerStyle: const CalendarHeaderStyle(
                    textStyle: TextStyle(fontSize: 20, color: Colors.red)),
                // monthViewSettings: const MonthViewSettings(
                //     appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
