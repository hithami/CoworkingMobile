import 'package:path/path.dart'; 
import 'package:sqflite/sqflite.dart'; 
import 'schema.dart';

class DatabaseHelper { 
  // construtor privado
  DatabaseHelper._(); 

  // armazena objeto DatabaseHelper._();
  static final DatabaseHelper banco = DatabaseHelper._(); 

  //guarda conexão com o banco - abre ela
  Database? _database;  
  
  // Retorna a conexão existente ou abre o banco, se necessário
  Future<Database> get conexao async { 
     
    if (_database != null) { 
      return _database!;
    } 
     
    _database = await _abrirBanco(); 
     return _database!;
  } 

  // Abre ou cria o banco de dados
  Future<Database> _abrirBanco() async { 
     
     //retorna pasta em que vamos salvar o arquivo
    final String caminhoBanco = await getDatabasesPath(); 
     
    //retorna pasta + arquivo 
    final String caminhoCompleto = join(caminhoBanco, 'coworking.db'); 
     
    return await openDatabase( 
      caminhoCompleto, 
      version: 1, 
      onCreate: (db, version) async { 
         
        await db.execute(createTableSala); 
        await db.execute(createTableAgendamento); 
        await db.execute(createTableLog); 
         
        await db.execute(createTriggerSalaInsert); 
        await db.execute(createTriggerSalaUpdate); 
        await db.execute(createTriggerSalaDelete); 
         
        await db.execute(createTriggerAgendamentoInsert); 
        await db.execute(createTriggerAgendamentoUpdate); 
        await db.execute(createTriggerAgendamentoDelete); 
         
        await db.execute(createTriggerBloqueioDeletarSala); 
        await db.execute(createTriggerBloqueioSobreposicaoAgendamento); 
        await db.execute(createTriggerBloqueioSobreposicaoAgendamentoUpdate);
      },
    );
  }
}