INSERT INTO fila (id_fila, nome, descricao, prioridade, ativa) VALUES
(1, 'Suporte Técnico', 'Resolução de problemas de software e hardware', 2, TRUE),
(2, 'Financeiro', 'Cobranças, faturas e renegociações', 1, TRUE),
(3, 'Ouvidoria', 'Reclamações críticas e sugestões', 3, TRUE)
ON CONFLICT (id_fila) DO NOTHING;