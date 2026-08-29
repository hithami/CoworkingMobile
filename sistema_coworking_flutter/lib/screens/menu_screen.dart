import 'package:flutter/material.dart'; 
import 'sala_screen.dart'; 
import 'agendamento_screen.dart';

class MenuScreen extends StatelessWidget { 
   
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: Center(  
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //alinhando itens da coluna no centro
          children: [ 
            Text('Sistema Coworking', 
            style: TextStyle( 
              fontSize: 27
              ), 
            ), 

            SizedBox(height: 30),
             
            ElevatedButton(  
              onPressed: () { 
                //abrir tela salas 
                Navigator.push( 
                  context, 
                  MaterialPageRoute(builder: (context) => SalaScreen() 
                  ),
                );
              }, 
              child: Text('Salas'),  
            ), 

            SizedBox(height: 20),
             
            ElevatedButton(  
              onPressed: () { 
                //abrir tela agendamento 
                Navigator.push( 
                  context, 
                  MaterialPageRoute(builder: (context) => AgendamentoScreen()
                  ), 
                );
              }, 
              child: Text('Agendamentos'),
            )
          ],
        )
      ), 
    );
  }
}