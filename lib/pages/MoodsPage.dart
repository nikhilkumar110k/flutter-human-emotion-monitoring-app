import 'package:flutter/material.dart';
import '../components/bargraph.dart';
import '../components/heatmap1.dart';
class  MoodsPage extends StatefulWidget {
  const  MoodsPage({super.key,required this.tiggers,required this.emotions,required this.barValues});
  final List<Map<String,String>> tiggers;
  final List<Map<String,String>> emotions;
  final List<double> barValues;
  @override
  State<MoodsPage> createState() => _MoodPageState();
}
class _MoodPageState extends State<MoodsPage> {
  Color hexToColor(String hexColorCode) {
    hexColorCode = hexColorCode.replaceAll("#", "");
    int hexColorInt = int.parse(hexColorCode, radix: 16);
    return Color(hexColorInt).withOpacity(1.0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: 
    ListView(children:[
      Container(height: 230,
      decoration: const BoxDecoration(image: DecorationImage(image:AssetImage("assets/images/moods_bg.png"),fit: BoxFit.cover))
      ,
      child: Column(children: [
        Padding(padding: EdgeInsets.only(top: 30.0,left: 10.0),child: 
          Row(children: [
          IconButton(
          icon: Image.asset('assets/images/back_arrow.png'),
          iconSize: 30,
          onPressed: () {
            Navigator.pop(context);
          },
),
  const Text("Mood and Emotions",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)      
        
        ],)
        ,),
       Padding(padding:const EdgeInsets.only(top: 30),child: Column(
        children: [const Align(alignment: Alignment.centerLeft,child:Padding(padding: EdgeInsets.only(left: 20),
        child: Text("Today’s Overview",
        style: TextStyle(color: Color(0xffB1B1B2),fontSize: 16)),) ),
        Padding(padding: EdgeInsets.only(left: 20,right: 20),child:         
        Row(
          children: [
          const Align(alignment: Alignment.centerLeft,
          child:Column(children: [
            Text("Mood",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
            Text("Happy",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
            ],
            ),
          ),
          Padding(padding: EdgeInsets.only(left:130,),
          child: 
          Row(children: [
            const Text("85% ",style: TextStyle(fontSize: 40,fontWeight: FontWeight.w500),)
          ,Container(child: Image.asset("assets/images/happy.png",height: 60,width: 60,))]),) ,
        ],)
        )
      ]),
      )
      ]),
      ),
     Padding(padding: EdgeInsets.only(top: 30,left: 20),
      child: Column(children:[const Padding(padding: EdgeInsets.only(bottom: 10),child: Row(
        children: [
       Align(alignment: Alignment.centerLeft,child: Text("Trigger",
      style: TextStyle(color: Color(0xff8F8F8F),fontSize: 16)),)
        ,
       Padding(padding: EdgeInsets.only(left: 130),child: Text("Emotions",
      style: TextStyle(color: Color(0xff8F8F8F),fontSize: 16)),)
        ]
      )),
      Row(
        children: [
          Column(
  children: widget.tiggers.map((e)=>Row(children:[
    Padding(padding: EdgeInsets.only(right:2,bottom: 6),child:Container(width: 100,
    child:Text(e["name"].toString(),style:
    const  TextStyle(fontSize: 16,fontWeight: FontWeight.bold)) ,
    )),Text(e["value"].toString(),style: 
    const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
    ])).toList()
  ),
  Padding(padding: EdgeInsets.only(left: 50),child: 
    Column(
  children: widget.emotions.map((e)=>Row(children:[
    Padding(padding: EdgeInsets.only(right:2,bottom:6),child:
    Container(width: 100,child:Text(e["name"].toString(),style:
    TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: hexToColor(e["color"].toString()))) ,
    )),Container(
      width: 40,
      decoration: BoxDecoration(
      color: hexToColor(e["color"].toString()),
      borderRadius: const BorderRadius.all(Radius.elliptical(10, 20))
    )
    ,child: 
    Center(child:Text(e["value"].toString(),
    style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
    ,))
    ,
    ])).toList()
  ),)
  ],
      )]),
      ),
      Padding(padding: const EdgeInsets.only(top: 20,left: 20,bottom: 10),
      child: Column(children: [
      const  Align(alignment: Alignment.centerLeft,child: Text("Statistics",
      style: TextStyle(color: Color(0xff8F8F8F),fontSize: 16)),)
      ,
      Padding(padding:const EdgeInsets.only(top: 20)
      ,child: 
      BarGraph(barValues:widget.barValues)
      ,
      )
      ]),
      )
      ,
      const Padding(padding: EdgeInsets.only(top:20,bottom: 30,left: 20),
      child: Column(
        children: [
        Padding(padding: EdgeInsets.only(bottom: 20),
        child:         
      Align(alignment: Alignment.centerLeft,child: Text("Trigger",
      style: TextStyle(color: Color(0xff8F8F8F),fontSize: 16)),)
        ,)
          ,MyHeatMap()
        ],
      ),
      ) 
      ])
      );
  }
}