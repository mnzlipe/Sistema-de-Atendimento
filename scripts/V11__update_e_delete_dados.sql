-- Validando UPDATE em Atendimento
UPDATE atendimento
SET status = 'Concluído', 
    data_hora_fim = CURRENT_TIMESTAMP, 
    observacoes = 'Lentidão resolvida após limpeza de cache no servidor.'
WHERE id_atendimento = 1;

-- Validando UPDATE em Cliente
UPDATE cliente
SET categoria = 'VIP'
WHERE id_cliente = 2;

-- Validando DELETE na tabela N:N
DELETE FROM atendente_fila
WHERE id_atendente = 3 AND id_fila = 2;

-- Validando DELETE em cascata
-- Ao deletar Eduardo (que não possui histórico restritivo), o banco deleta o registro dele em CLIENTE automaticamente devido ao ON DELETE CASCADE.
DELETE FROM pessoa
WHERE id_pessoa = 5;