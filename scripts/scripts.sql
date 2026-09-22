-- ============================================================================
-- SISTEMA DE ATENDIMENTO - SCRIPT UNIFICADO (DDL e DML)
-- SGBD: PostgreSQL
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. LIMPEZA PREVENTIVA DA BASE DE DADOS (Eliminação na ordem reversa)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS avaliacao CASCADE;
DROP TABLE IF EXISTS atendimento CASCADE;
DROP TABLE IF EXISTS atendente_fila CASCADE;
DROP TABLE IF EXISTS fila CASCADE;
DROP TABLE IF EXISTS atendente CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;
DROP TABLE IF EXISTS pessoa CASCADE;

-- ----------------------------------------------------------------------------
-- 2. DEFINIÇÃO DE ESTRUTURA (DDL)
-- ----------------------------------------------------------------------------

-- Tabela Base: PESSOA (Generalização)
CREATE TABLE pessoa (
    id_pessoa SERIAL PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(120) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela: CLIENTE (Especialização)
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY,
    categoria VARCHAR(50) DEFAULT 'Padrão',
    CONSTRAINT fk_cliente_pessoa 
        FOREIGN KEY (id_cliente) 
        REFERENCES pessoa (id_pessoa) 
        ON DELETE CASCADE
);

-- Tabela: ATENDENTE (Especialização)
CREATE TABLE atendente (
    id_atendente INT PRIMARY KEY,
    matricula VARCHAR(20) NOT NULL UNIQUE,
    data_admissao DATE NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_atendente_pessoa 
        FOREIGN KEY (id_atendente) 
        REFERENCES pessoa (id_pessoa) 
        ON DELETE CASCADE
);

-- Tabela: FILA
CREATE TABLE fila (
    id_fila SERIAL PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE,
    descricao TEXT,
    prioridade INT DEFAULT 1 CHECK (prioridade >= 1),
    ativa BOOLEAN DEFAULT TRUE
);

-- Tabela Associativa: ATENDENTE_FILA (N:M)
CREATE TABLE atendente_fila (
    id_atendente INT NOT NULL,
    id_fila INT NOT NULL,
    data_vinculo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_atendente, id_fila),
    CONSTRAINT fk_atendente_fila_atendente 
        FOREIGN KEY (id_atendente) 
        REFERENCES atendente (id_atendente) 
        ON DELETE RESTRICT,
    CONSTRAINT fk_atendente_fila_fila 
        FOREIGN KEY (id_fila) 
        REFERENCES fila (id_fila) 
        ON DELETE RESTRICT
);

-- Tabela: ATENDIMENTO
CREATE TABLE atendimento (
    id_atendimento BIGSERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_atendente INT NOT NULL,
    id_fila INT NOT NULL,
    data_hora_inicio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_hora_fim TIMESTAMP,
    status VARCHAR(30) NOT NULL CHECK (status IN ('Em Andamento', 'Concluído', 'Cancelado')),
    observacoes TEXT,
    CONSTRAINT chk_consistencia_datas 
        CHECK (data_hora_fim IS NULL OR data_hora_fim >= data_hora_inicio),
    CONSTRAINT fk_atendimento_cliente 
        FOREIGN KEY (id_cliente) 
        REFERENCES cliente (id_cliente) 
        ON DELETE RESTRICT,
    CONSTRAINT fk_atendimento_atendente 
        FOREIGN KEY (id_atendente) 
        REFERENCES atendente (id_atendente) 
        ON DELETE RESTRICT,
    CONSTRAINT fk_atendimento_fila 
        FOREIGN KEY (id_fila) 
        REFERENCES fila (id_fila) 
        ON DELETE RESTRICT
);

