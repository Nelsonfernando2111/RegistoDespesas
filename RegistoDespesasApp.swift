import SwiftUI
import SwiftData

@main
struct RegistoDespesasApp: App {
    var body: some Scene {
        WindowGroup {
            ListaDespesasView()
        }
        .modelContainer(for: Despesa.self)
    }
}
