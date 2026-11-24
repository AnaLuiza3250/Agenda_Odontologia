<?php
// Código usado por todos os arquivos da API

require __DIR__ . '/config.php';

// Tempo máximo sem usar o sistema: 30 minutos (em segundos)
const TEMPO_SESSAO = 30 * 60;

// O PHP guarda a sessão pelo menos esse tempo (o padrão do XAMPP é 24 minutos)
ini_set('session.gc_maxlifetime', TEMPO_SESSAO);
session_start();
date_default_timezone_set('America/Sao_Paulo');
header('Content-Type: application/json; charset=utf-8');

// Qualquer erro inesperado (ex.: banco desligado) vira uma resposta JSON
set_exception_handler(function () {
    responder_erro('Erro no servidor. Verifique se o MySQL está ligado.', 500);
});

function responder($dados, $status = 200)
{
    http_response_code($status);
    echo json_encode($dados, JSON_UNESCAPED_UNICODE);
    exit;
}

function responder_erro($mensagem, $status = 400)
{
    responder(['erro' => $mensagem], $status);
}

// Lê o JSON enviado pelo fetch no corpo da requisição
function ler_json()
{
    $dados = json_decode(file_get_contents('php://input'), true);
    return is_array($dados) ? $dados : [];
}

// Texto sem espaços nas pontas; vazio vira null
function ou_nulo($valor)
{
    $valor = trim($valor);
    return $valor === '' ? null : $valor;
}

// Bloqueia quem não está logado ou ficou mais de 30 minutos sem usar o sistema
function exigir_login()
{
    if (!isset($_SESSION['id_usuario'])) {
        responder_erro('Faça login para continuar.', 401);
    }

    if (time() - $_SESSION['ultimo_acesso'] > TEMPO_SESSAO) {
        session_destroy();
        responder_erro('Sua sessão expirou. Faça login novamente.', 401);
    }

    // Usou o sistema: a contagem dos 30 minutos recomeça
    $_SESSION['ultimo_acesso'] = time();
}
