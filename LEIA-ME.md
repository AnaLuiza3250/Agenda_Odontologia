# Clínica Odontológica – Código base

Este pacote traz o **login** e o **cadastro de responsáveis** prontos. O cadastro de responsáveis serve de modelo: pacientes e agendamentos são com vocês.

## Como executar (XAMPP)

1. Copie esta pasta para dentro de `C:\xampp\htdocs\`.
2. Inicie **Apache** e **MySQL** no painel do XAMPP.
3. Em `http://localhost/phpmyadmin`, aba **Importar**, escolha `banco_base.sql`.
   Ele cria o banco `saep_db_odontologia` com as tabelas `usuario` e `responsavel`.
4. Abra a pasta `frontend` pelo navegador, por exemplo:
   `http://localhost/<nome-da-pasta>/frontend/`

Confira a porta do MySQL no painel do XAMPP. Se for diferente da que está em
`backend/conexao.php`, ajuste a linha da conexão.

### Logins de teste

| E-mail | Senha |
|---|---|
| camila@clinicaodonto.com | camila123 |
| ricardo@clinicaodonto.com | ricardo123 |
| beatriz@clinicaodonto.com | beatriz123 |

## O que já está pronto

```
backend/
  config.php        chave usada para criptografar o CPF
  conexao.php       conexão PDO com o banco saep_db_odontologia
  helpers.php       sessão, respostas JSON, ler_json(), exigir_login()
  seguranca.php     criptografia e máscara do CPF (LGPD)
  api/
    login.php         POST {email, senha}: abre a sessão
    sessao.php        GET: informa o usuário logado (ou 401)
    logout.php        POST: encerra a sessão
    responsaveis.php  GET (lista e busca), GET ?id=, POST, PUT ?id=, DELETE ?id=
frontend/
  index.html          tela de login
  principal.html      tela inicial (só confere o login e mostra o usuário)
  responsaveis.html   cadastro, busca, edição e exclusão de responsáveis
  css/style.css       estilos do sistema
  js/comum.js         funções usadas por todas as páginas
  js/login.js         lógica da tela de login
  js/principal.js     lógica da tela inicial
  js/responsaveis.js  lógica da tela de responsáveis
banco_base.sql        tabelas usuario e responsavel, com dados de teste
```

### Funções que vocês podem usar

**No back-end (`helpers.php`)**

- `exigir_login()`: devolve 401 se ninguém estiver logado ou se a sessão expirou (30 minutos sem usar o sistema).
- `ler_json()`: lê o JSON enviado pelo `fetch`.
- `responder($dados, $status)`: devolve uma resposta JSON.
- `responder_erro($mensagem, $status)`: devolve `{"erro": "mensagem"}`.
- `ou_nulo($valor)`: texto vazio vira `null`.

**No front-end (`comum.js`)**

- `chamarApi(arquivo, metodo, dados)`: faz a requisição e devolve o JSON. Se a API responder com erro, lança um `Error` com a mensagem.
- `iniciarPagina()`: confere o login e preenche o cabeçalho. Chame no início de toda página interna.
- `mostrarMensagem(texto, tipo)`: mostra um aviso no topo da página (`'sucesso'`, `'erro'` ou `'alerta'`).
- `escapar(texto)`: deixa o texto seguro para colocar no HTML.
- `formatarData(data)` e `formatarDataHora(texto)`: formatam datas do banco para o padrão brasileiro.

## O que vocês vão desenvolver

- **Banco de dados:** as tabelas de paciente e agendamento, com seus relacionamentos. Cada paciente pertence a um responsável.
- **Back-end:** os arquivos `pacientes.php` e `agendamentos.php` em `backend/api/`.
- **Front-end:** as páginas `pacientes.html` e `agendamentos.html`, com seus arquivos JS, e os links delas no menu.

Usem o cadastro de responsáveis como exemplo: `responsaveis.php`, `responsaveis.html` e `js/responsaveis.js` mostram como a página conversa com a API.

Sigam as regras de negócio do Caderno do Estudante.
