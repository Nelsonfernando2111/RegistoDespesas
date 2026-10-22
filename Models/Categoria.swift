import SwiftUI

enum Categoria: String, Codable, CaseIterable, Identifiable {
    case transporte = "Transporte"
    case comida = "Comida"
    case recargas = "Recargas"
    case estudos = "Estudos"
    case outros = "Outros"

    var id: String { rawValue }

    var icone: String {
        switch self {
        case .transporte: return "bus"
        case .comida: return "fork.knife"
        case .recargas: return "phone"
        case .estudos: return "book"
        case .outros: return "ellipsis.circle"
        }
    }

    var cor: Color {
        switch self {
        case .transporte: return .blue
        case .comida: return .orange
        case .recargas: return .green
        case .estudos: return .purple
        case .outros: return .gray
        }
    }
}
