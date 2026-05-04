import Foundation

enum NivelExperiencia: String, CaseIterable {
    case iniciante = "Iniciante"
    case intermediario = "Intermediário"
    case avancado = "Avançado"
}

enum CategoriaAula: String, CaseIterable {
    case musculacao = "Musculação"
    case spinning = "Spinning"
    case yoga = "Yoga"
    case funcional = "Funcional"
    case luta = "Luta"
}

// Plano de Assinatura
struct PlanoAssinatura {
    let nome: String
    let valorMensalidade: Double
    let incluiPersonalTrainer: Bool
    let limiteAulasColetivas: Int
    let duracaoMeses: Int
   
    func descricao() -> String {
        let personal = incluiPersonalTrainer ? "com Personal Trainer" : "sem Personal Trainer"
        return "\(nome) - R$\(String(format: "%.2f", valorMensalidade))/mês | \(personal) | Até \(limiteAulasColetivas) aulas coletivas | Duração: \(duracaoMeses) meses"
    }
}

// Contratos de Comportamento
protocol MantemItem {
    var nome: String { get }
    var historico: [String] { get }
    func realizarReparo(data: String, status: String)
}

protocol Aula {
    var nome: String { get }
    var instrutor: Instrutor { get }
    var categoria: CategoriaAula { get }
    var descricao: String { get }
}

// Classe de gerenciamento central da academia
class Academia {
    var alunos: [String: Aluno] = [:]           // chave: matrícula
    var instrutores: [String: Instrutor] = [:]  // chave: email
    var equipamentos: [Equipamento] = []
    var turmas: [TurmaColetiva] = []
    var treinosPersonal: [TreinoPersonal] = []
    
    // Proteção contra duplicidades
    func admitirAluno(_ aluno: Aluno) -> Bool {
        if alunos.keys.contains(aluno.matricula) {
            print("A matrícula \(aluno.matricula) já é existente.")
            return false
        }
        if alunos.values.contains(where: { $0.email == aluno.email }) {
            print("O Email \(aluno.email) já está cadastrado.")
            return false
        }
        
        alunos[aluno.matricula] = aluno
        print("Aluno \(aluno.nome) admitido com sucesso.")
        return true
    }
    
    // Manutenção dos equipamentos em lote
    func realizarManutencaoEmLote(data: String) {
        print("\n--- Manutenção em lote dos equipamentos ---")
        var falhas = 0
        
        for equipamento in equipamentos {
            if !equipamento.estaFuncionando {
                print("Manutenção falhou: \(equipamento.nome) está defeituoso.")
                falhas += 1
                continue
            }
            equipamento.realizarReparo(data: data, status: "Revisão completa")
        }
        
        print("Manutenção finalizada. \(falhas) equipamento(s) com falha.")
    }
    
    // Agendamento de Personal Trainer
    func agendarPersonal(aluno: Aluno, treino: TreinoPersonal) -> Bool {
        guard aluno.plano.incluiPersonalTrainer else {
            print("Não foi possível agendar. O plano \(aluno.plano.nome) não inclui Personal Trainer.")
            return false
        }
        
        treino.agendar(aluno: aluno)
        treinosPersonal.append(treino)
        return true
    }
    
    // Relatório de Ocupação das Turmas
    func gerarRelatorioOcupacao() {
        print("\n--- Relatório de Ocupação das Turmas Coletivas ---")
        if turmas.isEmpty {
            print("Nenhuma turma cadastrada no momento.")
            return
        }
        
        for turma in turmas {
            let ocupacao = Double(turma.inscritos.count) / Double(turma.capacidadeMaxima) * 100
            print("Turma: \(turma.nome) | Categoria: \(turma.categoria.rawValue)")
            print("   Instrutor: \(turma.instrutor.nome)")
            print("   Inscritos: \(turma.inscritos.count)/\(turma.capacidadeMaxima) (\(String(format: "%.1f", ocupacao))%)")
            print("   Status: \(turma.inscritos.count >= turma.capacidadeMinima ? "Ativa" : "Abaixo do mínimo")")
            print("---")
        }
    }
}

// Hierarquia de Pessoas
class Pessoa {
    var nome: String
    var email: String
    let funcaoDescritiva: String
   
    init(nome: String, email: String, funcaoDescritiva: String) {
        self.nome = nome
        self.email = email
        self.funcaoDescritiva = funcaoDescritiva
    }
   
    func exibirInformacoes() {
        print("Nome: \(nome)")
        print("Email: \(email)")
        print("Função: \(funcaoDescritiva)")
    }
}

class Aluno: Pessoa {
    var matricula: String
    var plano: PlanoAssinatura
    var nivel: NivelExperiencia
   
