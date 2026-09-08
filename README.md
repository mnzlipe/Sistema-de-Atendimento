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

## Diagrama do Modelo Relacional (ERD)

O diagrama abaixo representa a estrutura lógica e física das tabelas, chaves primárias (`PK`), chaves estrangeiras (`FK`) e seus respectivos tipos de dados no PostgreSQL, renderizado nativamente pelo GitHub com **Mermaid**:

```mermaid
erDiagram
    PESSOA ||--o| ATENDENTE : "é especializado em"
    PESSOA ||--o| CLIENTE : "é especializado em"
    
    ATENDENTE ||--o{ ATENDENTE_FILA : "está habilitado em"
    FILA ||--o{ ATENDENTE_FILA : "possui atendentes"
    
    ATENDENTE ||--o{ ATENDIMENTO : "realiza"
    CLIENTE ||--o{ ATENDIMENTO : "recebe"
    FILA ||--o{ ATENDIMENTO : "pertence a"

    PESSOA {
        INT id_pessoa PK "SERIAL"
        VARCHAR(120) nome "NOT NULL"
        VARCHAR(14) cpf "UNIQUE, NOT NULL"
        VARCHAR(120) email "UNIQUE, NOT NULL"
        VARCHAR(20) telefone
        TIMESTAMP data_cadastro "DEFAULT CURRENT_TIMESTAMP"
    }

    CLIENTE {
        INT id_cliente PK "FK -> PESSOA.id_pessoa"
        VARCHAR(50) categoria "ex: Padrão, VIP, Corporativo"
    }

    ATENDENTE {
        INT id_atendente PK "FK -> PESSOA.id_pessoa"
        VARCHAR(20) matricula "UNIQUE, NOT NULL"
        DATE data_admissao "NOT NULL"
        BOOLEAN ativo "DEFAULT TRUE"
    }

    FILA {
        INT id_fila PK "SERIAL"
        VARCHAR(60) nome "NOT NULL"
        TEXT descricao
        INT prioridade "DEFAULT 1"
        BOOLEAN ativa "DEFAULT TRUE"
    }

    ATENDENTE_FILA {
        INT id_atendente PK, FK "-> ATENDENTE.id_atendente"
        INT id_fila PK, FK "-> FILA.id_fila"
        TIMESTAMP data_vinculo "DEFAULT CURRENT_TIMESTAMP"
    }

    ATENDIMENTO {
        BIGSERIAL id_atendimento PK
        INT id_cliente FK "NOT NULL -> CLIENTE.id_cliente"
        INT id_atendente FK "NOT NULL -> ATENDENTE.id_atendente"
        INT id_fila FK "NOT NULL -> FILA.id_fila"
        TIMESTAMP data_hora_inicio "NOT NULL DEFAULT CURRENT_TIMESTAMP"
        TIMESTAMP data_hora_fim
        VARCHAR(30) status "ex: Em Andamento, Concluído, Cancelado"
        TEXT observacoes
    }