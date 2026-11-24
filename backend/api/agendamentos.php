<?php
// API de agendamentos
//   GET    agendamentos.php               lista os agendamentos (aceita ?busca=termo)
//   GET    agendamentos.php?id=1          um agendamento específico (para editar)
//   POST   agendamentos.php               cadastra novo agendamento
//   PUT    agendamentos.php?id=1          atualiza agendamento
//   PATCH  agendamentos.php?id=1          cancela o agendamento (muda status para 'Cancelado')
//   DELETE agendamentos.php?id=1          exclui o agendamento
require __DIR__ . '/../helpers.php';
require __DIR__ . '/../conexao.php';
require __DIR__ . '/../seguranca.php';

exigir_login();

$pdo = conectar();
$metodo = $_SERVER['REQUEST_METHOD'];
$id = $_GET['id'] ?? '';

function tratar_agendamento($dados)
{
    // Converte '2026-11-25T14:30' (do input datetime-local) para '2026-11-25 14:30:00'
    $data_bruta = trim($dados['data_consulta'] ?? '');
    $data_formatada = str_replace('T', ' ', $data_bruta);
    if (strlen($data_formatada) === 16) {
        $data_formatada .= ':00';
    }

    return [
        'id_paciente'   => trim($dados['id_paciente'] ?? ''),
        'data_consulta' => $data_formatada,
        'observacoes'   => ou_nulo($dados['observacoes'] ?? ''),
    ];
}

function validar_agendamento($pdo, $a)
{
    $erros = [];

    if (!ctype_digit((string)$a['id_paciente'])) {
        $erros[] = 'Selecione um paciente.';
    } else {
        $comando = $pdo->prepare('SELECT id_paciente FROM paciente WHERE id_paciente = ?');
        $comando->execute([$a['id_paciente']]);
        if (!$comando->fetch()) {
            $erros[] = 'O paciente selecionado não existe.';
        }
    }

    $dt = DateTime::createFromFormat('Y-m-d H:i:s', $a['data_consulta']);
    if (!$dt || $dt->format('Y-m-d H:i:s') !== $a['data_consulta']) {
        $erros[] = 'Informe uma data e hora válidas para a consulta.';
    }

    if ($a['observacoes'] !== null && mb_strlen($a['observacoes']) > 255) {
        $erros[] = 'As observações aceitam no máximo 255 caracteres.';
    }

    return $erros;
}

// Verifica se já existe consulta ativa no mesmo horário
function horario_ocupado($pdo, $data_consulta, $ignorar_id)
{
    $comando = $pdo->prepare(
        "SELECT id_agendamento FROM agendamento 
         WHERE data_consulta = ? AND status = 'Agendado' AND id_agendamento <> ?"
    );
    $comando->execute([$data_consulta, $ignorar_id]);

    return $comando->fetch() !== false;
}

// Buscar um agendamento específico (para edição)
if ($metodo === 'GET' && $id !== '') {
    $comando = $pdo->prepare(
        'SELECT id_agendamento, id_paciente, data_consulta, observacoes, status 
         FROM agendamento 
         WHERE id_agendamento = ?'
    );
    $comando->execute([$id]);
    $agendamento = $comando->fetch();

    if (!$agendamento) {
        responder_erro('Agendamento não encontrado.', 404);
    }

    // Formata para o input datetime-local do HTML (YYYY-MM-DDTHH:MM)
    $agendamento['data_consulta_input'] = str_replace(' ', 'T', substr($agendamento['data_consulta'], 0, 16));
    responder($agendamento);
}

// Listar agendamentos (com JOIN em paciente e responsavel)
if ($metodo === 'GET') {
    $busca = trim($_GET['busca'] ?? '');

    $sql = 'SELECT a.id_agendamento, a.data_consulta, a.observacoes, a.status,
                   p.nome AS nome_paciente,
                   r.nome AS nome_responsavel
            FROM agendamento a
            INNER JOIN paciente p ON a.id_paciente = p.id_paciente
            INNER JOIN responsavel r ON p.id_responsavel = r.id_responsavel';
    $parametros = [];

    if ($busca !== '') {
        $termo = '%' . addcslashes($busca, '%_\\') . '%';
        $sql .= ' WHERE p.nome LIKE ? OR r.nome LIKE ? OR a.observacoes LIKE ?';
        $parametros = [$termo, $termo, $termo];
    }

    $comando = $pdo->prepare($sql . ' ORDER BY a.data_consulta ASC');
    $comando->execute($parametros);
    $agendamentos = $comando->fetchAll();

    responder($agendamentos);
}

// Cadastrar novo agendamento
if ($metodo === 'POST') {
    $a = tratar_agendamento(ler_json());

    $erros = validar_agendamento($pdo, $a);
    if ($erros) {
        responder_erro(implode("\n", $erros));
    }

    if (horario_ocupado($pdo, $a['data_consulta'], 0)) {
        responder_erro('Já existe uma consulta agendada para este mesmo dia e horário.', 409);
    }

    // Pega o ID do usuário logado na sessão (ajuste a chave caso sua sessão use outro nome)
    $id_usuario = $_SESSION['id_usuario'] ?? $_SESSION['usuario']['id_usuario'] ?? $_SESSION['usuario']['id'] ?? 1;

    $comando = $pdo->prepare(
        'INSERT INTO agendamento (id_usuario, id_paciente, data_consulta, observacoes) 
         VALUES (?, ?, ?, ?)'
    );
    $comando->execute([
        $id_usuario,
        $a['id_paciente'],
        $a['data_consulta'],
        $a['observacoes'],
    ]);

    responder(['mensagem' => 'Consulta agendada com sucesso.'], 201);
}

// Atualizar agendamento
if ($metodo === 'PUT') {
    if (!ctype_digit($id)) {
        responder_erro('Informe o id do agendamento.');
    }

    $comando = $pdo->prepare('SELECT id_agendamento FROM agendamento WHERE id_agendamento = ?');
    $comando->execute([$id]);
    if (!$comando->fetch()) {
        responder_erro('Agendamento não encontrado.', 404);
    }

    $a = tratar_agendamento(ler_json());

    $erros = validar_agendamento($pdo, $a);
    if ($erros) {
        responder_erro(implode("\n", $erros));
    }

    if (horario_ocupado($pdo, $a['data_consulta'], $id)) {
        responder_erro('Já existe outra consulta agendada para este mesmo dia e horário.', 409);
    }

    $comando = $pdo->prepare(
        'UPDATE agendamento
         SET id_paciente = ?, data_consulta = ?, observacoes = ?
         WHERE id_agendamento = ?'
    );
    $comando->execute([
        $a['id_paciente'],
        $a['data_consulta'],
        $a['observacoes'],
        $id,
    ]);

    responder(['mensagem' => 'Agendamento atualizado com sucesso.']);
}

// Cancelar agendamento (altera status para Cancelado)
if ($metodo === 'PATCH') {
    if (!ctype_digit($id)) {
        responder_erro('Informe o id do agendamento.');
    }

    $comando = $pdo->prepare("UPDATE agendamento SET status = 'Cancelado' WHERE id_agendamento = ?");
    $comando->execute([$id]);

    if ($comando->rowCount() === 0) {
        responder_erro('Agendamento não encontrado ou já cancelado.', 404);
    }

    responder(['mensagem' => 'Consulta cancelada com sucesso.']);
}

responder_erro('Método não permitido.', 405);