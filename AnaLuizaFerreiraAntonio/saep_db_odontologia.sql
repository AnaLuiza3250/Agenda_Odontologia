-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Tempo de geração: 24/11/2026 às 16:31
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `saep_db_odontologia`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `agendamento`
--

CREATE TABLE `agendamento` (
  `id_agendamento` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_paciente` int(11) NOT NULL,
  `data_consulta` datetime NOT NULL,
  `observacoes` varchar(255) DEFAULT NULL,
  `status` enum('Agendado','Cancelado') NOT NULL DEFAULT 'Agendado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `agendamento`
--

INSERT INTO `agendamento` (`id_agendamento`, `id_usuario`, `id_paciente`, `data_consulta`, `observacoes`, `status`) VALUES
(1, 1, 1, '2026-11-03 09:00:00', 'Avaliação inicial e profilaxia', 'Agendado'),
(2, 1, 2, '2026-11-05 14:30:00', 'Aplicação de flúor', 'Agendado'),
(3, 1, 3, '2026-11-09 10:00:00', 'Limpeza e raspagem', 'Agendado'),
(4, 1, 4, '2026-11-11 15:00:00', 'Manutenção de aparelho ortodôntico', 'Agendado'),
(5, 1, 5, '2026-11-12 16:30:00', 'Restauração simples molar inferior', 'Agendado'),
(6, 1, 6, '2026-11-16 08:30:00', 'Retorno pós-procedimento', 'Cancelado'),
(7, 1, 7, '2026-11-18 11:00:00', 'Avaliação ortodôntica', 'Agendado'),
(8, 1, 8, '2026-11-19 14:00:00', 'Extração de dente decíduo', 'Agendado'),
(9, 1, 9, '2026-11-23 09:30:00', 'Clareamento dental - 1ª sessão', 'Agendado'),
(10, 1, 10, '2026-11-24 14:00:00', 'Profilaxia e orientação de higiene', 'Agendado'),
(11, 1, 11, '2026-11-24 15:30:00', 'Selante nos pré-molares', 'Agendado'),
(12, 1, 12, '2026-11-24 17:00:00', 'Dor no dente posterior direito', 'Agendado'),
(13, 1, 13, '2026-11-24 18:00:00', 'Retorno de avaliação', 'Agendado'),
(14, 1, 14, '2026-11-25 10:30:00', 'Manutenção mensal de aparelho', 'Agendado'),
(15, 1, 15, '2026-11-26 13:30:00', 'Tratamento de canal - sessão 1', 'Agendado'),
(16, 1, 16, '2026-11-27 16:00:00', 'Limpeza semestral', 'Agendado'),
(17, 1, 17, '2026-11-30 09:00:00', 'Documentação ortodôntica', 'Cancelado'),
(18, 1, 18, '2026-12-01 10:00:00', 'Avaliação de rotina', 'Agendado'),
(19, 1, 19, '2026-12-02 14:30:00', 'Tratamento de canal - sessão 2', 'Agendado'),
(20, 1, 20, '2026-12-04 11:30:00', 'Aplicação de flúor e limpeza', 'Agendado'),
(21, 1, 21, '2026-12-07 15:00:00', 'Instalação de aparelho fixo', 'Agendado'),
(22, 1, 22, '2026-12-09 16:30:00', 'Restauração estética', 'Agendado'),
(23, 1, 23, '2026-12-11 08:30:00', 'Consulta de retorno', 'Agendado'),
(24, 1, 24, '2026-12-14 14:00:00', 'Profilaxia infantil', 'Agendado'),
(25, 1, 25, '2026-12-16 17:30:00', 'Clareamento dental - 2ª sessão', 'Agendado'),
(26, 3, 23, '2026-12-15 16:40:00', 'Colocação do aparelho dentário fixo', 'Agendado'),
(27, 1, 12, '2026-11-25 15:00:00', 'Retorno', 'Agendado');

-- --------------------------------------------------------

--
-- Estrutura para tabela `paciente`
--

CREATE TABLE `paciente` (
  `id_paciente` int(11) NOT NULL,
  `id_responsavel` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `cpf` varchar(255) NOT NULL,
  `cpf_hash` varchar(64) NOT NULL,
  `telefone` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `paciente`
--

INSERT INTO `paciente` (`id_paciente`, `id_responsavel`, `nome`, `cpf`, `cpf_hash`, `telefone`) VALUES
(1, 1, 'Lucas Moura', '1YXWmhn0iKa8T0dO+ylNUuBGc+YCXKg6FZYI4xHXj0g=', '2a886552ea266d0bddde8c3c57fc446f9893dd413a1d1bae7df7c048a77366dc', '(11) 98811-2020'),
(2, 1, 'Sofia Moura', 'GgHytpzNUaz3pF+955aZ/+pj0ZjtdIl7cd4H+0cboxk=', 'f6d1e797ac886b3befe0cc077e21aeab0066702388beecf35d85abe72fc38aae', '(11) 98811-2020'),
(3, 1, 'Patrícia Moura', 'jgeOq5lQ8NwzWRWV2hRli7++WIdIR7njgE2CzdKv20g=', '3cf2f22c80e011a4570a269c0d4fd5c7f1080658a602dd916e71ba4f3aadfab3', '(11) 98811-2020'),
(4, 2, 'Gabriel Lima', 'i9z8qsgzT/d3Nsghcb5HMtSWbDRF09fh4G2YoqhSAlY=', 'c7cda4118067fc7e8c92a0967d46eeb4c98e043a453dcbb8e916bbe7b394ce88', '(11) 97722-3030'),
(5, 2, 'Matheus Lima', 'Xovms/MRfdZflwCapIewytjCmdiRfL1zTyve4Qtd84s=', '16f8f65d3afebd414758a74f34a12122a36c8eef989cc915cba8dbd9f69e053d', '(11) 97722-3030'),
(6, 2, 'Laura Lima', 'q6hpJBUok70gGpmsATRo6Yz5/WC9m2gk1q3XgSJbLl4=', '63c275e5767e7a253b0b9c1a4465b424f1d0f8eb41a0897d74c388b450a8b931', '(11) 97722-3030'),
(7, 3, 'Helena Ribeiro', 'VH31nRg/W/0ukVz1h5G/xU3cPGQ8AJbgNxiwiCgUcQs=', '37657f7abf3c3ef0a9ad02d41924a98deeffd096d70b234d09ff69bc12000fd2', '(11) 96633-4040'),
(8, 3, 'Pedro Henrique Ribeiro', 'BQmwQRCQHdDmQ+l8T7RcNQaM2g+SCI5rV5E+ZEtXupQ=', 'd6fb1f7ee52f97348c97af7327f5efaf560da8de44d082a36b6c0d85ad285956', '(11) 96633-4040'),
(9, 3, 'Sandra Ribeiro', 'tWKI5pXYfYcEC5/XJ9V307sg2w3vX/RHyF3M3nWWjIg=', 'eeec3fb0a419b2ac40a86ee402fb5bad09c8cee5dda37f5132e2466877d26bab', '(11) 96633-4040'),
(10, 4, 'Arthur Carvalho', 'MObMGWezMixdcvVD2LHZI+6SPWagdkcHGjBsq2ifk/w=', '1bf65c9e58588fec35f759a10614af41aa8c98fd2355d96013dafba0c2c5b2c7', '(11) 95544-5050'),
(11, 4, 'Isabella Carvalho', 'vo9QcMlna9B8MCw6ZD80BctQBiW7Q8cx2GF1IguGpLI=', 'f8dbf3e484458dd76d575b851dbeefdcd0dcfa47aff664e3362e2f94e4a6c277', '(11) 95544-5050'),
(12, 4, 'Davi Carvalho', 'nhFHxpcLYL6WojFe3ZnaEbxrUiEQ65yIMI/6TeqAPTc=', 'a431cd909918a98bbc8f3a184f7cad138377237446d89baf90dc37b48a0ecb16', '(11) 95544-5050'),
(13, 5, 'Alice Nogueira', 'IfFAoSbVKfuAw8HvrzVUlww5RNSxyyJZeu3B0lwtkTE=', '03ba62ac49c40843f2745217b6707318201530157d4077fa2e620bbdda710cb1', '(15) 99123-4567'),
(14, 5, 'Bernardo Nogueira', 'P7n2VW65t9xmT9Dy8SwmDnBPXEu/hei1MRkfsdQNuAk=', '1054496184ba6d4634ef963b34f7d91fc725a694999285bf55ab53819c6584be', '(15) 99123-4567'),
(15, 5, 'Camila Nogueira', '02C4DLeEBJCB5pDL7jnTPbHpA7qkkswGgDlerPLs/Dc=', '8bb2c9067fd324fc4e4932b78b8fe0876411940de56f9858512f948e7ee5f9c2', '(15) 99123-4567'),
(16, 6, 'Enzo Teixeira', '1cXMtwncXQPN5YShW6ia+cUH3sWKsoIqKBn49gIbGFg=', '0698a0c65b08df13d03a33a1cf49bfe863105de1ddbc72683ab5c85e905f25b8', '(15) 99234-5678'),
(17, 6, 'Valentina Teixeira', 'mSndHE/d9T/Xa3ZLfviEHuY9WeUBZ0ubN84YeWCQrN8=', '59b08cef2c65438febe441c5228e0b28e3efa6077201512c1ca16636c559a901', '(15) 99234-5678'),
(18, 6, 'Heitor Teixeira', 'mcgkr3g56Beh7KLyuqzOsyhrQ6dKDSE/EZK9gdSERV0=', 'eba1c11aea6a3f97d4d6ad8ad4015b706bc0ab71ab620ead1a6faf77d79e4ffd', '(15) 99234-5678'),
(19, 6, 'Marcelo Teixeira', '2Ha7mR1OsiwJFlZ0uxwonMQv10YzJVW3tlDMlTw0fvs=', '6e0777ab3c7600b496b00d3269d72aa3d7e72d6e52e1714f445a9e0c6c90c437', '(15) 99234-5678'),
(20, 7, 'Manuela Vasconcelos', 'xisyeoLd9jL7kRFs9N30BnuR40dyNieIOTNBZ90xhQ0=', '4dfd5069c743783a73d823181e319abadc5aafd5dd230b70e855b94456e3d9ed', '(15) 99345-6789'),
(21, 7, 'Rafael Vasconcelos', '+9XBo2iOxSWrGBYH7YDpBLJDEJ3HcmMC0f1fR4A8W+A=', '3598a34e794d1de3365ea59c4c6301acdcbf11c0e56cc9e8d22ca73754bba4c0', '(15) 99345-6789'),
(22, 7, 'Lívia Vasconcelos', '3TVsabCpvRZ14tDdZJcC3YelfseqG956tGTiwucOQTM=', '405f08bc710dc7f7576dc561d44e1db62cb468665dd68cbdb341ee8796959197', '(15) 99345-6789'),
(23, 8, 'Theo Mendes', 'oKMvsRadqA8tcXeNAIc/KqTKFxbxs80CxOuxWWeJwh0=', 'f10337d1716bc0dde59ac2af58649c6cfd781ea096421fde585d066c84ea6258', '(15) 99456-7890'),
(24, 8, 'Cecília Mendes', 'Yj+VYmQIMF0/5x5Fkj6IJ5F6De5aSQqioAA3iIFVEqU=', '7f46b0c951a758f0a974f3ee67ef2446593d2efb61c90a11e09f72dea034b619', '(15) 99456-7890'),
(25, 8, 'Gustavo Henrique Mendes', '1y+/EQhoXPYC5kUJ1Hv36iYxwhSDPmdGhigtzOM8Zqo=', '67f59fa7b1407020964b496157d8a386bf00d68cec7e02a7be654eb670603187', '(15) 99456-7890');

-- --------------------------------------------------------

--
-- Estrutura para tabela `responsavel`
--

CREATE TABLE `responsavel` (
  `id_responsavel` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `cpf` varchar(255) NOT NULL,
  `cpf_hash` char(64) NOT NULL,
  `telefone` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `endereco` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `responsavel`
--

INSERT INTO `responsavel` (`id_responsavel`, `nome`, `cpf`, `cpf_hash`, `telefone`, `email`, `endereco`) VALUES
(1, 'Patrícia Moura', 'GDdvybymyrNCPGJ+HYOadWcusHqv+tlMa/iPQJlAjvU=', '3cf2f22c80e011a4570a269c0d4fd5c7f1080658a602dd916e71ba4f3aadfab3', '(11) 98811-2020', 'patricia.moura@email.com', 'Rua das Acácias, 210 - São Paulo/SP'),
(2, 'Eduardo Lima', 'gXn9/X8zKvcmBLAVmTWpGyJ7yD+gSzS+QeF4VmFKK1g=', '30987de4ecd1c2170e1bf0cb8da0f2112d79d3988748295f44705c85a7f1b920', '(11) 97722-3030', 'eduardo.lima@email.com', 'Av. Brasil, 1500 - Guarulhos/SP'),
(3, 'Sandra Ribeiro', '2PRDevQ31q3ccartoIQFz3zxfTEv9ZmXf6gi/AVGoCk=', 'eeec3fb0a419b2ac40a86ee402fb5bad09c8cee5dda37f5132e2466877d26bab', '(11) 96633-4040', 'sandra.ribeiro@email.com', 'Rua das Palmeiras, 88 - Osasco/SP'),
(4, 'Fábio Carvalho', 'rzAkgaY90wca92z6QVu6N89aY+Sdr5vb3Nkg7rsZ7IA=', 'd6bfab4c6cbdd0d8624168951b70dd88f8f7769d079ef6f31ae2ed85c97512ca', '(11) 95544-5050', 'fabio.carvalho@email.com', NULL),
(5, 'Camila Nogueira', 'O4P+K06x9aajkW75iHCSJrROpvfweWme4KJQzs9F564=', '8bb2c9067fd324fc4e4932b78b8fe0876411940de56f9858512f948e7ee5f9c2', '(15) 99123-4567', 'camila.nogueira@email.com', 'Rua XV de Novembro, 320 - Boituva/SP'),
(6, 'Marcelo Teixeira', 'Gth+PIBISN+CjJAdJiqOetdbL4G9Sps5FuBOFKcXJFY=', '6e0777ab3c7600b496b00d3269d72aa3d7e72d6e52e1714f445a9e0c6c90c437', '(15) 99234-5678', 'marcelo.teixeira@email.com', 'Av. Célia Lourdes Vercelino, 410 - Boituva/SP'),
(7, 'Renata Vasconcelos', 'M4dhuJU4XzXMBHZIF9l4waqp+ArQ1BFGYZwX5Abiw4A=', '64b2df918c8c09b436fd60529f00edefa3080f5434a6cd2c1b751e41c67ac4b0', '(15) 99345-6789', 'renata.vasco@email.com', 'Rua São João, 95 - Centro'),
(8, 'Gustavo Henrique Mendes', 'wlJ5mZ+L057Gj3IdD/f6UKcgX6u9cPYqMzBto3q25og=', '67f59fa7b1407020964b496157d8a386bf00d68cec7e02a7be654eb670603187', '(15) 99456-7890', 'gustavo.mendes@email.com', NULL);

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha_hash` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `nome`, `email`, `senha_hash`) VALUES
(1, 'Dra. Camila Duarte', 'camila@clinicaodonto.com', '$2y$10$IjNxO30xuxOeUol1eEDMQuTi.zv5n7a..9Xpv.gM2dFYXBZmA4hhy'),
(2, 'Ricardo Alves', 'ricardo@clinicaodonto.com', '$2y$10$i8GXdFTx0wO/X.wPVECLX.waS83Jns3ebOGUSy2cMbLPb4W.Q9FZS'),
(3, 'Beatriz Nogueira', 'beatriz@clinicaodonto.com', '$2y$10$HlMw9ni08DACJjpk7yo4Jexxhsg9kYD.vmQuef8iBvieDx0T2684m');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `agendamento`
--
ALTER TABLE `agendamento`
  ADD PRIMARY KEY (`id_agendamento`),
  ADD KEY `fk_agendamento_usuario` (`id_usuario`),
  ADD KEY `fk_agendamento_paciente` (`id_paciente`);

