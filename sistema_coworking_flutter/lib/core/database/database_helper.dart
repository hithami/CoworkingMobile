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
      onConfigure: (db) async { 
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async { 
         
        final tabelas = [ 
          createTableSala, 
          createTableAgendamento, 
          createTableLog,
        ]; 
         
        final triggers = [ 
          createTriggerSalaInsert, 
          createTriggerSalaUpdate, 
          createTriggerSalaDelete, 
          createTriggerAgendamentoInsert, 
          createTriggerAgendamentoUpdate, 
          createTriggerAgendamentoDelete, 
          createTriggerBloqueioDeletarSala, 
          createTriggerBloqueioSobreposicaoAgendamento, 
          createTriggerBloqueioSobreposicaoAgendamentoUpdate,
        ]; 
         
        for (final tabela in tabelas) { 
          await db.execute(tabela);
        } 
         
        for (final trigger in triggers) { 
          await db.execute(trigger);
        }
      },
    );
  }
}