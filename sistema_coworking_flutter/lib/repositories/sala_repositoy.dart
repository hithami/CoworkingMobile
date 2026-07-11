import '../core/database/database_helper.dart'; 
import '../models/sala.dart'; 
 
class SalaRepository { 

  final DatabaseHelper banco = DatabaseHelper.banco; 

  //metodo inserir 
  Future<void> inserirSala(Sala sala) async { 
     
    final db = await banco.conexao; 
     
    await db.insert( 
      'sala', 
       sala.toMap() 
    );
  } 
   
  //metodo listar 
  Future<List<Sala>> listarSalas() async { 
     
    final db = await banco.conexao; 

    final List<Map<String, dynamic>> resultado = await db.query('sala'); 
     
    return resultado.map((item) => Sala.fromMap(item)).toList();
    
  }
}