INSERT INTO atendente_fila (id_atendente, id_fila) VALUES
(3, 1), 
(3, 2), 
(4, 1), 
(4, 3)
ON CONFLICT (id_atendente, id_fila) DO NOTHING;

INSERT INTO atendimento (id_atendimento, id_cliente, id_atendente, id_fila, status, observacoes) VALUES
(1, 1, 3, 1, 'Em Andamento', 'Cliente relatou lentidão no acesso ao sistema.'),
(2, 2, 4, 3, 'Concluído', 'Reclamação registrada e encaminhada à gerência.'),
(3, 4, 3, 2, 'Em Andamento', 'Solicitação de segunda via de boleto corporativo.')
ON CONFLICT (id_atendimento) DO NOTHING;