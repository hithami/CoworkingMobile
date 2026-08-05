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
   
  //metodo editar 
  Future<void> editarSala(Sala sala) async { 
     
    final db = await banco.conexao; 
     
    await db.update( 
      'sala', 
      sala.toMap(), 
      where: 'id_sala = ?', 
      whereArgs: [sala.idSala], 
      );
  } 
   
  //metodo excluir 
  Future<void> excluirSala(int idSala) async { 
     
    final db = await banco.conexao; 

    await db.delete( 
      'sala', 
      where: 'id_sala = ?', 
      whereArgs: [idSala], 
      );
  }
}