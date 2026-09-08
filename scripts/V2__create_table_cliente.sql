CREATE TABLE IF NOT EXISTS cliente (
    id_cliente INT PRIMARY KEY,
    categoria VARCHAR(50) DEFAULT 'Padrão',
    CONSTRAINT fk_cliente_pessoa FOREIGN KEY (id_cliente) 
        REFERENCES pessoa (id_pessoa) ON DELETE CASCADE
);