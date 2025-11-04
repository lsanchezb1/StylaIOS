//
//  FormScreen.swift
//  StylaSwift
//
//  Created by Telematica on 4/11/25.
//

import SwiftUI

private let abhayaRegular = "AbhayaLibre-Regular"

struct FormScreen: View {
    // Navegación
    let onBack: () -> Void
    let onSuccess: () -> Void
    let onNavigateToLogin: () -> Void

    // Estado
    @State private var nombre: String = ""
    @State private var correo: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var acceptedTerms: Bool = false

    @State private var showPassword: Bool = false
    @State private var showPassword2: Bool = false

    @State private var loading: Bool = false
    @State private var error: String? = nil
    @State private var success: Bool = false

    // Colores
    private let bg = Color(hex: 0xEDE7D4)
    private let fieldBG = Color(hex: 0xF6F2EC)
    private let fieldBorder = Color(hex: 0x2D2D2D)
    private let placeholder = Color(hex: 0x8C8C8C)
    private let primary = Color(hex: 0x9B5D38)
    private let textMain = Color(hex: 0x1E1E1E)
    private let subText = Color(hex: 0x4B4B4B)
    private let danger = Color(red: 0.69, green: 0, blue: 0.125) // #B00020

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.black)
                            .imageScale(.large)
                            .padding(8)
                    }
                    Spacer()
                }
                .padding(.horizontal, 4)

                ScrollView {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 88)

                        // ---------- Sección: títulos ----------
                        Group {
                            Text("Vamos a\nregistrarte")
                                .font(.custom(abhayaRegular, size: 36))
                                .fontWeight(.bold)
                                .foregroundStyle(textMain)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)

                            Spacer().frame(height: 8)

                            Text("Los campos con * son obligatorios")
                                .font(.custom(abhayaRegular, size: 14))
                                .foregroundStyle(subText)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)

                            Spacer().frame(height: 24)
                        }

                        let shape = RoundedRectangle(cornerRadius: 12, style: .continuous)

                        // ---------- Sección: campos ----------
                        Group {
                            LabeledField(
                                text: $nombre,
                                placeholder: "Nombre*",
                                isSecure: false,
                                showSecure: .constant(false),
                                fieldBG: fieldBG,
                                border: fieldBorder,
                                placeholderColor: placeholder,
                                shape: shape
                            )

                            Spacer().frame(height: 12)

                            LabeledField(
                                text: $correo,
                                placeholder: "Correo electrónico*",
                                isSecure: false,
                                showSecure: .constant(false),
                                fieldBG: fieldBG,
                                border: fieldBorder,
                                placeholderColor: placeholder,
                                shape: shape,
                                keyboardType: .emailAddress
                            )

                            Spacer().frame(height: 12)

                            LabeledField(
                                text: $password,
                                placeholder: "Crea una contraseña*",
                                isSecure: true,
                                showSecure: $showPassword,
                                fieldBG: fieldBG,
                                border: fieldBorder,
                                placeholderColor: placeholder,
                                shape: shape
                            )

                            Spacer().frame(height: 12)

                            LabeledField(
                                text: $confirmPassword,
                                placeholder: "Confirma tu contraseña*",
                                isSecure: true,
                                showSecure: $showPassword2,
                                fieldBG: fieldBG,
                                border: fieldBorder,
                                placeholderColor: placeholder,
                                shape: shape
                            )

                            Spacer().frame(height: 12)

                            HStack(alignment: .center, spacing: 6) {
                                CheckBox(isOn: $acceptedTerms)
                                Text("Acepto Términos y condiciones")
                                    .font(.custom(abhayaRegular, size: 14))
                                    .foregroundStyle(textMain)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 4)
                        }

                        // ---------- Sección: error + botón ----------
                        Group {
                            if let err = error, !err.isEmpty {
                                Spacer().frame(height: 10)
                                Text(err)
                                    .font(.custom(abhayaRegular, size: 15))
                                    .foregroundStyle(danger)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                            }

                            Spacer().frame(height: 20)

                            GeometryReader { geo in
                                Button(action: submit) {
                                    ZStack {
                                        if loading {
                                            ProgressView().tint(.white)
                                        } else {
                                            Text("CREAR")
                                                .font(.custom(abhayaRegular, size: 17))
                                                .fontWeight(.bold)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                }
                                .disabled(loading || !acceptedTerms)
                                .background((acceptedTerms ? primary : Color(hex: 0xE7DBC7).opacity(0.60)))
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .frame(width: geo.size.width * 0.6, height: 48)
                                .frame(maxWidth: .infinity)
                            }
                            .frame(height: 48)

                            Spacer().frame(height: 18)

                            HStack(spacing: 6) {
                                Text("¿Ya tienes una cuenta?")
                                    .font(.custom(abhayaRegular, size: 16))
                                    .foregroundStyle(textMain)
                                Button(action: onNavigateToLogin) {
                                    Text("Ingresa aquí")
                                        .font(.custom(abhayaRegular, size: 16))
                                        .foregroundStyle(Color(hex: 0x9C5A2D))
                                        .underline()
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)

                            Spacer().frame(height: 36)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 92)
                }
                .background(bg)
                .scrollIndicators(.hidden)

                // Logo inferior
                Image("stylalogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 12)
            }

            // -------- Popup de éxito --------
            if success {
                Color.black.opacity(0.25).ignoresSafeArea()
                    .onTapGesture { success = false }
                SuccessDialog(
                    fullName: nombre,
                    onOk: {
                        success = false
                        onSuccess()
                    },
                    primary: primary
                )
                .transition(.scale)
            }
        }
    }

    // Validación + submit
    private func submit() {
        error = nil
        guard !nombre.trimmingCharacters(in: .whitespaces).isEmpty else {
            error = "El nombre es obligatorio"; return
        }
        guard correo.contains("@"), correo.contains(".") else {
            error = "Correo inválido"; return
        }
        guard password.count >= 6 else {
            error = "La contraseña debe tener al menos 6 caracteres"; return
        }
        guard password == confirmPassword else {
            error = "Las contraseñas no coinciden"; return
        }
        guard acceptedTerms else {
            error = "Debes aceptar Términos y condiciones"; return
        }

        loading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            loading = false
            success = true
        }
    }
}

