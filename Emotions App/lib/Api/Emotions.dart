import 'dart:ffi';
import 'package:flutter/material.dart';



class Emotions{
  String emotion;
  double percentage;
  List recommended_songs;

  Emotions({
    required this.emotion,
    required this.percentage,
    required this.recommended_songs,
  });

  factory Emotions.fromJson(Map<String, dynamic> json){
    return Emotions(
        emotion:json["emotion"].toString(),
        percentage: json["percentage"],
        recommended_songs: json["recommended_songs"]
    );
  }
}