    init(nome: String, email: String, matricula: String, plano: PlanoAssinatura, nivel: NivelExperiencia) {
        self.matricula = matricula
        self.plano = plano
        self.nivel = nivel
        super.init(nome: nome, email: email, funcaoDescritiva: "Aluno")
    }
   
    func atualizarPlano(novoPlano: PlanoAssinatura) {
        self.plano = novoPlano
        print("Plano do aluno \(nome) atualizado para: \(novoPlano.nome)")
    }
   
    func atualizarNivel(novoNivel: NivelExperiencia) {
        self.nivel = novoNivel
        print("Nível do aluno \(nome) atualizado para: \(novoNivel.rawValue)")
    }
   
    override func exibirInformacoes() {
        super.exibirInformacoes()
        print("Matrícula: \(matricula)")
        print("Nível: \(nivel.rawValue)")
        print("Plano Atual: \(plano.nome) - R$\(String(format: "%.2f", plano.valorMensalidade))/mês")
    }
}

class Instrutor: Pessoa {
    var especialidade: CategoriaAula
   
    init(nome: String, email: String, especialidade: CategoriaAula) {
        self.especialidade = especialidade
        super.init(nome: nome, email: email, funcaoDescritiva: "Instrutor")
    }
   
    override func exibirInformacoes() {
        super.exibirInformacoes()
        print("Especialidade: \(especialidade.rawValue)")
    }
}



class Equipamento: MantemItem {
    var nome: String
    var historico: [String] = []
    var estaFuncionando: Bool
    
    init(nome: String, estaFuncionando: Bool) {
        self.nome = nome
        self.estaFuncionando = estaFuncionando
    }
    
    func realizarReparo(data: String, status: String) {
        if !estaFuncionando {
            print("Manutenção falhou: \(nome) está defeituoso.")
            return
        }
        historico.append("Reparo em \(data): \(status)")
        print("Reparo realizado em \(nome) em \(data) - Status: \(status)")
    }
}


class TurmaColetiva: Aula {
    var nome: String
    var instrutor: Instrutor
    var categoria: CategoriaAula
    var descricao: String
    let capacidadeMaxima: Int
    let capacidadeMinima: Int
    var inscritos: [Aluno] = []
    
    init(nome: String, instrutor: Instrutor, categoria: CategoriaAula, descricao: String, capacidadeMaxima: Int, capacidadeMinima: Int) {
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.capacidadeMaxima = capacidadeMaxima
        self.capacidadeMinima = capacidadeMinima
    }
    
    func inscrever(aluno: Aluno) -> Bool {
        if inscritos.count >= capacidadeMaxima {
            print("Não há vagas disponíveis na turma \(nome).")
            return false
        }
        if inscritos.contains(where: { $0.matricula == aluno.matricula }) {
            print("Aluno já inscrito na turma \(nome).")
            return false
        }
        inscritos.append(aluno)
        print("Aluno \(aluno.nome) inscrito com sucesso na turma \(nome).")
        return true
    }
    
    func exibirInscritos() {
        print("Turma: \(nome) - Inscritos: \(inscritos.count)/\(capacidadeMaxima)")
        for aluno in inscritos {
            print("- \(aluno.nome) (Matrícula: \(aluno.matricula))")
        }
    }
}


class TreinoPersonal: Aula {
    var nome: String
    var instrutor: Instrutor
    var categoria: CategoriaAula
    var descricao: String
    var aluno: Aluno?
    
    init(nome: String, instrutor: Instrutor, categoria: CategoriaAula, descricao: String) {
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.aluno = nil
    }
    
    func agendar(aluno: Aluno) {
        self.aluno = aluno
        print("Treino personal \(nome) agendado para o aluno \(aluno.nome) com instrutor \(instrutor.nome).")
    }
}


// Catálogo em memória
let catalogoPlanos: [PlanoAssinatura] = [
    PlanoAssinatura(nome: "Mensal", valorMensalidade: 149.90, incluiPersonalTrainer: false, limiteAulasColetivas: 20, duracaoMeses: 1),
    PlanoAssinatura(nome: "Trimestral", valorMensalidade: 129.90, incluiPersonalTrainer: true, limiteAulasColetivas: 30, duracaoMeses: 3),
    PlanoAssinatura(nome: "Anual", valorMensalidade: 99.90, incluiPersonalTrainer: true, limiteAulasColetivas: 40, duracaoMeses: 12)
]

