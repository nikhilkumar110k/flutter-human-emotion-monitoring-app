import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onlycode/Api/Emotions.dart';
class Api{
  static const _tellEmotions='http://127.0.0.1:3000';



  Future<List<Emotions>> getPopularMovies() async{
    final response= await http.get(Uri.parse(_tellEmotions));
    if(response.statusCode == 200){
      final decodeddata= json.decode(response.body)[['emotion','percentage', 'recommended_songs']] as List;
      return decodeddata.map((movie) => Emotions.fromJson(movie)).toList();
    }else{
      throw Exception('Something went wrong');
    }
  }

}