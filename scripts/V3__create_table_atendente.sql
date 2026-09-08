CREATE TABLE IF NOT EXISTS atendente (
    id_atendente INT PRIMARY KEY,
    matricula VARCHAR(20) UNIQUE NOT NULL,
    data_admissao DATE NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_atendente_pessoa FOREIGN KEY (id_atendente) 
        REFERENCES pessoa (id_pessoa) ON DELETE CASCADE
);