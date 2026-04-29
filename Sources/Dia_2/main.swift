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

// Catálogo em memória simulando um banco de dados
let catalogoPlanos: [PlanoAssinatura] = [
    PlanoAssinatura(
        nome: "Mensal",
        valorMensalidade: 149.90,
        incluiPersonalTrainer: false,
        limiteAulasColetivas: 20,
        duracaoMeses: 1
    ),
    PlanoAssinatura(
        nome: "Trimestral",
        valorMensalidade: 129.90,
        incluiPersonalTrainer: true,
        limiteAulasColetivas: 30,
        duracaoMeses: 3
    ),
    PlanoAssinatura(
        nome: "Anual",
        valorMensalidade: 99.90,
        incluiPersonalTrainer: true,
        limiteAulasColetivas: 40,
        duracaoMeses: 12
    )
]

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

// Aluno
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

// Instrutor
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

// Contratos de Comportamento

// Contrato de manutenção
protocol MantemItem {
    var nome: String { get }
    var historico: [String] { get }
    func realizarReparo(data: String, status: String)
}

// Equipamento físico que adota o protocolo
class Equipamento: MantemItem {
    var nome: String
    var historico: [String]
    var estaFuncionando: Bool
    
    init(nome: String, estaFuncionando: Bool) {
        self.nome = nome
        self.historico = []
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

// Contrato base para Aula
protocol Aula {
    var nome: String { get }
    var instrutor: Instrutor { get }
    var categoria: CategoriaAula { get }
    var descricao: String { get }
}

// Turma Coletiva
class TurmaColetiva: Aula {
    var nome: String
    var instrutor: Instrutor
    var categoria: CategoriaAula
    var descricao: String
    let capacidadeMaxima: Int
    let capacidadeMinima: Int
    var inscritos: [Aluno]
    
    init(nome: String, instrutor: Instrutor, categoria: CategoriaAula, descricao: String, capacidadeMaxima: Int, capacidadeMinima: Int) {
        self.nome = nome
        self.instrutor = instrutor
        self.categoria = categoria
        self.descricao = descricao
        self.capacidadeMaxima = capacidadeMaxima
        self.capacidadeMinima = capacidadeMinima
        self.inscritos = []
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

// Treino com Personal
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



// Programa Principal

print("--- Sistema de Academia ---\n")

// Exibir catálogo de planos
print("Catálogo de Planos:")
for (index, plano) in catalogoPlanos.enumerated() {
    print("\(index + 1). \(plano.descricao())")
}
print("")


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


// Escolha do Nível de Experiência
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


// Criação do Aluno
let aluno = Aluno(
    nome: nome,
    email: email,
    matricula: matricula,
    plano: planoEscolhido,
    nivel: nivelEscolhido
)

print("\nAluno cadastrado com sucesso!\n")
aluno.exibirInformacoes()


// Atualizações dinâmicas
print("\n--- Demonstração de Atualizações Dinâmicas ---")

aluno.atualizarPlano(novoPlano: catalogoPlanos[2])
aluno.atualizarNivel(novoNivel: .avancado)

print("\nInformações após atualizações:")
aluno.exibirInformacoes()

print("\n--- Exemplo de Instrutor ---")
let instrutor1 = Instrutor(
    nome: "Gustavo Bastos",
    email: "gustavobastos@academia.com",
    especialidade: .musculacao
)
instrutor1.exibirInformacoes()



// Contratos

print("\n--- Demonstração de Manutenção de Equipamento ---")
let esteira = Equipamento(nome: "Esteira Profissional", estaFuncionando: true)
esteira.realizarReparo(data: "29/04/2026", status: "Revisão completa")
print("Histórico: \(esteira.historico)")

let bicicleta = Equipamento(nome: "Bicicleta Ergométrica", estaFuncionando: false)
bicicleta.realizarReparo(data: "29/04/2026", status: "Troca de peça")

print("\n--- Demonstração de Aulas com Protocolo ---")

let instrutorYoga = Instrutor(nome: "Ana Silva", email: "ana@academia.com", especialidade: .yoga)

let turmaYoga = TurmaColetiva(
    nome: "Yoga Matinal",
    instrutor: instrutorYoga,
    categoria: .yoga,
    descricao: "Aula de yoga para relaxamento e flexibilidade",
    capacidadeMaxima: 15,
    capacidadeMinima: 5
)

turmaYoga.inscrever(aluno: aluno)
turmaYoga.exibirInscritos()

let treinoPersonal = TreinoPersonal(
    nome: "Treino de Força Personalizado",
    instrutor: instrutor1,
    categoria: .musculacao,
    descricao: "Treino individual focado em ganho de massa muscular"
)

treinoPersonal.agendar(aluno: aluno)