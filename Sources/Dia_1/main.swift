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
   
    // Método auxiliar para descrição
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
    let funcaoDescritiva: String // propriedade somente leitura (descritiva)
   
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
   
    // Atualização dinâmica de plano
    func atualizarPlano(novoPlano: PlanoAssinatura) {
        self.plano = novoPlano
        print("Plano do aluno \(nome) atualizado para: \(novoPlano.nome)")
    }
   
    // Atualização dinâmica de nível
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



// Programa Principal

print("--- Sistema de Academia ---\n")

// Exibindo catálogo de planos
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

// Demonstração das atualizações dinâmicas
print("\n--- Demonstração de Atualizações Dinâmicas ---")

// Atualiza para o plano Anual (último do catálogo)
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