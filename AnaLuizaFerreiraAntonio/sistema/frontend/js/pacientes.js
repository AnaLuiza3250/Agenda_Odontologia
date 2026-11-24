const formPaciente = document.getElementById('form-paciente');
const inputId = document.getElementById('id_paciente');
const inputNome = document.getElementById('nome');
const inputCpf = document.getElementById('cpf');
const inputTelefone = document.getElementById('telefone');
const selectResponsavel = document.getElementById('id_responsavel');

const tituloFormulario = document.getElementById('titulo-formulario');
const botaoSalvar = document.getElementById('botao-salvar');
const botaoCancelar = document.getElementById('botao-cancelar');

const formBusca = document.getElementById('form-busca');
const inputBusca = document.getElementById('busca');
const botaoLimparBusca = document.getElementById('botao-limpar-busca');

const listaPacientes = document.getElementById('lista-pacientes');
const spanTotal = document.getElementById('total');

function limparMensagem() {
    const caixa = document.getElementById('mensagem');
    caixa.hidden = true;
    caixa.textContent = '';
}

// Carrega os responsáveis para preencher o <select>
async function carregarResponsaveis() {
    try {
        const dados = await chamarApi('responsaveis.php');

        selectResponsavel.innerHTML = '<option value="">Selecione um responsável...</option>';
        dados.forEach((resp) => {
            const option = document.createElement('option');
            option.value = resp.id_responsavel;
            option.textContent = `${resp.nome} (${resp.cpf})`;
            selectResponsavel.appendChild(option);
        });
    } catch (erro) {
        selectResponsavel.innerHTML = '<option value="">Erro ao carregar responsáveis</option>';
        mostrarMensagem(erro.message, 'erro');
    }
}

// Carrega a tabela de pacientes
async function carregarPacientes(termoBusca = '') {
    try {
        const arquivo = termoBusca
            ? `pacientes.php?busca=${encodeURIComponent(termoBusca)}`
            : 'pacientes.php';

        const dados = await chamarApi(arquivo);

        spanTotal.textContent = dados.length;
        listaPacientes.innerHTML = '';

        if (dados.length === 0) {
            listaPacientes.innerHTML = '<tr><td colspan="6">Nenhum paciente encontrado.</td></tr>';
            return;
        }

        dados.forEach((paciente) => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${paciente.id_paciente}</td>
                <td>${escapar(paciente.nome)}</td>
                <td>${escapar(paciente.cpf)}</td>
                <td>${escapar(paciente.telefone)}</td>
                <td>${escapar(paciente.nome_responsavel)}</td>
                <td class="acoes-tabela">
                    <button type="button" class="btn" onclick="editarPaciente(${paciente.id_paciente})">Editar</button>
                    <button type="button" class="btn sair" onclick="excluirPaciente(${paciente.id_paciente})">Excluir</button>
                </td>
            `;
            listaPacientes.appendChild(tr);
        });
    } catch (erro) {
        mostrarMensagem(erro.message, 'erro');
    }
}

// Preenche o formulário para edição
async function editarPaciente(id) {
    limparMensagem();
    try {
        const paciente = await chamarApi(`pacientes.php?id=${id}`);

        inputId.value = paciente.id_paciente;
        inputNome.value = paciente.nome;
        inputCpf.value = paciente.cpf;
        inputTelefone.value = paciente.telefone;
        selectResponsavel.value = paciente.id_responsavel;

        tituloFormulario.textContent = `Editando paciente #${paciente.id_paciente}`;
        botaoSalvar.textContent = 'Salvar alterações';
        botaoCancelar.hidden = false;
        inputNome.focus();
    } catch (erro) {
        mostrarMensagem(erro.message, 'erro');
    }
}

// Exclui o paciente
async function excluirPaciente(id) {
    if (!confirm('Tem certeza que deseja excluir este paciente?')) {
        return;
    }

    limparMensagem();
    try {
        const dados = await chamarApi(`pacientes.php?id=${id}`, 'DELETE');
        mostrarMensagem(dados.mensagem, 'sucesso');

        if (inputId.value == id) {
            resetarFormulario();
        }
        await carregarPacientes(inputBusca.value.trim());
    } catch (erro) {
        mostrarMensagem(erro.message, 'erro');
    }
}

function resetarFormulario() {
    formPaciente.reset();
    inputId.value = '';
    tituloFormulario.textContent = 'Novo paciente';
    botaoSalvar.textContent = 'Cadastrar paciente';
    botaoCancelar.hidden = true;
}

// Salvar (POST ou PUT)
formPaciente.addEventListener('submit', async (evento) => {
    evento.preventDefault();
    limparMensagem();

    const id = inputId.value;
    const metodo = id ? 'PUT' : 'POST';
    const arquivo = id ? `pacientes.php?id=${id}` : 'pacientes.php';

    const payload = {
        nome: inputNome.value,
        cpf: inputCpf.value,
        telefone: inputTelefone.value,
        id_responsavel: selectResponsavel.value,
    };

    try {
        const dados = await chamarApi(arquivo, metodo, payload);
        mostrarMensagem(dados.mensagem, 'sucesso');
        resetarFormulario();
        await carregarPacientes(inputBusca.value.trim());
    } catch (erro) {
        mostrarMensagem(erro.message, 'erro');
    }
});

botaoCancelar.addEventListener('click', () => {
    limparMensagem();
    resetarFormulario();
});

formBusca.addEventListener('submit', (evento) => {
    evento.preventDefault();
    carregarPacientes(inputBusca.value.trim());
});

botaoLimparBusca.addEventListener('click', () => {
    inputBusca.value = '';
    carregarPacientes();
});

// Inicialização seguindo o padrão do projeto
async function iniciar() {
    const usuario = await iniciarPagina();
    if (usuario === null) {
        return;
    }

    await carregarResponsaveis();
    await carregarPacientes();
}

iniciar();