extension Academia {
    func gerarMetricas() -> (totaisAlunos: Int, totaisInstrutores: Int, aulasAtivas: Int, equipamentosDanificados: Int) {
        let totalAlunos = alunos.count
        let totalInstrutores = instrutores.count
        
        var aulasAtivas = 0
        for turma in turmas {
            if turma.inscritos.count >= turma.capacidadeMinima {
                aulasAtivas += 1
            }
        }
        
        var eqDanificados = 0
        for eq in equipamentos {
            if !eq.estaFuncionando {
                eqDanificados += 1
            }
        }
        
        return (totalAlunos, totalInstrutores, aulasAtivas, eqDanificados)
    }
}


// PROGRAMA PRINCIPAL

print("--- Sistema de Academia ---\n")

// Exibir catálogo de planos
print("Catálogo de Planos:")
for (index, plano) in catalogoPlanos.enumerated() {
    print("\(index + 1). \(plano.descricao())")
}
print("")

let academia = Academia()

// Cadastro do Aluno com entrada do usuário
print("--- Cadastro de Novo Aluno ---")

print("Nome completo: ", terminator: "")
guard let nome = readLine(), !nome.isEmpty else {
    print("Nome não pode ser vazio.")
    exit(1)
}

print("Email: ", terminator: "")
guard let email = readLine(), !email.isEmpty else {
    print("Email não pode ser vazio.")
    exit(1)
}

print("Matrícula: ", terminator: "")
guard let matricula = readLine(), !matricula.isEmpty else {
    print("Matrícula não pode ser vazia.")
    exit(1)
}

// Escolha do Plano
print("\nEscolha o plano (digite o número):")
for (index, plano) in catalogoPlanos.enumerated() {
    print("\(index + 1). \(plano.nome)")
}

print("Opção: ", terminator: "")
guard let escolhaPlanoStr = readLine(),
      let escolhaPlano = Int(escolhaPlanoStr),
      escolhaPlano >= 1 && escolhaPlano <= catalogoPlanos.count else {
    print("Opção de plano inválida.")
    exit(1)
}

let planoEscolhido = catalogoPlanos[escolhaPlano - 1]

// Escolha do Nível
print("\nEscolha o nível de experiência:")
for (index, nivel) in NivelExperiencia.allCases.enumerated() {
    print("\(index + 1). \(nivel.rawValue)")
}

print("Opção: ", terminator: "")
guard let escolhaNivelStr = readLine(),
      let escolhaNivel = Int(escolhaNivelStr),
      escolhaNivel >= 1 && escolhaNivel <= NivelExperiencia.allCases.count else {
    print("Opção de nível inválida.")
    exit(1)
}

let nivelEscolhido = NivelExperiencia.allCases[escolhaNivel - 1]

let aluno = Aluno(
    nome: nome,
    email: email,
    matricula: matricula,
    plano: planoEscolhido,
    nivel: nivelEscolhido
)

academia.admitirAluno(aluno)

print("\nAluno cadastrado com sucesso!\n")
aluno.exibirInformacoes()

// Demonstração de atualizações
print("\n--- Demonstração de Atualizações Dinâmicas ---")
aluno.atualizarPlano(novoPlano: catalogoPlanos[2])
aluno.atualizarNivel(novoNivel: .avancado)

print("\nInformações após atualizações:")
aluno.exibirInformacoes()

// Instrutor
print("\n--- Exemplo de Instrutor ---")
let instrutor1 = Instrutor(
    nome: "Gustavo Bastos",
    email: "gustavobastos@academia.com",
    especialidade: .musculacao
)
academia.instrutores[instrutor1.email] = instrutor1
instrutor1.exibirInformacoes()

// Equipamentos e Manutenção
print("\n--- Demonstração de Manutenção de Equipamento ---")
let esteira = Equipamento(nome: "Esteira Profissional", estaFuncionando: true)
let bicicleta = Equipamento(nome: "Bicicleta Ergométrica", estaFuncionando: false)

academia.equipamentos.append(esteira)
academia.equipamentos.append(bicicleta)

academia.realizarManutencaoEmLote(data: "30/04/2026")

// Aulas
print("\n--- Demonstração de Aulas com Protocolo ---")

let instrutorYoga = Instrutor(nome: "Ana Silva", email: "ana@academia.com", especialidade: .yoga)
academia.instrutores[instrutorYoga.email] = instrutorYoga

let turmaYoga = TurmaColetiva(
    nome: "Yoga Matinal",
    instrutor: instrutorYoga,
    categoria: .yoga,
    descricao: "Aula de yoga para relaxamento e flexibilidade",
    capacidadeMaxima: 15,
    capacidadeMinima: 5
)

academia.turmas.append(turmaYoga)
turmaYoga.inscrever(aluno: aluno)
turmaYoga.exibirInscritos()

