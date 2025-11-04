//
//  LoginScreen.swift
//  StylaSwift
//
//  Created by Telematica on 4/11/25.
//

import SwiftUI

private let abhayaRegular = "AbhayaLibre-Regular"

struct LoginScreen: View {
    // Navegación
    let onNavigateBack: () -> Void
    let onSuccessLogin: () -> Void   // ⬅️ NUEVO callback

    // Init con valores por defecto (útil para Preview)
    init(
        onNavigateBack: @escaping () -> Void = {},
        onSuccessLogin: @escaping () -> Void = {}
    ) {
        self.onNavigateBack = onNavigateBack
        self.onSuccessLogin = onSuccessLogin
    }

    // Estado de formulario
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false

    // Colores de la pantalla (equivalentes a Compose)
    private let bg = Color(red: 0xF3/255, green: 0xE9/255, blue: 0xD4/255)   // #F3E9D4
    private let cardBg = Color(red: 0xF7/255, green: 0xEF/255, blue: 0xE5/255) // #F7EFE5
    private let primary = Color(red: 0x9C/255, green: 0x5A/255, blue: 0x2D/255) // #9C5A2D

    var body: some View {
        ZStack(alignment: .topLeading) {
            bg.ignoresSafeArea()

            // Flecha regresar
            Button(action: onNavigateBack) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(.black)
                    .imageScale(.large)
                    .padding(.top, 8)
                    .padding(.leading, 0)
            }

            VStack {
                // ----- Cabecera con fotos y logo -----
                HStack(spacing: 20) {
                    // Columna izquierda
                    VStack(spacing: 10) {
                        Image("lindos")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())

                        Image("acostada")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    // Columna derecha
                    VStack(spacing: 8) {
                        Image("sentados")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 160, height: 280)
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        Image("styla")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 40)
                    }
                }
                .padding(.top, 16)

                Spacer().frame(height: 16)

                // ----- Tarjeta del formulario -----
                VStack(spacing: 16) {
                    Text("Inicio de sesión")
                        .font(.custom(abhayaRegular, size: 20))
                        .fontWeight(.medium)
                        .foregroundStyle(.black)

                    // Botones Facebook / Gmail
                    HStack(spacing: 12) {
                        SocialOutlinedButton(imageName: "facebook", title: "Facebook", background: cardBg)
                        SocialOutlinedButton(imageName: "gmail", title: "Gmail", background: cardBg)
                    }

                    // Campo correo
                    TextFieldWithIcon(
                        title: "Correo electrónico",
                        systemIcon: "envelope",
                        text: $email,
                        isSecure: false
                    )

                    // Campo contraseña (con toggle mostrar/ocultar)
                    ZStack {
                        if showPassword {
                            TextFieldWithIcon(
                                title: "Contraseña",
                                systemIcon: "lock",
                                text: $password,
                                isSecure: false
                            )
                        } else {
                            SecureFieldWithIcon(
                                title: "Contraseña",
                                systemIcon: "lock",
                                text: $password
                            )
                        }
                        HStack {
                            Spacer()
                            Button(action: { showPassword.toggle() }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.trailing, 12)
                    }

                    Button(action: {
                        // TODO: validar email/contraseña si lo deseas
                        onSuccessLogin()        // ⬅️ dispara la navegación al Start
                    }) {
                        Text("Entrar")
                            .font(.custom(abhayaRegular, size: 17))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .background(primary)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(24)
                .background(cardBg)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
                .padding(.horizontal, 16)

                Spacer()
            }
            .padding(16)
        }
    }
}

// MARK: - Subvistas

private struct SocialOutlinedButton: View {
    let imageName: String
    let title: String
    let background: Color

    var body: some View {
        Button(action: {}) {
            HStack(spacing: 8) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(title)
                    .foregroundStyle(.black)
                    .font(.custom(abhayaRegular, size: 14))
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .tint(.black)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 50))
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(.black, lineWidth: 1)
        )
    }
}

private struct TextFieldWithIcon: View {
    let title: String
    let systemIcon: String
    @Binding var text: String
    let isSecure: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemIcon)
                .foregroundStyle(.secondary)
            TextField(title, text: $text)
                .font(.custom(abhayaRegular, size: 16))
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 12)
        .frame(height: 44)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black.opacity(0.2), lineWidth: 1)
        )
    }
}

private struct SecureFieldWithIcon: View {
    let title: String
    let systemIcon: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemIcon)
                .foregroundStyle(.secondary)
            SecureField(title, text: $text)
                .font(.custom(abhayaRegular, size: 16))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 12)
        .frame(height: 44)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black.opacity(0.2), lineWidth: 1)
        )
    }
}
