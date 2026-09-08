# Sistema de Atendimento
Atividade 2 de Introdução a Banco de Dados: ciclo de vida completo do desenvolvimento de um banco de dados relacional, utilizando o SGBD PostgreSQL.

## Tema
 Implementação de um sistema para uma empresa que precisa gerenciar o registro e o fluxo de atendimentos, controlando filas, atendentes e clientes.

## Objetivo Geral
Modelar, estruturar e implementar uma base de dados relacional robusta e normalizada para gerenciar o fluxo operacional de atendimentos em uma organização. O sistema é responsável pelo controle de filas segmentadas por serviço, alocação de atendentes qualificados e registro rastreável de cada atendimento realizado, garantindo a integridade dos dados e o histórico das interações com os clientes.

## Público-alvo
* **Gestores e Supervisores de Atendimento:** Necessitam monitorar o volume de atendimentos por fila, tempos médios, métricas de produtividade dos atendentes e distribuição da demanda.

* **Atendentes/Operadores:** Profissionais que atuam diretamente prestando suporte ou serviços nas filas designadas.

* **Clientes:** Usuários finais que solicitam e recebem atendimento nos diversos canais/filas da empresa.


## Regras de Negócio
1. **Unificação de Pessoas:** 
   * Um atendente também pode figurar como cliente da empresa. Para evitar duplicidade de dados cadastrais (como CPF, e-mail, telefone e nome) e garantir consistência na integridade referencial, adotou-se a entidade generalizada `pessoa`, especializada em `cliente` e `atendente`.
2. **Filas de Atendimento:**
   * A empresa organiza suas demandas por filas temáticas.
3. **Alocação de Atendentes às Filas (N:N):**
   * Um atendente pode ser habilitado a atender em múltiplas filas, e uma fila pode contar com vários atendentes aptos (`atendente_fila`).
4. **Registro de Atendimentos:**
   * Cada atendimento registra obrigatoriamente: data/hora de início e fim, status, a fila correspondente, o atendente responsável e o cliente atendido.

