INSERT INTO pessoa (id_pessoa, nome, cpf, email, telefone) VALUES
(1, 'Ana Clara', '111.111.111-11', 'ana@email.com', '11988888888'),
(2, 'Bruno Mendes', '222.222.222-22', 'bruno@email.com', '11977777777'),
(3, 'Carlos Silva', '333.333.333-33', 'carlos@email.com', '11966666666'),
(4, 'Diana Rosa', '444.444.444-44', 'diana@email.com', '11955555555'),
(5, 'Eduardo Costa', '555.555.555-55', 'eduardo@email.com', NULL)
ON CONFLICT (id_pessoa) DO NOTHING;