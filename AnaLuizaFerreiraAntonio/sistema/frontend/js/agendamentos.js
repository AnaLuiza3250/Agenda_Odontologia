const formAgendamento = document.getElementById('form-agendamento');
const inputId = document.getElementById('id_agendamento');
const selectPaciente = document.getElementById('id_paciente');
const inputDataConsulta = document.getElementById('data_consulta');
const inputObservacoes = document.getElementById('observacoes');

const tituloFormulario = document.getElementById('titulo-formulario');
const botaoSalvar = document.getElementById('botao-salvar');
const botaoCancelarEdicao = document.getElementById('botao-cancelar-edicao');

const formBusca = document.getElementById('form-busca');
const inputBusca = document.getElementById('busca');
const botaoLimparBusca = document.getElementById('botao-limpar-busca');

const listaAgendamentos = document.getElementById('lista-agendamentos');
const spanTotal = document.getElementById('total');

function limparMensagem() {
    const caixa = document.getElementById('mensagem');
    caixa.hidden = true;
    caixa.textContent = '';
}

// Carrega os pacientes (mostrando também quem é o responsável no select)
async function carregarPacientes() {
    try {
        const dados = await chamarApi('pacientes.php');

        selectPaciente.innerHTML = '<option value="">Selecione um paciente...</option>';
        dados.forEach((pac) => {
            const option = document.createElement('option');
            option.value = pac.id_paciente;
            option.textContent = `${pac.nome} (Resp.: ${pac.nome_responsavel})`;
            selectPaciente.appendChild(option);
        });
    } catch (erro) {
        selectPaciente.innerHTML = '<option value="">Erro ao carregar pacientes</option>';
        mostrarMensagem(erro.message, 'erro');
    }
}

// Carrega a tabela de agendamentos
async function carregarAgendamentos(termoBusca = '') {
    try {
        const arquivo = termoBusca
            ? `agendamentos.php?busca=${encodeURIComponent(termoBusca)}`
            : 'agendamentos.php';

        const dados = await chamarApi(arquivo);

        spanTotal.textContent = dados.length;
        listaAgendamentos.innerHTML = '';

        if (dados.length === 0) {
            listaAgendamentos.innerHTML = '<tr><td colspan="5">Nenhum agendamento encontrado.</td></tr>';
            return;
        }

        dados.forEach((ag) => {
            const tr = document.createElement('tr');
            const cancelado = ag.status === 'Cancelado';

            if (cancelado) {
                tr.style.opacity = '0.6';
            }

            const dataExibicao = formatarDataHora(ag.data_consulta);
            const obsExibicao = ag.observacoes ? escapar(ag.observacoes) : '–';
            const badgeCancelado = cancelado ? ' <strong>(Cancelado)</strong>' : '';

            tr.innerHTML = `
                <td>${escapar(ag.nome_paciente)}</td>
                <td>${escapar(ag.nome_responsavel)}</td>
                <td>${dataExibicao}${badgeCancelado}</td>
                <td>${obsExibicao}</td>
                <td class="acoes-tabela">
                    ${!cancelado ? `
                        <button type="button" class="btn" onclick="editarAgendamento(${ag.id_agendamento})">Editar</button>
                        <button type="button" class="btn sair" onclick="cancelarAgendamento(${ag.id_agendamento})">Cancelar</button>
                    ` : '<span>–</span>'}
                </td>
            `;
            listaAgendamentos.appendChild(tr);
        });
    } catch (erro) {
        mostrarMensagem(erro.message, 'erro');
    }
}

// Preenche o formulário para edição
async function editarAgendamento(id) {
    limparMensagem();
    try {
        const ag = await chamarApi(`agendamentos.php?id=${id}`);

        inputId.value = ag.id_agendamento;
        selectPaciente.value = ag.id_paciente;
        inputDataConsulta.value = ag.data_consulta_input;
        inputObservacoes.value = ag.observacoes || '';

        tituloFormulario.textContent = `Editando consulta #${ag.id_agendamento}`;
        botaoSalvar.textContent = 'Salvar alterações';
        botaoCancelarEdicao.hidden = false;
        selectPaciente.focus();
    } catch (erro) {
        mostrarMensagem(erro.message, 'erro');
    }
}

// Cancela a consulta (muda o status para Cancelado)
async function cancelarAgendamento(id) {
    if (!confirm('Deseja realmente cancelar esta consulta?')) {
        return;
    }

    limparMensagem();
    try {
        const dados = await chamarApi(`agendamentos.php?id=${id}`, 'PATCH');
        mostrarMensagem(dados.mensagem, 'sucesso');

        if (inputId.value == id) {
            resetarFormulario();
        }
        await carregarAgendamentos(inputBusca.value.trim());
    } catch (erro) {
        mostrarMensagem(erro.message, 'erro');
    }
}

function resetarFormulario() {
    formAgendamento.reset();
    inputId.value = '';
    tituloFormulario.textContent = 'Nova consulta';
    botaoSalvar.textContent = 'Agendar consulta';
    botaoCancelarEdicao.hidden = true;
}

// Salvar (POST ou PUT)
formAgendamento.addEventListener('submit', async (evento) => {
    evento.preventDefault();
    limparMensagem();

    const id = inputId.value;
    const metodo = id ? 'PUT' : 'POST';
    const arquivo = id ? `agendamentos.php?id=${id}` : 'agendamentos.php';

    const payload = {
        id_paciente: selectPaciente.value,
        data_consulta: inputDataConsulta.value,
        observacoes: inputObservacoes.value,
    };

    try {
        const dados = await chamarApi(arquivo, metodo, payload);
        mostrarMensagem(dados.mensagem, 'sucesso');
        resetarFormulario();
        await carregarAgendamentos(inputBusca.value.trim());
    } catch (erro) {
        mostrarMensagem(erro.message, 'erro');
    }
});

botaoCancelarEdicao.addEventListener('click', () => {
    limparMensagem();
    resetarFormulario();
});

formBusca.addEventListener('submit', (evento) => {
    evento.preventDefault();
    carregarAgendamentos(inputBusca.value.trim());
});

botaoLimparBusca.addEventListener('click', () => {
    inputBusca.value = '';
    carregarAgendamentos();
});

// Inicialização
async function iniciar() {
    const usuario = await iniciarPagina();
    if (usuario === null) {
        return;
    }

    await carregarPacientes();
    await carregarAgendamentos();
}

iniciar();