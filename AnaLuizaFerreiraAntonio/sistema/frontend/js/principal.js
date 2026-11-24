let dataReferencia = new Date();
let agendamentosAtivos = [];

const DIAS_SEMANA = ['DOM.', 'SEG.', 'TER.', 'QUA.', 'QUI.', 'SEX.', 'SÁB.'];
const MESES_CURTOS = ['jan.', 'fev.', 'mar.', 'abr.', 'mai.', 'jun.', 'jul.', 'ago.', 'set.', 'out.', 'nov.', 'dez.'];

function chaveData(ano, mesZeroBased, dia) {
    const m = String(mesZeroBased + 1).padStart(2, '0');
    const d = String(dia).padStart(2, '0');
    return `${ano}-${m}-${d}`;
}

function extrairHora(dataConsulta) {
    // '2026-11-24 14:30:00' -> '14:30'
    return dataConsulta.slice(11, 16);
}

function renderizarCalendario() {
    const grade = document.getElementById('calendario-grade');
    const tituloMes = document.getElementById('titulo-mes');

    const ano = dataReferencia.getFullYear();
    const mes = dataReferencia.getMonth();

    const nomeMes = dataReferencia.toLocaleDateString('pt-BR', {
        month: 'long',
        year: 'numeric',
    });
    tituloMes.textContent = nomeMes;

    // Agrupa os agendamentos ativos por 'YYYY-MM-DD'
    const porDia = {};
    agendamentosAtivos.forEach((ag) => {
        const diaStr = ag.data_consulta.slice(0, 10);
        if (!porDia[diaStr]) {
            porDia[diaStr] = [];
        }
        porDia[diaStr].push(ag);
    });

    // Ordena as consultas de cada dia por horário crescente
    Object.values(porDia).forEach((lista) => {
        lista.sort((a, b) => a.data_consulta.localeCompare(b.data_consulta));
    });

    const primeiroDiaSemana = new Date(ano, mes, 1).getDay(); // 0 (Dom) a 6 (Sáb)
    const ultimoDiaMesAtual = new Date(ano, mes + 1, 0).getDate();
    const ultimoDiaMesAnterior = new Date(ano, mes, 0).getDate();

    const totalCelulas = Math.ceil((primeiroDiaSemana + ultimoDiaMesAtual) / 7) * 7;

    const hoje = new Date();
    const chaveHoje = chaveData(hoje.getFullYear(), hoje.getMonth(), hoje.getDate());

    let html = '';

    for (let i = 0; i < totalCelulas; i++) {
        let celulaAno = ano;
        let celulaMes = mes;
        let celulaDia;
        let outroMes = false;

        if (i < primeiroDiaSemana) {
            // Dias finais do mês anterior
            celulaDia = ultimoDiaMesAnterior - (primeiroDiaSemana - 1 - i);
            celulaMes = mes - 1;
            if (celulaMes < 0) {
                celulaMes = 11;
                celulaAno--;
            }
            outroMes = true;
        } else if (i >= primeiroDiaSemana + ultimoDiaMesAtual) {
            // Dias iniciais do próximo mês
            celulaDia = i - (primeiroDiaSemana + ultimoDiaMesAtual) + 1;
            celulaMes = mes + 1;
            if (celulaMes > 11) {
                celulaMes = 0;
                celulaAno++;
            }
            outroMes = true;
        } else {
            celulaDia = i - primeiroDiaSemana + 1;
        }

        const chave = chaveData(celulaAno, celulaMes, celulaDia);
        const ehHoje = chave === chaveHoje;
        const eventosDia = porDia[chave] || [];

        const classes = ['cal-celula'];
        if (outroMes) classes.push('outro-mes');
        if (ehHoje) classes.push('hoje');

        // Na primeira linha, exibe o nome do dia da semana (DOM., SEG., etc.)
        const cabecalhoSemana = i < 7
            ? `<div class="cal-dia-semana">${DIAS_SEMANA[i]}</div>`
            : '';

        // No dia 1 do mês, mostra "1 dez." como na referência
        const rotuloDia = (celulaDia === 1 && !ehHoje)
            ? `1 ${MESES_CURTOS[celulaMes]}`
            : celulaDia;

        const limiteVisivel = 3;
        const visiveis = eventosDia.slice(0, limiteVisivel);
        const restantes = eventosDia.length - limiteVisivel;

        let eventosHtml = visiveis.map((ev) => {
            const hora = extrairHora(ev.data_consulta);
            const tituloTooltip = `${hora} - ${ev.nome_paciente} (Resp.: ${ev.nome_responsavel})`;
            return `
                <a href="agendamentos.html" class="cal-evento" title="${escapar(tituloTooltip)}">
                    <span class="cal-ponto"></span>
                    <span><strong>${hora}</strong> ${escapar(ev.nome_paciente)}</span>
                </a>
            `;
        }).join('');

        if (restantes > 0) {
            eventosHtml += `<div class="cal-mais">Mais ${restantes}</div>`;
        }

        html += `
            <div class="${classes.join(' ')}">
                ${cabecalhoSemana}
                <div class="cal-numero-topo">
                    <span class="cal-numero">${rotuloDia}</span>
                </div>
                <div class="cal-eventos">
                    ${eventosHtml}
                </div>
            </div>
        `;
    }

    grade.innerHTML = html;
}

async function carregarAgendamentos() {
    try {
        const dados = await chamarApi('agendamentos.php');
        // Mostra apenas consultas com status 'Agendado' (ignora as canceladas)
        agendamentosAtivos = dados.filter((ag) => ag.status !== 'Cancelado');
        renderizarCalendario();
    } catch (erro) {
        mostrarMensagem(erro.message, 'erro');
    }
}

document.getElementById('btn-mes-anterior').addEventListener('click', () => {
    dataReferencia.setMonth(dataReferencia.getMonth() - 1);
    renderizarCalendario();
});

document.getElementById('btn-mes-proximo').addEventListener('click', () => {
    dataReferencia.setMonth(dataReferencia.getMonth() + 1);
    renderizarCalendario();
});

document.getElementById('btn-hoje').addEventListener('click', () => {
    dataReferencia = new Date();
    renderizarCalendario();
});

// Tela principal: confere o login, mostra o nome do usuário e carrega o calendário
async function iniciar() {
    const usuario = await iniciarPagina();
    if (usuario === null) {
        return;
    }

    document.getElementById('saudacao').textContent = 'Olá, ' + usuario.nome;
    renderizarCalendario();
    await carregarAgendamentos();
}

iniciar();