-- Tabela: AVALIACAO (Inovação - Interações Sociais)
CREATE TABLE avaliacao (
    id_avaliacao SERIAL PRIMARY KEY,
    id_atendimento BIGINT NOT NULL UNIQUE,
    nota INT NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,
    curtidas INT DEFAULT 0 CHECK (curtidas >= 0),
    data_avaliacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_avaliacao_atendimento 
        FOREIGN KEY (id_atendimento) 
        REFERENCES atendimento (id_atendimento) 
        ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------
-- 3. POVOAMENTO DE DADOS (DML)
-- ----------------------------------------------------------------------------

-- Inserção de Pessoas
INSERT INTO pessoa (nome, cpf, email, telefone) VALUES
('Luiz Menezes', '111.222.333-44', 'luiz.menezes@empresa.com', '(69) 99111-2233'),
('Mariana Siqueira', '222.333.444-55', 'mariana.siqueira@gmail.com', '(69) 98444-5566'),
('Carlos Eduardo Lima', '333.444.555-66', 'carlos.lima@hotmail.com', '(69) 99777-8899'),
('Renata Vasconcelos', '444.555.666-77', 'renata.vasc@outlook.com', '(69) 98112-3344'),
('Guilherme Rocha', '555.666.777-88', 'guilherme.rocha@empresa.com', '(69) 99234-5678');

-- Especialização em Clientes
INSERT INTO cliente (id_cliente, categoria) VALUES
(2, 'VIP'),
(3, 'Padrão'),
(4, 'Corporativo'),
(1, 'Padrão'); -- O operador Luiz também figura como cliente na base

-- Especialização em Atendentes
INSERT INTO atendente (id_atendente, matricula, data_admissao, ativo) VALUES
(1, '2026-A10', '2025-02-15', TRUE),
(5, '2026-A11', '2025-05-10', TRUE);

-- Criação das Filas
INSERT INTO fila (nome, descricao, prioridade, ativa) VALUES
('Suporte Prioritário', 'Fila dedicada a clientes VIP e urgências operacionais', 3, TRUE),
('Cadastro Geral', 'Triagem de novos registos e atualização documental', 1, TRUE),
('Atendimento Presencial', 'Resolução de pendências em balcão físico', 2, TRUE);

-- Alocação de Atendentes às Filas (N:M)
INSERT INTO atendente_fila (id_atendente, id_fila) VALUES
(1, 1), -- Luiz atende Suporte Prioritário
(1, 2), -- Luiz atende Cadastro Geral
(5, 2), -- Guilherme atende Cadastro Geral
(5, 3); -- Guilherme atende Atendimento Presencial

-- Registo de Atendimentos
INSERT INTO atendimento (id_cliente, id_atendente, id_fila, data_hora_inicio, data_hora_fim, status, observacoes) VALUES
(2, 1, 1, '2026-09-21 14:00:00', '2026-09-21 14:05:00', 'Concluído', 'Documentação emitida com sucesso.'),
(3, 1, 2, '2026-09-21 10:45:00', '2026-09-21 11:00:00', 'Concluído', 'Atualização cadastral e validação de e-mail realizada.'),
(4, 5, 3, '2026-09-20 16:30:00', '2026-09-20 16:45:00', 'Concluído', 'Orientação presencial sobre emissão de contratos.'),
(1, 5, 2, '2026-09-21 15:30:00', NULL, 'Em Andamento', 'Cliente na bancada em análise cadastral.');

-- Registo de Avaliações e Interações Sociais (Mural)
INSERT INTO avaliacao (id_atendimento, nota, comentario, curtidas, data_avaliacao) VALUES
(1, 5, 'Atendimento ágil e muito atencioso do operador. Conseguiu emitir minha documentação em menos de cinco minutos sem nenhuma burocracia.', 14, '2026-09-21 14:22:00'),
(2, 5, 'Excelente postura profissional. Fui bem orientado sobre a validação do meu CPF e dos contatos no sistema.', 8, '2026-09-21 11:05:00'),
(3, 4, 'O sistema organizou a fila de espera com rapidez. O processo de encerramento foi direto e transparente.', 21, '2026-09-20 16:50:00');

-- ----------------------------------------------------------------------------
-- 4. CASOS DE TESTE DE MANIPULAÇÃO E INTEGRIDADE
-- ----------------------------------------------------------------------------

-- Conclusão de atendimento em aberto
UPDATE atendimento 
SET data_hora_fim = CURRENT_TIMESTAMP, 
    status = 'Concluído', 
    observacoes = 'Atendimento finalizado após entrega da documentação.'
WHERE id_atendimento = 4;

-- Registo de interação social (incremento de curtida no mural)
UPDATE avaliacao 
SET curtidas = curtidas + 1 
WHERE id_avaliacao = 1;

-- ----------------------------------------------------------------------------
-- 5. CONSULTA DE DEMONSTRAÇÃO: MURAL SOCIAL DE FEEDBACKS
-- ----------------------------------------------------------------------------
SELECT 
    av.id_avaliacao,
    cli_p.nome AS cliente,
    ate_p.nome AS atendente_responsavel,
    f.nome AS fila,
    av.nota,
    av.comentario,
    av.curtidas,
    av.data_avaliacao
FROM avaliacao av
INNER JOIN atendimento at ON av.id_atendimento = at.id_atendimento
INNER JOIN cliente c ON at.id_cliente = c.id_cliente
INNER JOIN pessoa cli_p ON c.id_cliente = cli_p.id_pessoa
INNER JOIN atendente a ON at.id_atendente = a.id_atendente
INNER JOIN pessoa ate_p ON a.id_atendente = ate_p.id_pessoa
INNER JOIN fila f ON at.id_fila = f.id_fila
ORDER BY av.curtidas DESC;