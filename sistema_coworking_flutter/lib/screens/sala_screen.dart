import 'package:flutter/material.dart'; 
import '../models/sala.dart'; 
import '../repositories/sala_repository.dart';
 
 
class SalaScreen extends StatefulWidget {  
   
  const SalaScreen({super.key});
   
  @override 
  State<SalaScreen> createState() { 
    return _SalaScreenState();
  } 
} 
 
class _SalaScreenState extends State<SalaScreen> { 
   
  final TextEditingController _nomeSalaController = TextEditingController(); 
  final SalaRepository _salaRepository = SalaRepository(); 
  List<Sala> _salas = []; 

  @override  
  Widget build(BuildContext context) { 
    return Scaffold( 

      appBar: AppBar( 
        centerTitle: true,
        title: Text('Salas', 
        style: TextStyle( 
          fontSize: 23, 
          ), 
        ),
      ), 

      body: Padding( 
        padding: EdgeInsets.all(50), 
        child: Column( 
          children: [ 
             
            Text( 
              'Nome da Sala', 
              style: TextStyle( 
                fontWeight: FontWeight.bold, 
                fontSize: 23,
              ),
            ), 

            SizedBox( 
              height: 20,
            ), 
             
            TextField( 
              controller: _nomeSalaController, 
              decoration: InputDecoration( 
                hintText: 'Digite o nome da nova sala', 
                border: OutlineInputBorder( 
                  borderRadius: BorderRadius.circular(50)
                ),
              ),
            ), 
             
            SizedBox( 
              height: 20,
            ), 
             
            ElevatedButton( 
              onPressed: () async {
                  
                try { 

                  Sala novaSala = Sala( 
                  nomeSala: _nomeSalaController.text
                  );  
                 
                  await _salaRepository.inserirSala(novaSala); 

                  if (!mounted) return; 
                 
                  ScaffoldMessenger.of(context).showSnackBar( 
                    SnackBar(content: Text( 
                      'Sala cadastrada com sucesso!') 
                    ) 
                  );
                 
                  _nomeSalaController.clear();  

                } 
                catch (erro) { 

                  if (!mounted) return; 

                  if(erro.toString().contains("UNIQUE")) { 

                    ScaffoldMessenger.of(context).showSnackBar( 
                      SnackBar(content: Text( 
                        "Já existe uma sala com esse nome!") 
                      ) 
                    ); 

                  } else { 
                     
                    ScaffoldMessenger.of(context).showSnackBar( 
                      SnackBar(content: Text( 
                        "Ocorreu um erro ao cadastrar a sala.") 
                      ) 
                    );
                  }
                }
    
            }, 
               
              child: Text( 
                'Criar Sala'
              ),
            ), 
             
            
          ],
        ),
      ), 

    );
  }
}