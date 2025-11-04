//
//  RootView.swift
//  StylaSwift
//
//  Created by Telematica on 4/11/25.
//

import SwiftUI

/// Punto de entrada visual que sostiene el NavigationStack
struct RootView: View {
    @StateObject private var router = Router()

    var body: some View {
        NavigationStack(path: $router.path) {
            // StartDestination = Routes.WELCOME
            WelcomeScreen(
                onCreateAccountClick: { router.navigate(.signup) },
                onLoginClick: { router.navigate(.login) }
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .welcome:
                    WelcomeScreen(
                        onCreateAccountClick: { router.navigate(.signup) },
                        onLoginClick: { router.navigate(.login) }
                    )

                case .signup:
                    Signup(
                        onNavigateToRegistro: { router.navigate(.form) },
                        onNavigateToLogin: { router.navigate(.login) },
                        onBack: { router.back() }
                    )

                case .form:
                    FormScreen(
                        onBack: { router.back() },
                        onSuccess: {
                            // popUpTo(WELCOME) + navigate(ABOUT)
                            router.setAsRoot(.about)
                        },
                        onNavigateToLogin: { router.navigate(.login) }
                    )

                case .login:
                    LoginScreen(
                        onNavigateBack: { router.back() },
                        onSuccessLogin: {
                            // popUpTo(WELCOME) + navigate(START)
                            router.setAsRoot(.start)
                        }
                    )

                case .about:
                    AboutYouScreen(
                        onBack: { router.back() },
                        onGoToStart: {
                            // Guardar ➜ Start como raíz
                            router.setAsRoot(.start)
                        }
                    )

                case .start:
                    StartScreen(
                        onOpenCamera: { router.navigate(.camera) }
                    )

                case .camera:
                    AddItemScreen(onBack: { router.back() })
                }
            }
        }
        .environmentObject(router)
    }
}
