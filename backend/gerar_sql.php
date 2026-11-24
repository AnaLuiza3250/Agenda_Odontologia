<?php
header('Content-Type: text/plain; charset=utf-8');

const CHAVE_SECRETA = 'clinica-odonto-saep-2026-troque-esta-chave';

function chave_aes() {
    return hash('sha256', CHAVE_SECRETA, true);
}

function criptografar($texto) {
    $iv = random_bytes(16);
    $cifrado = openssl_encrypt($texto, 'aes-256-cbc', chave_aes(), OPENSSL_RAW_DATA, $iv);
    return base64_encode($iv . $cifrado);
}

function hash_cpf($cpf) {
    return hash_hmac('sha256', $cpf, CHAVE_SECRETA);
}

$responsaveis = [
    ['Patrícia Moura', '12345678901', '(11) 98811-2020', 'patricia.moura@email.com', 'Rua das Acácias, 210 - São Paulo/SP'],
    ['Eduardo Lima', '23456789012', '(11) 97722-3030', 'eduardo.lima@email.com', 'Av. Brasil, 1500 - Guarulhos/SP'],
    ['Sandra Ribeiro', '34567890123', '(11) 96633-4040', 'sandra.ribeiro@email.com', 'Rua das Palmeiras, 88 - Osasco/SP'],
    ['Fábio Carvalho', '45678901234', '(11) 95544-5050', 'fabio.carvalho@email.com', null],
    ['Camila Nogueira', '56789012345', '(15) 99123-4567', 'camila.nogueira@email.com', 'Rua XV de Novembro, 320 - Boituva/SP'],
    ['Marcelo Teixeira', '67890123456', '(15) 99234-5678', 'marcelo.teixeira@email.com', 'Av. Célia Lourdes Vercelino, 410 - Boituva/SP'],
    ['Renata Vasconcelos', '78901234567', '(15) 99345-6789', 'renata.vasco@email.com', 'Rua São João, 95 - Centro'],
    ['Gustavo Henrique Mendes', '89012345678', '(15) 99456-7890', 'gustavo.mendes@email.com', null],
];

echo "DELETE FROM agendamento;\nDELETE FROM paciente;\nDELETE FROM responsavel;\n";
echo "ALTER TABLE agendamento AUTO_INCREMENT = 1;\nALTER TABLE paciente AUTO_INCREMENT = 1;\nALTER TABLE responsavel AUTO_INCREMENT = 1;\n\n";

echo "INSERT INTO responsavel (nome, cpf, cpf_hash, telefone, email, endereco) VALUES\n";
$linhasResp = [];
foreach ($responsaveis as $r) {
    $end = $r[4] === null ? 'NULL' : "'" . addslashes($r[4]) . "'";
    $linhasResp[] = "  ('{$r[0]}', '" . criptografar($r[1]) . "', '" . hash_cpf($r[1]) . "', '{$r[2]}', '{$r[3]}', {$end})";
}
echo implode(",\n", $linhasResp) . ";\n\n";

$pacientes = [
    [1, 'Lucas Moura', '11122233301', '(11) 98811-2020'],
    [1, 'Sofia Moura', '11122233302', '(11) 98811-2020'],
    [1, 'Patrícia Moura', '12345678901', '(11) 98811-2020'],
    [2, 'Gabriel Lima', '22233344401', '(11) 97722-3030'],
    [2, 'Matheus Lima', '22233344402', '(11) 97722-3030'],
    [2, 'Laura Lima', '22233344403', '(11) 97722-3030'],
    [3, 'Helena Ribeiro', '33344455501', '(11) 96633-4040'],
    [3, 'Pedro Henrique Ribeiro', '33344455502', '(11) 96633-4040'],
    [3, 'Sandra Ribeiro', '34567890123', '(11) 96633-4040'],
    [4, 'Arthur Carvalho', '44455566601', '(11) 95544-5050'],
    [4, 'Isabella Carvalho', '44455566602', '(11) 95544-5050'],
    [4, 'Davi Carvalho', '44455566603', '(11) 95544-5050'],
    [5, 'Alice Nogueira', '55566677701', '(15) 99123-4567'],
    [5, 'Bernardo Nogueira', '55566677702', '(15) 99123-4567'],
    [5, 'Camila Nogueira', '56789012345', '(15) 99123-4567'],
    [6, 'Enzo Teixeira', '66677788801', '(15) 99234-5678'],
    [6, 'Valentina Teixeira', '66677788802', '(15) 99234-5678'],
    [6, 'Heitor Teixeira', '66677788803', '(15) 99234-5678'],
    [6, 'Marcelo Teixeira', '67890123456', '(15) 99234-5678'],
    [7, 'Manuela Vasconcelos', '77788899901', '(15) 99345-6789'],
    [7, 'Rafael Vasconcelos', '77788899902', '(15) 99345-6789'],
    [7, 'Lívia Vasconcelos', '77788899903', '(15) 99345-6789'],
    [8, 'Theo Mendes', '88899900001', '(15) 99456-7890'],
    [8, 'Cecília Mendes', '88899900002', '(15) 99456-7890'],
    [8, 'Gustavo Henrique Mendes', '89012345678', '(15) 99456-7890'],
];

