CREATE TABLE IF NOT EXISTS atendente_fila (
    id_atendente INT NOT NULL,
    id_fila INT NOT NULL,
    data_vinculo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_atendente, id_fila),
    CONSTRAINT fk_af_atendente FOREIGN KEY (id_atendente) 
        REFERENCES atendente (id_atendente) ON DELETE CASCADE,
    CONSTRAINT fk_af_fila FOREIGN KEY (id_fila) 
        REFERENCES fila (id_fila) ON DELETE CASCADE
);