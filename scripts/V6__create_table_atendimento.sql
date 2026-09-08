CREATE TABLE IF NOT EXISTS atendimento (
    id_atendimento BIGSERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_atendente INT NOT NULL,
    id_fila INT NOT NULL,
    data_hora_inicio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_hora_fim TIMESTAMP,
    status VARCHAR(30) DEFAULT 'Em Andamento' 
        CHECK (status IN ('Em Andamento', 'Concluído', 'Cancelado')),
    observacoes TEXT,
    CONSTRAINT fk_atendimento_cliente FOREIGN KEY (id_cliente) 
        REFERENCES cliente (id_cliente) ON DELETE RESTRICT,
    CONSTRAINT fk_atendimento_atendente FOREIGN KEY (id_atendente) 
        REFERENCES atendente (id_atendente) ON DELETE RESTRICT,
    CONSTRAINT fk_atendimento_fila FOREIGN KEY (id_fila) 
        REFERENCES fila (id_fila) ON DELETE RESTRICT,
    CONSTRAINT chk_datas CHECK (data_hora_fim IS NULL OR data_hora_fim >= data_hora_inicio)
);