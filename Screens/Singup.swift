//
//  Signup.swift
//  StylaSwift
//
//  Created by Telematica on 4/11/25.
//

import SwiftUI

private let abhayaRegular = "AbhayaLibre-Regular"

struct Signup: View {
    let onNavigateToRegistro: () -> Void
    let onNavigateToLogin: () -> Void
    let onBack: () -> Void

    private let bgColor = Color(hex: 0xEDE7D4)
    private let primary = Color(hex: 0x9B5C2E)

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {

                // ---------------- Mitad superior ----------------
                ZStack {
                    Image("portadacc")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height * 0.5)
                        .clipped()
                        .scaleEffect(x: 1.3, y: 1.3, anchor: .center)
                        .offset(x: -30, y: 52)

                    // Degradado inferior
                    LinearGradient(
                        colors: [Color.clear, bgColor],
                        startPoint: .center, endPoint: .bottom
                    )
                    .frame(height: geo.size.height * 0.25)
                    .frame(maxHeight: .infinity, alignment: .bottom)


                    // Logo centrado (desplazado hacia abajo)
                    Image("styla")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .offset(y: 130)
                }
                .frame(height: geo.size.height * 0.5)
                .clipped()

                // ---------------- Mitad inferior ----------------
                VStack(spacing: 22) {
                    Text("Miles de outfits y marcas exclusivas\ndisponibles para ti")
                        .font(.custom(abhayaRegular, size: 22))
                        .fontWeight(.semibold) // conserva el énfasis que tenías
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)
                        .padding(.top, 6)

                    // Botones Facebook/Gmail
                    HStack(spacing: 16) {
                        SocialButton(asset: "facebook", title: "Facebook")
                        SocialButton(asset: "gmail",    title: "Gmail")
                    }
                    .padding(.horizontal, 32)

                    // Separador "o"
                    HStack {
                        Divider().background(Color.black).frame(height: 1)
                        Text("  o  ")
                            .font(.custom(abhayaRegular, size: 14))
                            .foregroundStyle(.black)
                        Divider().background(Color.black).frame(height: 1)
                    }
                    .frame(maxWidth: geo.size.width * 0.8)

                    // Botón registrarse con email
                    Button(action: onNavigateToRegistro) {
                        Text("Regístrate con email")
                            .font(.custom(abhayaRegular, size: 17))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: 260)
                            .frame(height: 56)
                    }
                    .background(primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 6)

                    Spacer(minLength: 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(bgColor)
            }
            .ignoresSafeArea(edges: .top)
        }
    }
}

// ---------------- Subvistas ----------------

private struct SocialButton: View {
    let asset: String
    let title: String

    var body: some View {
        HStack(spacing: 8) {
            Image(asset)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.black)
                .scaledToFit()
                .frame(width: 50, height: 50)

            Text(title)
                .font(.custom(abhayaRegular, size: 18))
                .foregroundStyle(.black)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, minHeight: 56)
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(Color.black, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 50))
        .contentShape(Rectangle())
    }
}

// ---------------- Utilidades ----------------
private extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255,
                  opacity: alpha)
    }
}

