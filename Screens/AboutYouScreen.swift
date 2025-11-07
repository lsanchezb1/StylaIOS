//  AboutYouScreen.swift
//  StylaSwift
//
//  Created by Telematica on 4/11/25.
//

import SwiftUI

private let abhaya = "AbhayaLibre-Regular"

struct AboutYouScreen: View {
    // Navegación
    let onBack: () -> Void
    let onGoToStart: () -> Void

    // Colores
    private let Background = Color(hex: 0xEDE7D4)
    private let FieldBorder = Color(hex: 0x2D2D2D)
    private let Primary     = Color(hex: 0x9B5D38)
    private let Placeholder = Color(hex: 0x8C8C8C)
    private let Subtext     = Color(hex: 0x4B4B4B)

    // Estado
    @State private var gender: String = ""
    @State private var birthday: String = ""
    @State private var style: String = ""
    @State private var loading: Bool = false
    @State private var error: String? = nil
    @State private var saved: Bool = false

    @State private var genderMenu = false
    @State private var styleMenu  = false

    // DatePicker
    @State private var showDatePicker = false
    @State private var dateValue: Date = .now

    // Opciones
    private let genderOptions = ["Femenino", "Masculino", "Prefiero no decir"]
    private let styleOptions  = ["minimalista", "casual", "clásico", "romántico", "formal"]

    var body: some View {
        VStack(spacing: 0) {
    

            // ---------- Contenido scroll ----------
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // Títulos
                    Group {
                        Spacer().frame(height: 8)

                        Text("Cuéntanos sobre ti")
                            .font(.custom(abhaya, size: 32).weight(.semibold))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 4)

                        Text("Crearemos una experiencia personalizada")
                            .font(.custom(abhaya, size: 14))
                            .foregroundStyle(Subtext)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 6)

                        Spacer().frame(height: 28)
                    }

                    // Género
                    Group {
                        FieldShell {
                            Button { genderMenu.toggle() } label: {
                                HStack {
                                    Text(gender.isEmpty ? "Género" : gender)
                                        .font(.custom(abhaya, size: 16))
                                        .foregroundStyle(gender.isEmpty ? Placeholder : .black)
                                    Spacer()
                                    Image(systemName: "chevron.down").foregroundStyle(.black)
                                }
                            }
                            .buttonStyle(.plain)
                            .sheet(isPresented: $genderMenu) {
                                OptionSheet(
                                    title: "Género",
                                    options: genderOptions,
                                    selected: gender
                                ) { sel in
                                    gender = sel
                                    genderMenu = false
                                }
                                .presentationDetents([.medium])
                            }
                        }

                        Spacer().frame(height: 16)
                    }

                    // Cumpleaños
                    Group {
                        FieldShell {
                            HStack {
                                TextField("Cumpleaños (dd/mm/aa)", text: $birthday)
                                    .font(.custom(abhaya, size: 16))
                                    .keyboardType(.numberPad)
                                    .onChange(of: birthday) { newValue in
                                        birthday = formatDateInput(newValue)
                                    }
                                    .foregroundStyle(.black)
                                Button { showDatePicker = true } label: {
                                    Image(systemName: "calendar").foregroundStyle(.black)
                                }
                            }
                        }

                        Spacer().frame(height: 16)
                    }

                    // Estilo
                    Group {
                        FieldShell {
                            Button { styleMenu.toggle() } label: {
                                HStack {
                                    Text(style.isEmpty ? "Preferencias de estilo" : style.capitalized)
                                        .font(.custom(abhaya, size: 16))
                                        .foregroundStyle(style.isEmpty ? Placeholder : .black)
                                    Spacer()
                                    Image(systemName: "chevron.down").foregroundStyle(.black)
                                }
                            }
                            .buttonStyle(.plain)
                            .sheet(isPresented: $styleMenu) {
                                OptionSheet(
                                    title: "Estilo",
                                    options: styleOptions,
                                    selected: style
                                ) { sel in
                                    style = sel
                                    styleMenu = false
                                }
                                .presentationDetents([.medium])
                            }
                        }
                    }

