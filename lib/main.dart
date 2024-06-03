import 'dart:async';
import 'package:flutter/material.dart';
import 'components/clock_view.dart';
import 'ui/colors.dart';
import 'utils/time.dart';
import 'package:timer_builder/timer_builder.dart';
import 'alarm_page.dart';
import 'stopwatch_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      home: const HomePage(),
      routes: {
        '/alarm': (context) => AlarmPage(),
        '/stopwatch': (context) => StopwatchPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfafafa),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TimerBuilder.periodic(
                  const Duration(seconds: 1),
                  builder: (context) {
                    String minute = now.minute < 10 ? "0${now.minute}" : now.minute.toString();
                    String hour = now.hour < 10 ? "0${now.hour}" : now.hour.toString();

                    return Column(
                      children: [
                        Text(
                          "$hour:$minute",
                          style: AppStyle.maintext,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ClockView(CustomTime(now.hour, now.minute, now.second)),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "SigmaClock",
                          style: AppStyle.maintext,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 40.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/alarm');
                  },
                  child: const Text('Sigma Alarm'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/stopwatch');
                  },
                  child: const Text('Skibididle Watch'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
