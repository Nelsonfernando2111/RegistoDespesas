import SwiftUI
import Charts

struct ResumoCategoriasView: View {
    let despesas: [Despesa]

    private struct Item: Identifiable {
        let categoria: Categoria
        let total: Double
        var id: Categoria { categoria }
    }

    private var dados: [Item] {
        Dictionary(grouping: despesas, by: \.categoria)
            .map { Item(categoria: $0.key, total: $0.value.reduce(0) { $0 + $1.valor }) }
            .sorted { $0.total > $1.total }
    }

    var body: some View {
        Chart(dados) { item in
            BarMark(
                x: .value("Total", item.total),
                y: .value("Categoria", item.categoria.rawValue)
            )
            .foregroundStyle(item.categoria.cor)
            .annotation(position: .trailing) {
                Text(item.total.emMZN)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .chartXAxis(.hidden)
        .frame(height: CGFloat(max(dados.count, 1)) * 44)
        .padding(.vertical, 4)
    }
}
