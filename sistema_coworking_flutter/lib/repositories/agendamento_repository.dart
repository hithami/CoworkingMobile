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
}
 
