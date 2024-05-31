import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import '../components/bottom_bar.dart';
import 'MoodsPage.dart';

class DiaryPage extends StatefulWidget {
  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _textController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  String _currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<Map<String, dynamic>> _diaryEntries = [];

  @override
  void initState() {
    super.initState();
    _loadDiary();
  }

  Future<void> _loadDiary() async {
    final url = Uri.parse('https://hackathon-hacked2-default-rtdb.firebaseio.com/diary.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> loadedEntries = [];
      data.forEach((key, value) {
        loadedEntries.add(value);
      });
      setState(() {
        _diaryEntries = loadedEntries;
      });
    } else {
      throw Exception('Failed to load diary entries');
    }
  }
  String emotion = "First make an entry in the Diary";
  double percentage = 85;
  Future<void> _detectEmotion() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/predict_emotion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'text': _textController.text,
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      emotion = responseData['emotion'];
      percentage = responseData['percentage'];
      int percentage1= (percentage*100).round();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MoodsPage(
            barValues: const [
              0.8,
              0.5,
              0.3,
              0.7
            ],
            detectedEmotion: emotion,
            detectedPercentage: percentage1.toDouble(),
          ),
        ),
      );

    } else {
      throw Exception('Failed to detect emotion: ${response.reasonPhrase}');
    }
  }

  void _saveDiary() async {
    String textfromsizedbox = _textController.text; // Extract text from controller
    String titlefromsizedbox = _titleController.text; // Extract text from controller

    final url = Uri.parse('https://hackathon-hacked2-default-rtdb.firebaseio.com/diary.json');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'date': _currentDate,
          'title': titlefromsizedbox,
          'text': textfromsizedbox,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Journal Saved!')),
        );
        _loadDiary(); // Reload diary entries after saving
      } else {
        throw Exception('Failed to save journal');
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save journal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        toolbarHeight: 100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text('Feeling Diary'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_currentDate',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text(
                      'Make a Note',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                  hintText: 'Enter the Title'
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 300,
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Enter text here',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _detectEmotion();
                _saveDiary();
                _textController.clear();
                _titleController.clear();
              },
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 20.0),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          _buildDiaryCarousel(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Bottom_Bar(),
    );
  }

  Widget _buildDiaryCarousel() {
    if (_diaryEntries.isEmpty) {
      return Center(child: Text("No diary entries available"));
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 400,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      items: _diaryEntries.map((entry) {
        return Builder(
          builder: (BuildContext context) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        entry['title'] ?? 'No Title',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        entry['text'] ?? 'No Content',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