--
-- Índices de tabela `paciente`
--
ALTER TABLE `paciente`
  ADD PRIMARY KEY (`id_paciente`),
  ADD UNIQUE KEY `cpf_hash` (`cpf_hash`),
  ADD KEY `fk_paciente_responsavel` (`id_responsavel`);

--
-- Índices de tabela `responsavel`
--
ALTER TABLE `responsavel`
  ADD PRIMARY KEY (`id_responsavel`),
  ADD UNIQUE KEY `uq_responsavel_cpf_hash` (`cpf_hash`);

--
-- Índices de tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `uq_usuario_email` (`email`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `agendamento`
--
ALTER TABLE `agendamento`
  MODIFY `id_agendamento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT de tabela `paciente`
--
ALTER TABLE `paciente`
  MODIFY `id_paciente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de tabela `responsavel`
--
ALTER TABLE `responsavel`
  MODIFY `id_responsavel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `agendamento`
--
ALTER TABLE `agendamento`
  ADD CONSTRAINT `fk_agendamento_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`),
  ADD CONSTRAINT `fk_agendamento_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`);

--
-- Restrições para tabelas `paciente`
--
ALTER TABLE `paciente`
  ADD CONSTRAINT `fk_paciente_responsavel` FOREIGN KEY (`id_responsavel`) REFERENCES `responsavel` (`id_responsavel`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
