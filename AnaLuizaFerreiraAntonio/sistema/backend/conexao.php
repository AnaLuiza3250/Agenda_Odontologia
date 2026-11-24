<?php
// Conexão com o banco saep_db_odontologia (usuário e senha padrão do XAMPP)
function conectar()
{
    $pdo = new PDO(
        'mysql:host=127.0.0.1;port=3307;dbname=saep_db_odontologia;charset=utf8mb4',
        'root',
        '',
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]
    );

    return $pdo;
}
