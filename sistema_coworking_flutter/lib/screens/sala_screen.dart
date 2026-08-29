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
  void initState(){ 
    super.initState(); 
    _carregarSalas();
  }
   
  @override  
  void dispose(){ 
    _nomeSalaController.dispose(); 
    super.dispose();
  } 
   
  Future<void> _carregarSalas() async { 
    final salas = await _salaRepository.listarSalas(); 
    setState(() {
      _salas = salas;
    });
  }

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
                  await _carregarSalas();

                  if (!context.mounted) return; 
                
                  ScaffoldMessenger.of(context).showSnackBar( 
                    SnackBar(content: Text( 
                      'Sala cadastrada com sucesso!') 
                    ) 
                  );
                
                  _nomeSalaController.clear();  

                } 
                catch (erro) { 

                  if (!context.mounted) return; 

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
             
            SizedBox( 
              height: 50,
            ), 

            Expanded( 
              child: ListView.builder( 
                itemCount: _salas.length, 
                itemBuilder: (context, index) { 
                  final sala = _salas[index]; 
                  return ListTile( 
                    title: Text(sala.nomeSala), 
                    trailing: Row( 
                      mainAxisSize: MainAxisSize.min, 
                      children: [ 
                        IconButton( 
                          icon: Icon(Icons.edit), 
                          onPressed: () { 

                            final editarController = TextEditingController(text: sala.nomeSala);  
                             
                            showDialog( 
                              context: context, 
                              builder: (context) { 
                                return AlertDialog( 
                                  title: Text('Editar Sala'), 
                                  content: TextField( 
                                    controller: editarController,
                                  ), 
                                  actions: [ 
           
                                    TextButton( 
                                      onPressed: () async { 
                                        Navigator.pop(context); 

                                        try { 

                                          Sala salaEditada = Sala( 
                                            idSala: sala.idSala, 
                                            nomeSala: editarController.text,
                                          ); 
                                           
                                          await _salaRepository.editarSala(salaEditada); 
                                          await _carregarSalas(); 
                                           
                                          if (!context.mounted) return; 
                                           
                                          ScaffoldMessenger.of(context).showSnackBar( 
                                            SnackBar(content: Text("Sala editada com sucesso!")),
                                          ); 

                                        } 
                                        catch (erro) { 
                                           
                                          if(!context.mounted) return; 
                                           
                                          if(erro.toString().contains("UNIQUE")) { 
                                            ScaffoldMessenger.of(context).showSnackBar( 
                                              SnackBar(content: Text("Já existe uma sala com esse nome!")),
                                            );
                                          } else if (erro.toString().contains("CHECK")) { 
                                            ScaffoldMessenger.of(context).showSnackBar( 
                                              SnackBar(content: Text("O nome da sala não pode ser vazio.")),
                                            );
                                          } else { 
                                            ScaffoldMessenger.of(context).showSnackBar( 
                                              SnackBar(content: Text("Ocorreu um erro ao editar a sala."))
                                            );
                                          }
                                        }
                                      }, 
                                      child: Text("Sim"),
                                    ), 
                                     
                                    TextButton( 
                                      onPressed: () { 
                                        Navigator.pop(context);
                                      }, 
                                      child: Text('Não'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ), 
                        IconButton( 
                          icon: Icon(Icons.delete), 
                          onPressed: () { 
                            showDialog( 
                              context: context, 
                              builder: (context) { 
                                return AlertDialog( 
                                  title: Text('Confirmação'), 
                                  content: Text('Tem certeza que deseja excluir essa sala?'), 
                                  actions: [ 
                                     
                                    TextButton( 
                                      onPressed: () async { 
                                      Navigator.pop(context); 

                                      try {
                                        await _salaRepository.excluirSala(sala.idSala!); 
                                        await _carregarSalas(); 
                                        
                                        if(!context.mounted) return; 
                                        
                                        ScaffoldMessenger.of(context).showSnackBar( 
                                          SnackBar(content: Text('Sala excluída com sucesso!')),
                                        );
                                      } catch (erro) {
                                        if (!context.mounted) return;

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Essa sala possui um agendamento futuro e não pode ser excluída.")),
                                        );
                                      }
                                    }, 
                                    child: Text('Sim'),
                                  ), 
                                    TextButton( 
                                      onPressed: () { 
                                        Navigator.pop(context);
                                      }, 
                                      child: Text('Não'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }, 
              ), 
            ),
          ],
        ),
      ), 

    );
  }
}