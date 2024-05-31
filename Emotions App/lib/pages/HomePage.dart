import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:onlycode/components/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:onlycode/components/card.dart';
import 'package:onlycode/components/heat_map.dart';
import 'package:onlycode/components/hero_section.dart';
import 'package:onlycode/components/video_section.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/heading.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.detectedEmotion,
    required this.detectedPercentage,
  }) : super(key: key);

  final String detectedEmotion;
  final double detectedPercentage;
  static String id = 'Home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String emotion;
  late double percentage;
  late User _currentUser;
  final Uri _url =
  Uri.parse('https://open.spotify.com/show/6GAty5zvy2jgz0cmUVG9qs');
  late List<String> recommendedSongs = [];
  final String apiUrl = 'http://10.7.28.236:6000/recommend_song';

  Future<void> _launchUrl() async {
    try {
      if (!await launch(_url.toString())) {
        throw 'Could not launch $_url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    emotion = widget.detectedEmotion;
    percentage = widget.detectedPercentage;
    _currentUser = FirebaseAuth.instance.currentUser!;
    fetchRecommendedSongs();
  }

  Future<void> fetchRecommendedSongs() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'emotion': emotion}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          recommendedSongs = List<String>.from(data['recommended_songs']);
        });
      } else {
        throw Exception('Failed to fetch recommended songs');
      }
    } catch (e) {
      print('Error fetching recommended songs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String getEmotionImage(String emotion) {
      switch (emotion.toLowerCase()) {
        case 'happy':
          return 'images/very happy Emoji.png';
        case 'sad':
          return 'images/sad emoji.png';
        case 'neutral':
          return 'images/HappyEmoji.png';
        default:
          return 'images/normal emoji.png'; // Default image
      }
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            HeroSection(
              name: _currentUser.email?.split('@').first ?? 'User',
              pfp: 'images/PFP.png',
            ),
            Heading(
              heading: "Today's Overview",
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Center(
                child: Row(
                  children: [
                    Container(
                      height: 270,
                      child: CardWidget(
                        color: Color(0xFFFCEBE5),
                        heading: 'Mood and Emotions',
                        subText: emotion,
                        mood: Image.asset(
                          getEmotionImage(emotion),
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Heading(
              heading: 'Health Journal',
            ),
            Container(
              height: 214, // Adjust the height as needed
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    MyHeatMap(),
                  ],
                ),
              ),
            ),
            Heading(
              heading: 'Recommended Resources',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Color(0xFF9ACDFF),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: Color(0xFFDEEEFF),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Image.asset(
                                  'images/mic.png',
                                  scale: 3,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Morning Meditation',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  VideoSection(),
                  SizedBox(height: 20),
                  if (recommendedSongs.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Heading(heading: 'Recommended Songs'),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: recommendedSongs.length,
                              itemBuilder: (context, index) {
                                final song = recommendedSongs[index];
                                return ListTile(
                                  title: Text(song),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'images/spotify.png',
                          height: 30,
                          width: 30,
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: _launchUrl,
                          child: Text(
                            'Explore',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(
                              Color(0xFF7C16E2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: Text(
                          'Explore hundreds of podcasts on mental relaxation and managing stress and nervousness.',
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Bottom_Bar(),
    );
  }
}

