import Foundation

// Extensão de Double: permite escrever valor.emMZN em qualquer parte da app.
extension Double {
    var emMZN: String {
        self.formatted(
            .currency(code: "MZN")
            .locale(Locale(identifier: "pt_MZ"))
        )
    }
}
