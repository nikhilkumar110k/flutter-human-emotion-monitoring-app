import 'package:flutter/material.dart';

class Bottom_Bar extends StatefulWidget {
  @override
  State<Bottom_Bar> createState() => _Bottom_BarState();
}
class _Bottom_BarState extends State<Bottom_Bar> {
    @override
      Widget build(BuildContext context) {
        return BottomAppBar(
        color: Colors.black,
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
             InkWell(
onTap: () => {
 Navigator.pushNamed(context, '/home') 
},child: const
Column(
 mainAxisSize: MainAxisSize.min,
  children:[
     Icon(Icons.home_outlined, color: Colors.grey),
     Text("Home",style: TextStyle(color: Colors.white),)
  ]
 )
)
            ,
             InkWell(
onTap: () => {
  Navigator.pushNamed(context, '/mood') 
},child: const
Column(
 mainAxisSize: MainAxisSize.min,
  children:[
     Icon(Icons.bubble_chart_outlined, color: Colors.grey),
     Text("Mood",style: TextStyle(color: Colors.white),)
  ]
 )
)
            ,            InkWell(
onTap: () => {
  Navigator.pushNamed(context, '/chat') 
},child: const
Column(
 mainAxisSize: MainAxisSize.min,
  children:[
     Icon(Icons.chat_outlined, color: Colors.grey),
     Text("Chat",style: TextStyle(color: Colors.white),)
  ]
 )
)
            ,            InkWell(
onTap: () => {
  Navigator.pushNamed(context, '/diary') 
},child: const
Column(
 mainAxisSize: MainAxisSize.min,
  children:[
     Icon(Icons.edit_note_outlined, color: Colors.grey),
     Text("Journal",style: TextStyle(color: Colors.white),)
  ]
 )
)
            ,        
          ],
        ),
      );
      }
}