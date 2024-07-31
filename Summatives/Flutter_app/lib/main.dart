import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Performance Prediction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _hoursStudiedController = TextEditingController();
  final TextEditingController _previousScoresController =
      TextEditingController();
  final TextEditingController _extracurricularActivitiesController =
      TextEditingController();
  final TextEditingController _sleepHoursController = TextEditingController();
  final TextEditingController _sampleQuestionPapersPracticedController =
      TextEditingController();

  Future<void> _predictStudentPerformance() async {
    final response = await http.post(
      Uri.parse('https://linear-regression-zpgo.onrender.com/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'HoursStudied': int.parse(_hoursStudiedController.text),
        'PreviousScores': int.parse(_previousScoresController.text),
        'ExtracurricularActivities':
            int.parse(_extracurricularActivitiesController.text),
        'SleepHours': int.parse(_sleepHoursController.text),
        'SampleQuestionPapersPracticed':
            int.parse(_sampleQuestionPapersPracticedController.text),
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final double prediction = responseData['prediction'];
      _showDialog('Prediction',
          'The predicted performance score is ${prediction.toStringAsFixed(2)}');
    } else {
      _showDialog('Error', 'Failed to get prediction.');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Performance Prediction'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _hoursStudiedController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Hours Studied'),
            ),
            TextField(
              controller: _previousScoresController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Previous Scores'),
            ),
            TextField(
              controller: _extracurricularActivitiesController,
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(labelText: 'Extracurricular Activities'),
            ),
            TextField(
              controller: _sleepHoursController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Sleep Hours'),
            ),
            TextField(
              controller: _sampleQuestionPapersPracticedController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Sample Question Papers Practiced'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _predictStudentPerformance,
              child: Text('Predict'),
            ),
          ],
        ),
      ),
    );
  }
}