echo "INSERT INTO paciente (id_responsavel, nome, cpf, cpf_hash, telefone) VALUES\n";
$linhasPac = [];
foreach ($pacientes as $p) {
    $linhasPac[] = "  ({$p[0]}, '{$p[1]}', '" . criptografar($p[2]) . "', '" . hash_cpf($p[2]) . "', '{$p[3]}')";
}
echo implode(",\n", $linhasPac) . ";\n\n";

echo <<<SQL
INSERT INTO agendamento (id_usuario, id_paciente, data_consulta, observacoes, status) VALUES
  (1, 1,  '2026-11-03 09:00:00', 'Avaliação inicial e profilaxia', 'Agendado'),
  (1, 2,  '2026-11-05 14:30:00', 'Aplicação de flúor', 'Agendado'),
  (1, 3,  '2026-11-09 10:00:00', 'Limpeza e raspagem', 'Agendado'),
  (1, 4,  '2026-11-11 15:00:00', 'Manutenção de aparelho ortodôntico', 'Agendado'),
  (1, 5,  '2026-11-12 16:30:00', 'Restauração simples molar inferior', 'Agendado'),
  (1, 6,  '2026-11-16 08:30:00', 'Retorno pós-procedimento', 'Cancelado'),
  (1, 7,  '2026-11-18 11:00:00', 'Avaliação ortodôntica', 'Agendado'),
  (1, 8,  '2026-11-19 14:00:00', 'Extração de dente decíduo', 'Agendado'),
  (1, 9,  '2026-11-23 09:30:00', 'Clareamento dental - 1ª sessão', 'Agendado'),
  (1, 10, '2026-11-24 14:00:00', 'Profilaxia e orientação de higiene', 'Agendado'),
  (1, 11, '2026-11-24 15:30:00', 'Selante nos pré-molares', 'Agendado'),
  (1, 12, '2026-11-24 17:00:00', 'Dor no dente posterior direito', 'Agendado'),
  (1, 13, '2026-11-24 18:00:00', 'Retorno de avaliação', 'Agendado'),
  (1, 14, '2026-11-25 10:30:00', 'Manutenção mensal de aparelho', 'Agendado'),
  (1, 15, '2026-11-26 13:30:00', 'Tratamento de canal - sessão 1', 'Agendado'),
  (1, 16, '2026-11-27 16:00:00', 'Limpeza semestral', 'Agendado'),
  (1, 17, '2026-11-30 09:00:00', 'Documentação ortodôntica', 'Cancelado'),
  (1, 18, '2026-12-01 10:00:00', 'Avaliação de rotina', 'Agendado'),
  (1, 19, '2026-12-02 14:30:00', 'Tratamento de canal - sessão 2', 'Agendado'),
  (1, 20, '2026-12-04 11:30:00', 'Aplicação de flúor e limpeza', 'Agendado'),
  (1, 21, '2026-12-07 15:00:00', 'Instalação de aparelho fixo', 'Agendado'),
  (1, 22, '2026-12-09 16:30:00', 'Restauração estética', 'Agendado'),
  (1, 23, '2026-12-11 08:30:00', 'Consulta de retorno', 'Agendado'),
  (1, 24, '2026-12-14 14:00:00', 'Profilaxia infantil', 'Agendado'),
  (1, 25, '2026-12-16 17:30:00', 'Clareamento dental - 2ª sessão', 'Agendado');
SQL;