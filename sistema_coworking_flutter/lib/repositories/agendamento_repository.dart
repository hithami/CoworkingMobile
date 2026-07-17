import '../core/database/database_helper.dart'; 
import '../models/agendamento.dart';  
 
class AgendamentoRepository { 
   
  final DatabaseHelper banco = DatabaseHelper.banco; 
   
  //metodo inserir 
  Future<void> inserirAgendamento(Agendamento agendamento) async { 
     
    final db = await banco.conexao; 

    await db.insert( 
      'agendamento', 
      agendamento.toMap() 
    );
  } 
   
  //metodo listar 
  Future<List<Agendamento>> listarAgendamento() async { 
     
    final db = await banco.conexao; 
     
    final List<Map<String, dynamic>> resultado = await db.rawQuery( 
      ''' 
      SELECT 
        agendamento.id_agendamento, 
        agendamento.data_hora_inicio, 
        agendamento.data_hora_fim, 
        agendamento.id_sala, 
        sala.nome_sala 
      FROM agendamento agendamento 
      INNER JOIN sala sala 
        ON agendamento.id_sala = sala.id_sala 
      '''  
    ); 
     
    return resultado.map((item) => Agendamento.fromMap(item)).toList();
  } 
   
  //metodo editar 
  Future<void> editarAgendamento(Agendamento agendamento) async { 
     
    final db = await banco.conexao; 
     
    await db.update( 
      'agendamento', 
      agendamento.toMap(), 
      where: 'id_agendamento = ?', 
      whereArgs: [agendamento.idAgendamento],
    ); 
  } 
   
  //metodo excluir 
  Future<void> excluirAgendamento(int idAgendamento) async { 
     
    final db = await banco.conexao; 
     
    await db.delete( 
      'agendamento', 
      where: 'id_agendamento = ?', 
      whereArgs: [idAgendamento],
    );
  }
}

