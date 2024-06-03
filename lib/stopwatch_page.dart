import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  bool _isRunning = false;
  bool _isPaused = false;
  DateTime? _startTime;
  Duration _elapsedTime = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stopwatch'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Elapsed Time: ${_formatTime(_elapsedTime)}',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _isRunning ? _stop : _start,
              child: Text(_isRunning ? 'Pause' : 'Start'),
            ),
            if (_isPaused) ...[
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _start,
                child: Text('Resume'),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: _reset,
                child: Text('Reset'),
              ),
            ]
          ],
        ),
      ),
    );
  }

  void _start() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
      if (_startTime == null) {
        _startTime = DateTime.now();
      } else {
        _startTime = DateTime.now().subtract(_elapsedTime);
      }
    });
    _updateTime();
  }

  void _stop() {
    setState(() {
      _isRunning = false;
      _isPaused = true;
    });
  }

  void _reset() {
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _elapsedTime = Duration.zero;
      _startTime = null;
    });
  }

  void _updateTime() {
    if (_isRunning) {
      setState(() {
        _elapsedTime = DateTime.now().difference(_startTime!);
      });
      Future.delayed(const Duration(milliseconds: 1), _updateTime);
    }
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String milliseconds = twoDigits(duration.inMilliseconds.remainder(1000) ~/ 10);
    return '$twoDigitMinutes:$twoDigitSeconds:$milliseconds';
  }
}
