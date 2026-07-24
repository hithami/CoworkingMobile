import 'package:flutter/material.dart'; 
 
class SalaScreen extends StatefulWidget { 
   
  @override 
  State<SalaScreen> createState() { 
    return _SalaScreenState();
  } 
} 
 
class _SalaScreenState extends State<SalaScreen> { 
  
  @override  
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: Column( 
        children: [ 
          Text('Salas')
        ],
      ) 

    );
  }
}