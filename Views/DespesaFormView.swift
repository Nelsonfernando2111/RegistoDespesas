import SwiftUI
import SwiftData

struct DespesaFormView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(\.dismiss) private var dismiss

    let despesa: Despesa?

    @State private var descricao: String
    @State private var valorTexto: String
    @State private var categoria: Categoria
    @State private var data: Date

    init(despesa: Despesa?) {
        self.despesa = despesa
        _descricao = State(initialValue: despesa?.descricao ?? "")
        _valorTexto = State(initialValue: despesa.map { String($0.valor) } ?? "")
        _categoria = State(initialValue: despesa?.categoria ?? .comida)
        _data = State(initialValue: despesa?.data ?? .now)
    }

    private var valor: Double? {
        guard let v = Double(valorTexto.replacingOccurrences(of: ",", with: ".")), v > 0 else {
            return nil
        }
        return v
    }

    private var formularioValido: Bool {
        !descricao.trimmingCharacters(in: .whitespaces).isEmpty && valor != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Descrição", text: $descricao)
                TextField("Valor (MZN)", text: $valorTexto)
                    .keyboardType(.decimalPad)
                Picker("Categoria", selection: $categoria) {
                    ForEach(Categoria.allCases) { c in
                        Label(c.rawValue, systemImage: c.icone).tag(c)
                    }
                }
                DatePicker("Data", selection: $data, displayedComponents: .date)
            }
            .navigationTitle(despesa == nil ? "Nova despesa" : "Editar despesa")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") { guardar() }
                        .disabled(!formularioValido)
                }
            }
        }
    }

    private func guardar() {
        guard let valor else { return }
        let texto = descricao.trimmingCharacters(in: .whitespaces)

        if let despesa {
            despesa.descricao = texto
            despesa.valor = valor
            despesa.categoria = categoria
            despesa.data = data
        } else {
            contexto.insert(
                Despesa(descricao: texto, valor: valor, categoria: categoria, data: data)
            )
        }
        dismiss()
    }
}
