//tabelas 

//tabela sala 
const String createTableSala = ''' 
  CREATE TABLE sala (
    id_sala INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_sala TEXT NOT NULL UNIQUE
); 
''';  

//agendamento 
const String createTableAgendamento = ''' 
  CREATE TABLE agendamento (
    id_agendamento INTEGER PRIMARY KEY AUTOINCREMENT,
    data_hora_inicio TEXT NOT NULL,
    data_hora_fim TEXT NOT NULL,
    id_sala INTEGER NOT NULL,
    FOREIGN KEY (id_sala) REFERENCES sala(id_sala),
    CHECK (data_hora_fim > data_hora_inicio) 
); 
'''; 
 
// tabela log 
const String createTableLog = ''' 
  CREATE TABLE log_operacao (
    id_log INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_tabela TEXT NOT NULL,
    tipo_operacao TEXT NOT NULL
        CHECK (tipo_operacao IN ('INSERT', 'UPDATE', 'DELETE')), 
    data_hora_operacao TEXT DEFAULT CURRENT_TIMESTAMP
); 
'''; 
 
//triggers log
 
//sala 
const String createTriggerSalaInsert = ''' 
  CREATE TRIGGER log_sala_insert
  AFTER INSERT ON sala
  FOR EACH ROW
  BEGIN
    INSERT INTO log_operacao (nome_tabela, tipo_operacao, data_hora_operacao)
    VALUES ('sala', 'INSERT');
  END; 
'''; 
 
const String createTriggerSalaUpdate = ''' 
  CREATE TRIGGER log_sala_update
  AFTER UPDATE ON sala
  FOR EACH ROW
  BEGIN
    INSERT INTO log_operacao (nome_tabela, tipo_operacao, data_hora_operacao)
    VALUES ('sala', 'UPDATE');
  END; 
''';
 
const String createTriggerSalaDelete = ''' 
  CREATE TRIGGER log_sala_delete
  AFTER DELETE ON sala
  FOR EACH ROW
  BEGIN
    INSERT INTO log_operacao (nome_tabela, tipo_operacao, data_hora_operacao)
    VALUES ('sala', 'DELETE');
  END;  
'''; 
 
//agendamento  
 
const String createTriggerAgendamentoInsert = ''' 
  CREATE TRIGGER log_agendamento_insert
  AFTER INSERT ON agendamento
  FOR EACH ROW
  BEGIN
    INSERT INTO log_operacao (nome_tabela, tipo_operacao, data_hora_operacao)
    VALUES ('agendamento', 'INSERT');
  END; 
'''; 
 
const String createTriggerAgendamentoUpdate = ''' 
  CREATE TRIGGER log_agendamento_update
  AFTER UPDATE ON agendamento
  FOR EACH ROW
  BEGIN
    INSERT INTO log_operacao (nome_tabela, tipo_operacao, data_hora_operacao)
    VALUES ('agendamento', 'UPDATE');
  END; 
'''; 
 
const String createTriggerAgendamentoDelete = ''' 
  CREATE TRIGGER log_agendamento_delete
  AFTER DELETE ON agendamento
  FOR EACH ROW
  BEGIN
    INSERT INTO log_operacao (nome_tabela, tipo_operacao, data_hora_operacao)
    VALUES ('agendamento', 'DELETE');
  END; 
'''; 
 
//tigger validacao 
 
//impede excluir sala com agendamento futuro  
const String createTriggerBloqueioDeletarSala = ''' 
  CREATE TRIGGER bloqueio_deletar_sala
  BEFORE DELETE ON sala
  FOR EACH ROW
  BEGIN
    SELECT RAISE (ABORT, 'Essa sala não pode ser deletada pois possui um agendamento futuro.')
    WHERE EXISTS (
        SELECT 1
        FROM agendamento
        WHERE id_sala = OLD.id_sala
        AND data_hora_fim > CURRENT_TIMESTAMP
    );
  END; 
'''; 
 
//impede sobreposição de agendamento 
const String createTriggerBloqueioSobreposicaoAgendamento = ''' 
  CREATE TRIGGER bloqueio_sobreposicao_agendamento
  BEFORE INSERT ON agendamento
  FOR EACH ROW
  BEGIN
    SELECT RAISE (ABORT, 'Sobreposição de agendamento não permitida')
    WHERE EXISTS (
        SELECT 1
        FROM agendamento
        WHERE id_sala = NEW.id_sala
        AND data_hora_inicio < NEW.data_hora_fim
        AND NEW.data_hora_inicio < data_hora_fim
    );
  END; 
'''; 
 
//impede sobreposicap de agendamento ao editar/atualizar 
const String createTriggerBloqueioSobreposicaoAgendamentoUpdate = ''' 
  CREATE TRIGGER bloqueio_sobreposicao_agendamento_update
  BEFORE UPDATE ON agendamento
  FOR EACH ROW
  BEGIN
    SELECT RAISE (ABORT, 'Sobreposição de agendamento não permitida.')
    WHERE EXISTS(
        SELECT 1
        FROM agendamento
        WHERE id_sala = NEW.id_sala
        AND id_agendamento != NEW.id_agendamento
        AND data_hora_inicio < NEW.data_hora_fim
        AND NEW.data_hora_inicio < data_hora_fim
    );
  END; 
''';
