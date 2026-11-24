-- ============================================================
-- saep_db_odontologia  |  Banco inicial do código base
-- Cria a tabela de usuários (login) e a de responsáveis.
-- Execução: phpMyAdmin > Importar
-- ============================================================

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS saep_db_odontologia
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE saep_db_odontologia;

-- USUARIO: quem acessa o sistema (dentistas e recepção da clínica)
CREATE TABLE IF NOT EXISTS usuario (
  id_usuario  INT NOT NULL AUTO_INCREMENT,
  nome        VARCHAR(100) NOT NULL,
  email       VARCHAR(100) NOT NULL,
  senha_hash  VARCHAR(255) NOT NULL,          -- password_hash() do PHP (bcrypt)
  PRIMARY KEY (id_usuario),
  UNIQUE KEY uq_usuario_email (email)
) ENGINE=InnoDB;

-- Logins de teste (e-mail / senha):
--   camila@clinicaodonto.com  / camila123
--   ricardo@clinicaodonto.com / ricardo123
--   beatriz@clinicaodonto.com / beatriz123
INSERT IGNORE INTO usuario (nome, email, senha_hash) VALUES
  ('Dra. Camila Duarte', 'camila@clinicaodonto.com',  '$2y$10$IjNxO30xuxOeUol1eEDMQuTi.zv5n7a..9Xpv.gM2dFYXBZmA4hhy'),
  ('Ricardo Alves',      'ricardo@clinicaodonto.com', '$2y$10$i8GXdFTx0wO/X.wPVECLX.waS83Jns3ebOGUSy2cMbLPb4W.Q9FZS'),
  ('Beatriz Nogueira',   'beatriz@clinicaodonto.com', '$2y$10$HlMw9ni08DACJjpk7yo4Jexxhsg9kYD.vmQuef8iBvieDx0T2684m');

-- ------------------------------------------------------------
-- RESPONSAVEL: pessoa responsável pelo paciente (pode ter vários pacientes)
-- cpf: criptografado com AES-256 (LGPD). Como o texto cifrado muda a cada
-- gravação, cpf_hash guarda uma "impressão digital" do CPF, usada só para
-- impedir CPF repetido e permitir a busca pelo CPF.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS responsavel (
  id_responsavel  INT NOT NULL AUTO_INCREMENT,
  nome            VARCHAR(100) NOT NULL,
  cpf             VARCHAR(255) NOT NULL,
  cpf_hash        CHAR(64)     NOT NULL,
  telefone        VARCHAR(20)  NOT NULL,
  email           VARCHAR(100) NOT NULL,
  endereco        VARCHAR(200) NULL,
  PRIMARY KEY (id_responsavel),
  UNIQUE KEY uq_responsavel_cpf_hash (cpf_hash)
) ENGINE=InnoDB;

-- Responsáveis de teste. Os CPFs estão criptografados e só são lidos
-- com a CHAVE_SECRETA de backend/config.php.
-- CPFs de teste: 246.813.579-28, 135.792.468-28, 864.209.753-10, 975.310.864-84
INSERT IGNORE INTO responsavel (nome, cpf, cpf_hash, telefone, email, endereco) VALUES
  ('Patrícia Moura',  'r7p7ss127sjhbfht8hNNMf3mzwCgB87ESgmk287pSqY=',
     '1dd985a41dab24a8dae01eaba92984dd212c1f748c3397adc4a33bb8bef8ba3d',
     '(11) 98811-2020', 'patricia.moura@email.com', 'Rua das Acácias, 210 - São Paulo/SP'),
  ('Eduardo Lima',    'eHCJpvr4g5PEK4zSgq8t3v8FSEo5tx+5mkCdl8258o8=',
     'f9ed4e5527a09d9613f384656921df608ec36aabeea3fcbf76f253a6b9d1191d',
     '(11) 97722-3030', 'eduardo.lima@email.com', 'Av. Brasil, 1500 - Guarulhos/SP'),
  ('Sandra Ribeiro',  'YyQBYmTEJVwlH6wZR/bdO58so0Ypu5Jkb1WUKpeghaU=',
     '2fff1668aeacf4738d3c264a211d14900710273e7df4f6e782db8df517039ffc',
     '(11) 96633-4040', 'sandra.ribeiro@email.com', 'Rua das Palmeiras, 88 - Osasco/SP'),
  ('Fábio Carvalho',  'iaL+Yl0S4+hWrpXKpFrNQUbB5Uxzae+mqHRtekbN1yM=',
     '9b111b04c66cbff1112ac5894f134c55a7511763c76883a6ea1e4e4ecf5be5e4',
     '(11) 95544-5050', 'fabio.carvalho@email.com', NULL);