                    // Error
                    Group {
                        if let e = error {
                            Spacer().frame(height: 12)
                            Text(e)
                                .font(.custom(abhaya, size: 15))
                                .foregroundStyle(Color(red: 0.69, green: 0, blue: 0.125)) // #B00020
                                .frame(maxWidth: .infinity, alignment: .center)
                        }

                        Spacer().frame(height: 24)
                    }

                    // Botón “Listo”
                    Group {
                        if !style.isEmpty {
                            Spacer().frame(height: 16)
                            Button(action: save) {
                                ZStack {
                                    if loading {
                                        ProgressView().tint(.white)
                                    } else {
                                        Text("Listo")
                                            .font(.custom(abhaya, size: 17).weight(.semibold))
                                    }
                                }
                                .frame(height: 48)
                                .frame(maxWidth: 220)
                            }
                            .disabled(loading)
                            .background(Primary)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                        }

                        Spacer().frame(height: 24)
                    }

                    // Imagen inferior
                    Group {
                        Image("aboutyou")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .padding(.bottom, 24)
                    }
                }
                .padding(.horizontal, 24)
            }
            .background(Background)
        }
        .background(Background)
        .onChange(of: saved) { newValue in
            if newValue { onGoToStart() }
        }
        // DatePicker Sheet
        .sheet(isPresented: $showDatePicker) {
            VStack {
                DatePicker("Selecciona tu fecha", selection: $dateValue, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()
                Button("OK") {
                    birthday = formatDate(dateValue) // dd/MM/aa
                    showDatePicker = false
                }
                .font(.custom(abhaya, size: 16))
                .buttonStyle(.borderedProminent)
                .tint(Primary)
                .padding(.bottom, 12)

                Button("Cancelar") { showDatePicker = false }
                    .font(.custom(abhaya, size: 16))
                    .padding(.bottom, 12)
            }
            .presentationDetents([.large])
        }
    }

    // Acciones
    private func save() {
        error = nil
        guard !gender.isEmpty else { error = "Selecciona tu género"; return }
        guard birthday.count == 8 else { error = "Fecha inválida (dd/mm/aa)"; return }
        guard !style.isEmpty else { error = "Selecciona un estilo"; return }

        loading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            loading = false
            saved = true
        }
    }

    private func formatDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_ES")
        f.dateFormat = "dd/MM/yy"
        return f.string(from: date)
    }
}

// ---------- Subvistas / helpers ----------

private struct FieldShell<Content: View>: View {
    let content: () -> Content
    private let border = Color(hex: 0x2D2D2D)
    private let bg = Color(hex: 0xEDE7D4)
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14).fill(bg)
            RoundedRectangle(cornerRadius: 14).stroke(border, lineWidth: 1)
            HStack { content() }
                .padding(.horizontal, 12)
                .frame(height: 48)
        }
    }
}

private struct OptionSheet: View {
    let title: String
    let options: [String]
    let selected: String
    let onSelect: (String) -> Void

    var body: some View {
        NavigationStack {
            List {
                ForEach(options, id: \.self) { opt in
                    Button {
                        onSelect(opt)
                    } label: {
                        HStack {
                            Text(opt.capitalized)
                                .font(.custom(abhaya, size: 17))
                            Spacer()
                            if opt == selected {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// dd/MM/aa
private func formatDateInput(_ input: String) -> String {
    let digits = input.filter(\.isNumber).prefix(6) // ddMMyy
    var out = ""
    for (i, ch) in digits.enumerated() {
        out.append(ch)
        if (i == 1 || i == 3), i != digits.count - 1 { out.append("/") }
    }
    return out
}

// Color
private extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255,
                  opacity: alpha)
    }
}