// MARK: - Subvistas/utilidades

private struct LabeledField: View {
    @Binding var text: String
    let placeholder: String
    let isSecure: Bool
    @Binding var showSecure: Bool
    let fieldBG: Color
    let border: Color
    let placeholderColor: Color
    let shape: RoundedRectangle
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        ZStack {
            shape.fill(fieldBG)
            shape.stroke(border, lineWidth: 1)
            HStack {
                if isSecure && !showSecure {
                    SecureField(placeholder, text: $text)
                        .font(.custom(abhayaRegular, size: 16))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .keyboardType(keyboardType)
                        .foregroundStyle(.black)
                } else {
                    TextField(placeholder, text: $text)
                        .font(.custom(abhayaRegular, size: 16))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .keyboardType(keyboardType)
                        .foregroundStyle(.black)
                }
                if isSecure {
                    Button(action: { showSecure.toggle() }) {
                        Image(systemName: showSecure ? "eye.slash" : "eye")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding(.horizontal, 12)
            .frame(height: 48)
        }
    }
}

private struct CheckBox: View {
    @Binding var isOn: Bool
    var body: some View {
        Button(action: { isOn.toggle() }) {
            Image(systemName: isOn ? "checkmark.square.fill" : "square")
                .foregroundStyle(isOn ? Color.accentColor : Color.secondary)
                .imageScale(.large)
        }
        .buttonStyle(.plain)
    }
}

private struct SuccessDialog: View {
    let fullName: String
    let onOk: () -> Void
    let primary: Color

    var firstName: String {
        let trimmed = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        let first = trimmed.split(separator: " ").first.map(String.init) ?? "!"
        return first.isEmpty ? "!" : first
    }

    var body: some View {
        VStack {
            VStack(spacing: 12) {
                Text("¡Hola \(firstName)!")
                    .font(.custom(abhayaRegular, size: 26))
                    .foregroundStyle(Color(hex: 0x1E1E1E))
                Text("Tu cuenta ha sido creada\nexitosamente")
                    .font(.custom(abhayaRegular, size: 18))
                    .foregroundStyle(Color(hex: 0x1E1E1E))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                Button("OK", action: onOk)
                    .font(.custom(abhayaRegular, size: 17))
                    .buttonStyle(.plain)
                    .frame(height: 40)
                    .padding(.horizontal, 24)
                    .background(primary)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 6)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
            .background(Color(hex: 0xF6F0E6))
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .padding(.horizontal, 32)
        }
    }
}

private extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255,
                  opacity: alpha)
    }
}
