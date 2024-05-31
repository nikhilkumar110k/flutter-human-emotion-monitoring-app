import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:onlycode/components/bottom_bar.dart';
import 'package:onlycode/pages/HomePage.dart';
import '../components/bargraph.dart';
import '../components/heatmap1.dart';

class MoodsPage extends StatefulWidget {
  const MoodsPage({
    super.key,

    required this.barValues,
    required this.detectedEmotion,
    required this.detectedPercentage,
  });

  final List<double> barValues;
  final String detectedEmotion;
  final double detectedPercentage;

  @override
  State<MoodsPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodsPage> {
  late String emotion;
  late double percentage;
  late List recommended_songs;
  Color hexToColor(String hexColorCode) {
    hexColorCode = hexColorCode.replaceAll("#", "");
    int hexColorInt = int.parse(hexColorCode, radix: 16);
    return Color(hexColorInt).withOpacity(1.0);
  }
  @override
  void initState() {
    super.initState();
    emotion = widget.detectedEmotion;
    percentage = widget.detectedPercentage;
  }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Container(
          height: 230,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/moods_bg.png"),
                  fit: BoxFit.cover)),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(top: 30.0, left: 5.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Image.asset('assets/images/back_arrow.png'),
                    iconSize: 30,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            detectedEmotion: emotion,
                            detectedPercentage: percentage
                          ),
                        ),
                      );
                    },
                  ),
                  const Text(
                    "Mood and Emotions",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text("Today’s Overview",
                          style:
                          TextStyle(color: Color(0xffB1B1B2), fontSize: 16)),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                const Text(
                                  "Mood",
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  emotion,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 115,
                            ),
                            child: Row(children: [
                              Text(
                                "${percentage}% ",
                                style: const TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.w500),
                              ),
                              Container(
                                  child:
                                  Image.asset(
                                    getEmotionImage(emotion),
                                    height: 60,
                                    width: 60,
                                  ))
                            ]),
                          ),
                        ],
                      ),
                    ))
              ]),
            )
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 0, bottom: 10),
          child: Column(children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("Statistics",
                    style: TextStyle(color: Color(0xff8F8F8F), fontSize: 16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: BarGraph(barValues: widget.barValues),
            )
          ]),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 30, left: 20),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Trigger",
                      style: TextStyle(color: Color(0xff8F8F8F), fontSize: 16)),
                ),
              ),
              Container(
                height: 214,
                child: const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      MyHeatMap(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Bottom_Bar(),
    );
  }
}
