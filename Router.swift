//
//  Router.swift
//  StylaSwift
//
//  Created by Telematica on 4/11/25.
//

import SwiftUI
import Combine   // por si tu toolchain lo exige para ObservableObject/@Published

@MainActor
final class Router: ObservableObject {
    // Usamos un array de rutas (compatible con iOS 14+)
    @Published var path: [Route] = []

    func navigate(_ route: Route) {
        path.append(route)
    }

    /// Equivalente a popUpTo + launchSingleTop: limpio la pila y dejo route como raíz
    func setAsRoot(_ route: Route) {
        path = [route]
    }

    func back() {
        guard !path.isEmpty else { return }
        _ = path.popLast()
    }
}
