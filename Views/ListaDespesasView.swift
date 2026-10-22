import SwiftUI
import SwiftData

struct ListaDespesasView: View {
    @Environment(\.modelContext) private var contexto

    @Query(sort: \Despesa.data, order: .reverse) private var todas: [Despesa]

    @State private var mesSelecionado = Date()
    @State private var mostrarNova = false
    @State private var despesaParaEditar: Despesa?

    private var despesasDoMes: [Despesa] {
        todas.filter {
            Calendar.current.isDate($0.data, equalTo: mesSelecionado, toGranularity: .month)
        }
    }

    private var total: Double {
        despesasDoMes.reduce(0) { $0 + $1.valor }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Button { mudarMes(-1) } label: { Image(systemName: "chevron.left") }
                            .buttonStyle(.borderless)
                        Spacer()
                        Text(mesSelecionado.formatted(.dateTime.month(.wide).year()))
                            .font(.headline)
                        Spacer()
                        Button { mudarMes(1) } label: { Image(systemName: "chevron.right") }
                            .buttonStyle(.borderless)
                    }
                    HStack {
                        Text("Total do mês")
                        Spacer()
                        Text(total.emMZN).bold()
                    }
                }

                if !despesasDoMes.isEmpty {
                    Section("Por categoria") {
                        ResumoCategoriasView(despesas: despesasDoMes)
                    }
                }

                Section("Despesas") {
                    if despesasDoMes.isEmpty {
                        ContentUnavailableView(
                            "Sem despesas",
                            systemImage: "tray",
                            description: Text("Toque em + para adicionar a primeira despesa deste mês.")
                        )
                    } else {
                        ForEach(despesasDoMes) { d in
                            HStack {
                                Image(systemName: d.categoria.icone)
                                    .foregroundStyle(d.categoria.cor)
                                    .frame(width: 28)
                                VStack(alignment: .leading) {
                                    Text(d.descricao)
                                    Text(d.data, format: .dateTime.day().month(.abbreviated))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(d.valor.emMZN)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture { despesaParaEditar = d }
                        }
                        .onDelete(perform: apagar)
                    }
                }
            }
            .navigationTitle("Despesas")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { mostrarNova = true } label: {
                        Label("Adicionar", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $mostrarNova) {
                DespesaFormView(despesa: nil)
            }
            .sheet(item: $despesaParaEditar) { despesa in
                DespesaFormView(despesa: despesa)
            }
        }
    }

    private func mudarMes(_ delta: Int) {
        mesSelecionado = Calendar.current.date(byAdding: .month, value: delta, to: mesSelecionado) ?? mesSelecionado
    }

    private func apagar(at offsets: IndexSet) {
        let lista = despesasDoMes
        for i in offsets {
            contexto.delete(lista[i])
        }
    }
}
