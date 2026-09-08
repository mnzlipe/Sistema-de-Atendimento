CREATE TABLE IF NOT EXISTS fila (
    id_fila SERIAL PRIMARY KEY,
    nome VARCHAR(60) UNIQUE NOT NULL,
    descricao TEXT,
    prioridade INT DEFAULT 1 CHECK (prioridade >= 1),
    ativa BOOLEAN DEFAULT TRUE
);