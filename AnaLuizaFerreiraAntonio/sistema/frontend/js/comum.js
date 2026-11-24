// Funções usadas por todas as páginas

// Pasta da API, vista a partir da pasta frontend
const API = '../backend/api/';

// Faz a requisição com fetch e devolve o JSON da resposta.
// Se a API responder com erro, lança um Error com a mensagem recebida.
async function chamarApi(arquivo, metodo = 'GET', dados = null) {
    const opcoes = {
        method: metodo,
        headers: { 'Content-Type': 'application/json' },
    };

    if (dados !== null) {
        opcoes.body = JSON.stringify(dados);
    }

    const resposta = await fetch(API + arquivo, opcoes);
    const json = await resposta.json();

    // 401 = não está logado ou a sessão expirou: volta para a tela de login
    if (resposta.status === 401 && arquivo !== 'login.php' && arquivo !== 'sessao.php') {
        voltarParaLogin(json.erro);
    }

    if (!resposta.ok) {
        throw new Error(json.erro || 'Erro na requisição.');
    }

    return json;
}

function voltarParaLogin(mensagem) {
    window.location.href = 'index.html?aviso=' + encodeURIComponent(mensagem);
}

// Mostra uma mensagem no topo da página (tipo: 'sucesso', 'erro' ou 'alerta')
function mostrarMensagem(texto, tipo = 'sucesso') {
    const caixa = document.getElementById('mensagem');
    caixa.textContent = texto;
    caixa.className = 'aviso aviso-' + tipo;
    caixa.hidden = false;
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// Transforma texto em HTML seguro: o que o usuário digitar nunca vira código
function escapar(texto) {
    if (texto === null) {
        return '';
    }
    const div = document.createElement('div');
    div.textContent = texto;
    return div.innerHTML;
}

// 2025-11-07 -> 07/11/2025
function formatarData(data) {
    if (data === null) {
        return '–';
    }
    return data.split('-').reverse().join('/');
}

// 2026-11-20 14:30:00 -> 20/11/2026 14:30
function formatarDataHora(texto) {
    const partes = texto.split(' ');
    return formatarData(partes[0]) + ' ' + partes[1].slice(0, 5);
}

// Chamada no início das páginas internas: confere o login e preenche o cabeçalho.
// Devolve o usuário logado ou null (e volta para o login).
async function iniciarPagina() {
    let usuario;

    try {
        usuario = await chamarApi('sessao.php');
    } catch (erro) {
        voltarParaLogin(erro.message);
        return null;
    }

    document.getElementById('nome-usuario').textContent = usuario.nome;
    document.getElementById('botao-sair').addEventListener('click', sair);

    return usuario;
}

async function sair() {
    await chamarApi('logout.php', 'POST');
    window.location.href = 'index.html';
}
