import Foundation
import SwiftData

@Model
final class Despesa {
    var descricao: String
    var valor: Double
    var categoria: Categoria
    var data: Date

    init(descricao: String, valor: Double, categoria: Categoria, data: Date = .now) {
        self.descricao = descricao
        self.valor = valor
        self.categoria = categoria
        self.data = data
    }
}
