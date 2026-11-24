<?php
// API de pacientes
//   GET    pacientes.php            lista os pacientes com o nome do responsável (aceita ?busca=termo)
//   GET    pacientes.php?id=1       um paciente, com o CPF completo (para editar)
//   POST   pacientes.php            cadastra
//   PUT    pacientes.php?id=1       atualiza
//   DELETE pacientes.php?id=1       exclui
require __DIR__ . '/../helpers.php';
require __DIR__ . '/../conexao.php';
require __DIR__ . '/../seguranca.php';

exigir_login();

$pdo = conectar();
$metodo = $_SERVER['REQUEST_METHOD'];
$id = $_GET['id'] ?? '';

function tratar_paciente($dados)
{
    return [
        'id_responsavel' => trim($dados['id_responsavel'] ?? ''),
        'nome'           => trim($dados['nome'] ?? ''),
        'cpf'            => preg_replace('/\D/', '', $dados['cpf'] ?? ''),
        'telefone'       => trim($dados['telefone'] ?? ''),
    ];
}

function validar_paciente($pdo, $p)
{
    $erros = [];

    if (!ctype_digit((string)$p['id_responsavel'])) {
        $erros[] = 'Selecione um responsável.';
    } else {
        $comando = $pdo->prepare('SELECT id_responsavel FROM responsavel WHERE id_responsavel = ?');
        $comando->execute([$p['id_responsavel']]);
        if (!$comando->fetch()) {
            $erros[] = 'O responsável selecionado não existe.';
        }
    }

    if ($p['nome'] === '') {
        $erros[] = 'Informe o nome do paciente.';
    } elseif (mb_strlen($p['nome']) > 100) {
        $erros[] = 'O nome aceita no máximo 100 caracteres.';
    }

    if (strlen($p['cpf']) !== 11) {
        $erros[] = 'O CPF deve ter 11 números.';
    }

    $numeros_telefone = strlen(preg_replace('/\D/', '', $p['telefone']));
    if ($numeros_telefone < 10 || $numeros_telefone > 11 || strlen($p['telefone']) > 20) {
        $erros[] = 'O telefone/contato deve ter 10 ou 11 números (com DDD).';
    }

    return $erros;
}

function cpf_ja_cadastrado($pdo, $cpf, $ignorar_id)
{
    $comando = $pdo->prepare('SELECT id_paciente FROM paciente WHERE cpf_hash = ? AND id_paciente <> ?');
    $comando->execute([hash_cpf($cpf), $ignorar_id]);

    return $comando->fetch() !== false;
}

// Buscar um paciente específico (para edição)
if ($metodo === 'GET' && $id !== '') {
    $comando = $pdo->prepare(
        'SELECT id_paciente, id_responsavel, nome, cpf, telefone 
         FROM paciente 
         WHERE id_paciente = ?'
    );
    $comando->execute([$id]);
    $paciente = $comando->fetch();

    if (!$paciente) {
        responder_erro('Paciente não encontrado.', 404);
    }

    $paciente['cpf'] = formatar_cpf(descriptografar($paciente['cpf']));
    responder($paciente);
}

// Listar pacientes (com JOIN para exibir o nome do responsável na tabela)
if ($metodo === 'GET') {
    $busca = trim($_GET['busca'] ?? '');

    $sql = 'SELECT p.id_paciente, p.id_responsavel, p.nome, p.cpf, p.telefone, r.nome AS nome_responsavel
            FROM paciente p
            INNER JOIN responsavel r ON p.id_responsavel = r.id_responsavel';
    $parametros = [];

    if ($busca !== '') {
        $termo = '%' . addcslashes($busca, '%_\\') . '%';
        $cpf_digitado = preg_replace('/\D/', '', $busca);

        $sql .= ' WHERE p.nome LIKE ? OR p.telefone LIKE ? OR r.nome LIKE ? OR p.cpf_hash = ?';
        $parametros = [$termo, $termo, $termo, hash_cpf($cpf_digitado)];
    }

    $comando = $pdo->prepare($sql . ' ORDER BY p.nome');
    $comando->execute($parametros);
    $pacientes = $comando->fetchAll();

    foreach ($pacientes as $posicao => $paciente) {
        $pacientes[$posicao]['cpf'] = cpf_para_listagem($paciente['cpf']);
    }

    responder($pacientes);
}

// Cadastrar paciente
if ($metodo === 'POST') {
    $p = tratar_paciente(ler_json());

    $erros = validar_paciente($pdo, $p);
    if ($erros) {
        responder_erro(implode("\n", $erros));
    }
    if (cpf_ja_cadastrado($pdo, $p['cpf'], 0)) {
        responder_erro('Já existe um paciente cadastrado com este CPF.', 409);
    }

    $comando = $pdo->prepare(
        'INSERT INTO paciente (id_responsavel, nome, cpf, cpf_hash, telefone) VALUES (?, ?, ?, ?, ?)'
    );
    $comando->execute([
        $p['id_responsavel'],
        $p['nome'],
        criptografar($p['cpf']),
        hash_cpf($p['cpf']),
        $p['telefone'],
    ]);

    responder(['mensagem' => 'Paciente cadastrado com sucesso.'], 201);
}

// Atualizar paciente
if ($metodo === 'PUT') {
    if (!ctype_digit($id)) {
        responder_erro('Informe o id do paciente.');
    }

    $comando = $pdo->prepare('SELECT id_paciente FROM paciente WHERE id_paciente = ?');
    $comando->execute([$id]);
    if (!$comando->fetch()) {
        responder_erro('Paciente não encontrado.', 404);
    }

    $p = tratar_paciente(ler_json());

    $erros = validar_paciente($pdo, $p);
    if ($erros) {
        responder_erro(implode("\n", $erros));
    }
    if (cpf_ja_cadastrado($pdo, $p['cpf'], $id)) {
        responder_erro('Já existe outro paciente cadastrado com este CPF.', 409);
    }

    $comando = $pdo->prepare(
        'UPDATE paciente
         SET id_responsavel = ?, nome = ?, cpf = ?, cpf_hash = ?, telefone = ?
         WHERE id_paciente = ?'
    );
    $comando->execute([
        $p['id_responsavel'],
        $p['nome'],
        criptografar($p['cpf']),
        hash_cpf($p['cpf']),
        $p['telefone'],
        $id,
    ]);

    responder(['mensagem' => 'Paciente atualizado com sucesso.']);
}

// Excluir paciente
if ($metodo === 'DELETE') {
    if (!ctype_digit($id)) {
        responder_erro('Informe o id do paciente.');
    }

    try {
        $comando = $pdo->prepare('DELETE FROM paciente WHERE id_paciente = ?');
        $comando->execute([$id]);
    } catch (PDOException $erro) {
        // Código 1451: o paciente já possui agendamentos vinculados
        if ($erro->errorInfo[1] == 1451) {
            responder_erro('Não é possível excluir: o paciente possui agendamentos cadastrados.', 409);
        }
        throw $erro;
    }

    if ($comando->rowCount() === 0) {
        responder_erro('Paciente não encontrado.', 404);
    }

    responder(['mensagem' => 'Paciente excluído com sucesso.']);
}

responder_erro('Método não permitido.', 405);