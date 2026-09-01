-- tabela sala
CREATE TABLE sala (
    id_sala INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_sala TEXT NOT NULL UNIQUE CHECK (LENGTH(nome_sala) > 0)
);

-- tabela agendamento
CREATE TABLE agendamento (
    id_agendamento INTEGER PRIMARY KEY AUTOINCREMENT,
    data_hora_inicio TEXT NOT NULL,
    data_hora_fim TEXT NOT NULL,
    id_sala INTEGER NOT NULL,
    FOREIGN KEY (id_sala) REFERENCES sala(id_sala),
    CHECK (data_hora_fim > data_hora_inicio)
);

-- tabela log
CREATE TABLE log_operacao (
    id_log INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_tabela TEXT NOT NULL,
    tipo_operacao TEXT NOT NULL
        CHECK (tipo_operacao IN ('INSERT', 'UPDATE', 'DELETE')),
    data_hora_operacao TEXT DEFAULT CURRENT_TIMESTAMP
);

-- triggers de log

-- sala
CREATE TRIGGER log_sala_insert
AFTER INSERT ON sala
FOR EACH ROW
BEGIN
    INSERT INTO log_operacao (nome_tabela, tipo_operacao)
    VALUES ('sala', 'INSERT');
END;

CREATE TRIGGER log_sala_update
AFTER UPDATE ON sala
FOR EACH ROW
BEGIN
    INSERT INTO log_operacao (nome_tabela, tipo_operacao)
    VALUES ('sala', 'UPDATE');
END;

CREATE TRIGGER log_sala_delete
AFTER DELETE ON sala
FOR EACH ROW
BEGIN
    INSERT INTO log_operacao (nome_tabela, tipo_operacao)
    VALUES ('sala', 'DELETE');
END;

-- agendamento
CREATE TRIGGER log_agendamento_insert
AFTER INSERT ON agendamento
FOR EACH ROW
BEGIN
    INSERT INTO log_operacao (nome_tabela, tipo_operacao)
    VALUES ('agendamento', 'INSERT');
END;

CREATE TRIGGER log_agendamento_update
AFTER UPDATE ON agendamento
FOR EACH ROW
BEGIN
    INSERT INTO log_operacao (nome_tabela, tipo_operacao)
    VALUES ('agendamento', 'UPDATE');
END;

CREATE TRIGGER log_agendamento_delete
AFTER DELETE ON agendamento
FOR EACH ROW
BEGIN
    INSERT INTO log_operacao (nome_tabela, tipo_operacao)
    VALUES ('agendamento', 'DELETE');
END;

-- triggers de validação

-- impede excluir sala com agendamento futuro
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

-- impede sobreposição de agendamento ao criar
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

-- impede sobreposição de agendamento ao editar/atualizar
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
