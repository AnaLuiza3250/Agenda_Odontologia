<?php
// Diz ao front-end quem está logado (ou 401 se ninguém estiver ou se a sessão expirou)
require __DIR__ . '/../helpers.php';

exigir_login();

responder([
    'id_usuario' => $_SESSION['id_usuario'],
    'nome' => $_SESSION['nome_usuario'],
]);
