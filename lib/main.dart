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

class MonthViewPage extends StatefulWidget {
  const MonthViewPage({super.key});

  @override
  _MonthViewPageState createState() => _MonthViewPageState();
}

class _MonthViewPageState extends State<MonthViewPage> {
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
            _buildMonthView(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              // Container(
              //   height: 40,
              //   child: _calendarController.view == CalendarView.month,
              //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
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

  Widget _buildMonthView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SfCalendar(
          headerHeight: 0,
          view: CalendarView.month,
          showTodayButton: true,
          initialSelectedDate: selectedDate,
          onTap: (calendarTapDetails) {
            if (calendarTapDetails.date != null) {
              setState(() {
                selectedDate = calendarTapDetails.date!;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalendarPage(selectedDate: selectedDate),
                ),
              );
            }
          },
          monthViewSettings: const MonthViewSettings(
            navigationDirection: MonthNavigationDirection.vertical,
            dayFormat: 'EEE',
            showAgenda: false,
            appointmentDisplayMode: MonthAppointmentDisplayMode.none,
            monthCellStyle: MonthCellStyle(
              todayBackgroundColor: Colors.transparent,
              leadingDatesBackgroundColor: Colors.transparent,
              trailingDatesBackgroundColor: Colors.transparent,
            ),
          ),
          cellBorderColor: Colors.transparent,
          todayHighlightColor: Colors.purple,
          selectionDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.purple,
          ),
        ),
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
}

class CalendarPage extends StatefulWidget {
  final DateTime? selectedDate;

  const CalendarPage({super.key, this.selectedDate});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime selectedDate;
  final DateFormat formatter = DateFormat('MMMM yyyy');
  final CalendarController _calendarController = CalendarController();
  late ScrollController _scrollController;
  final List<DateTime> dateList = [];

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate ?? DateTime.now();
    _scrollController = ScrollController();
    generateDates();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSelectedDate();
    });
  }

  void generateDates() {
    DateTime startDate = DateTime.now().subtract(const Duration(days: 365));
    DateTime endDate = DateTime.now().add(const Duration(days: 365));
    dateList.clear();
    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      dateList.add(date);
    }
  }

  void scrollToSelectedDate() {
    int index = dateList.indexWhere((date) =>
        date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day);
    double screenWidth = MediaQuery.of(context).size.width;
    double dayWidth = screenWidth / 7;
    _scrollController.jumpTo(index * dayWidth - screenWidth / 2 + dayWidth / 2);
  }

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
                  startHour: 0,
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
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  //navigate to MonthViewPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MonthViewPage(),
                    ),
                  );
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
    double dayWidth = MediaQuery.of(context).size.width / 7;
    return SizedBox(
      height: 80,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: dateList.length,
        itemBuilder: (context, index) {
          DateTime currentDate = dateList[index];
          bool isSelected = currentDate.day == selectedDate.day &&
              currentDate.month == selectedDate.month &&
              currentDate.year == selectedDate.year;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = currentDate;
                _calendarController.displayDate = selectedDate;
                scrollToSelectedDate();
              });
            },
            child: Container(
              width: dayWidth,
              alignment: Alignment.center,
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
