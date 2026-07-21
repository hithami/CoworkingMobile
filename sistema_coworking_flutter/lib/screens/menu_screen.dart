import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: Center(  
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //alinhando itens da coluna no centro
          children: [ 
            Text('Sistema Coworking'), 

            SizedBox(height: 30),
             
            ElevatedButton(  
              onPressed: () {}, 
              child: Text('Salas'),  
            ), 

            SizedBox(height: 20),
             
            ElevatedButton(  
              onPressed: () {}, 
              child: Text('Agendamentos'),
            )
          ],
        )
      ), 
    );
  }
}