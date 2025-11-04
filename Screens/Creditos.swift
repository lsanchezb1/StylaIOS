//
//  Creditos.swift
//  StylaSwift
//
//  Created by Telematica on 4/11/25.
//

import SwiftUI

private let abhayaRegular = "AbhayaLibre-Regular"

// Colores equivalentes
private let StylaBackground = Color(red: 0xF7/255, green: 0xF2/255, blue: 0xEB/255) // #F7F2EB
private let StylaAccent     = Color(red: 0x8B/255, green: 0x5A/255, blue: 0x3D/255)  // #8B5A3D
private let StylaTextDark   = Color(red: 0x1E/255, green: 0x1E/255, blue: 0x1E/255)  // #1E1E1E

struct Creditos: View {
    var body: some View {
        VStack(spacing: 0) {
            // Logo
            Image("styla")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding(.bottom, 8)

            // Descripción
            Text("""
Styla es la aplicación que está revolucionando la forma en la que vivimos la moda y gestionamos nuestro closet. Más que una app, es un espacio creativo y funcional donde puedes inspirarte, comprar, vender y compartir tu estilo con una comunidad que ama la moda tanto como tú.
""")
                .foregroundStyle(StylaAccent)
                .font(.custom(abhayaRegular, size: 16))
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .padding(.bottom, 64)

            Spacer()

            // Créditos
            VStack(spacing: 4) {
                Text("Créditos:")
                    .foregroundStyle(StylaTextDark.opacity(0.7))
                    .font(.custom(abhayaRegular, size: 14))

                Text("Lary Mariana Betancourt Avila")
                    .foregroundStyle(StylaTextDark)
                    .font(.custom(abhayaRegular, size: 16))

                Text("Laura Sofía Sánchez Bolaños")
                    .foregroundStyle(StylaTextDark)
                    .font(.custom(abhayaRegular, size: 16))
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 64)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(StylaBackground.ignoresSafeArea())
    }
}
