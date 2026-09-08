INSERT INTO cliente (id_cliente, categoria) VALUES
(1, 'VIP'),
(2, 'Padrão'),
(4, 'Corporativo'),
(5, 'Padrão')
ON CONFLICT (id_cliente) DO NOTHING;

INSERT INTO atendente (id_atendente, matricula, data_admissao, ativo) VALUES
(3, 'MAT-2026-001', '2026-01-10', TRUE),
(4, 'MAT-2026-002', '2026-02-15', TRUE)
ON CONFLICT (id_atendente) DO NOTHING;