let treinoPersonal = TreinoPersonal(
    nome: "Treino de Força Personalizado",
    instrutor: instrutor1,
    categoria: .musculacao,
    descricao: "Treino individual focado em ganho de massa muscular"
)

academia.agendarPersonal(aluno: aluno, treino: treinoPersonal)


academia.gerarRelatorioOcupacao()

print("\n--- Sistema finalizado ---")




// ROTEIRO PRÁTICO DE INTEGRAÇÃO

// Populando a memória com múltiplos perfis
// nomes genéricos para exemplo
let aluno2 = Aluno(nome: "Lucas Santana", email: "lucas@email.com", matricula: "MAT002", plano: catalogoPlanos[0], nivel: .iniciante) // Plano Mensal
let aluno3 = Aluno(nome: "Maria Alves", email: "alves@email.com", matricula: "MAT003", plano: catalogoPlanos[2], nivel: .avancado) // Plano Anual

let instrutor2 = Instrutor(nome: "Fernanda Lima", email: "fernanda@academia.com", especialidade: .spinning)
let instrutor3 = Instrutor(nome: "Rafael Pires", email: "rafael@academia.com", especialidade: .funcional)

academia.admitirAluno(aluno2)
academia.admitirAluno(aluno3)
academia.instrutores[instrutor2.email] = instrutor2
academia.instrutores[instrutor3.email] = instrutor3

print("\n--- Testando Barreiras Rigorosas ---")


// Testando duplicação de cadastros
print("\nTeste de Barreira: Tentativa de duplicação de cadastros.")
let alunoDuplicado = Aluno(nome: "Lucas Cópia", email: "lucas@email.com", matricula: "MAT002", plano: catalogoPlanos[0], nivel: .iniciante)
_ = academia.admitirAluno(alunoDuplicado)


// Testando superlotação de salas
print("\nTeste de Barreira: Tentativa de superlotação de salas.")
let turmaSpinning = TurmaColetiva(
    nome: "Spinning Extremo",
    instrutor: instrutor2,
    categoria: .spinning,
    descricao: "Aula intensa de spinning",
    capacidadeMaxima: 1, // Capacidade restrita de propósito
    capacidadeMinima: 1
)
academia.turmas.append(turmaSpinning)
_ = turmaSpinning.inscrever(aluno: aluno2)
_ = turmaSpinning.inscrever(aluno: aluno3) // Deve rejeitar o aluno3


// Testando benefícios incompatíveis
print("\nTeste de Barreira: Tentativa de uso de benefício incompatível.")
let treinoFuncionalVIP = TreinoPersonal(
    nome: "Treino Funcional VIP",
    instrutor: instrutor3,
    categoria: .funcional,
    descricao: "Acompanhamento funcional dedicado"
)
_ = academia.agendarPersonal(aluno: aluno2, treino: treinoFuncionalVIP) // aluno2 tem o plano Mensal (não inclui personal)


// Equipamento enguiçado e filtro automático de manutenção
print("\nTeste de Sistema: Manutenção Global Automática.")
let equipamentoQuebrado = Equipamento(nome: "Corda Naval", estaFuncionando: false)
academia.equipamentos.append(equipamentoQuebrado)
academia.realizarManutencaoEmLote(data: "04/05/2026")


// Defesa Técnica, Demonstração de Polimorfismo
print("\n--- Defesa Técnica: Polimorfismo ---")

print("\nColeção Heterogênea 1: Hierarquia Base (Pessoa)")
let colecaoPessoas: [Pessoa] = [aluno2, instrutor2, aluno3, instrutor3]
for pessoa in colecaoPessoas {
    pessoa.exibirInformacoes()
    print("---")
}

print("\nColeção Heterogênea 2: Contrato de Tipologia (Aula)")
let colecaoAulas: [Aula] = [turmaSpinning, treinoFuncionalVIP, turmaYoga, treinoPersonal]
for aula in colecaoAulas {
    print("Aula: \(aula.nome) | Categoria: \(aula.categoria.rawValue) | Instrutor: \(aula.instrutor.nome)")
}

// 7. Geração de Métricas Consolidadas via Extensão
print("\n--- Geração de Métricas Consolidadas ---")
let metricas = academia.gerarMetricas()
print("Total de Alunos Matriculados: \(metricas.totaisAlunos)")
print("Total de Instrutores Cadastrados: \(metricas.totaisInstrutores)")
print("Total de Aulas Ativas: \(metricas.aulasAtivas)")
print("Total de Equipamentos Danificados: \(metricas.equipamentosDanificados)")

// FIM DO ROTEIRO PRÁTICO DE INTEGRAÇÃO