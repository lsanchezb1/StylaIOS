//  WelcomeScreen.swift
//  StylaSwift
//
//  Created by Telematica on 4/11/25.
//

import SwiftUI
import Combine
import UIKit

// --------- Modelo y constantes (equivalentes a tu data class/val) ---------
private struct Slide: Hashable {
    let imageName: String
    let caption: String
}

private let IMAGE_HEIGHT: CGFloat = 520
private let abhayaRegular = "AbhayaLibre-Regular"   // nombre de la fuente

// Paleta idéntica a Signup
private let bgColor   = Color(hex: 0xEDE7D4)
private let primary   = Color(hex: 0x9B5C2E)

struct WelcomeScreen: View {
    // Callbacks (igual que en Kotlin)
    let onCreateAccountClick: () -> Void
    let onLoginClick: () -> Void
 
    // Estado para el carrusel
    @State private var currentPage: Int = 0

    // Slides (mismo orden/captions)
    private let slides: [Slide] = [
        .init(imageName: "image1", caption: "Descubre, combina y sorprende\ncada día con tus looks"),
        .init(imageName: "image2", caption: "Tu prenda, infinitas ideas"),
        .init(imageName: "image3", caption: "Tu estilo siempre en movimiento:\nCompra y vende en un click")
    ]

    // Timer autoplay 3s
    private let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // ---------- Carrusel ----------
                TabView(selection: $currentPage) {
                    ForEach(slides.indices, id: \.self) { index in
                        let slide = slides[index]
                        Image(slide.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: IMAGE_HEIGHT)
                            .frame(height: IMAGE_HEIGHT)
                            .clipped()
                            .tag(index) // importante para que el binding funcione
                            .accessibilityLabel(Text("slide \(index)"))
                    }
                }
                .frame(height: IMAGE_HEIGHT)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onReceive(timer) { _ in
                    withAnimation(.easeInOut(duration: 0.6)) {
                        currentPage = (currentPage + 1) % slides.count
                    }
                }

                // ---------- Indicadores + caption + botones ----------
                VStack(spacing: 0) {
                    // Puntos
                    HStack(spacing: 10) {
                        ForEach(0..<slides.count, id: \.self) { idx in
                            Dot(
                                size: 12,
                                color: currentPage == idx
                                ? primary
                                : primary.opacity(0.35)
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)

                    Spacer().frame(height: 40)

                    // Caption
                    Text(slides[currentPage].caption)
                        .font(.custom(abhayaRegular, size: 20))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .foregroundStyle(.black)

                    Spacer().frame(height: 50)

                    // Botones (mismo color primario que en Signup)
                    HStack(spacing: 12) {
                        PrimaryButton(
                            title: "Crear cuenta",
                            action: onCreateAccountClick
                        )
                        PrimaryButton(
                            title: "Inicio de sesión",
                            action: onLoginClick
                        )
                    }
                }
                .padding(.horizontal, 30)

                Spacer().frame(height: 28)

                // ---------- Barra de marcas ----------
                BrandsStrip()
                    .frame(height: 76)
                    .frame(maxWidth: .infinity)
                    .background(primary)

                Spacer().frame(height: 24)

                // ---------- Sección final ----------
                VStack(spacing: 24) {
                    PromoRow(
                        leftImage: "shop_photo",
                        rightText: "Compra las prendas que\nte hagan falta de tus\ntiendas favoritas"
                    )

                    // 👇 pon rightImage antes de leftText
                    PromoRow(
                        rightImage: "closet_photo",
                        leftText: "Vende las prendas\nque ya no uses"
                    )
                }

                .padding(.horizontal, 30)
                .padding(.vertical, 16)
            }
            .padding(.vertical, 12)
        }
        // Fondo igual que Signup
        .background(bgColor)
    }
}

//
// ----------------- Subvistas equivalentes a tus helpers -----------------
//

/// Punto del indicador
private struct Dot: View {
    let size: CGFloat
    let color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: size/2)
            .fill(color)
            .frame(width: size, height: size)
    }
}

/// Botón primario con la misma estética de Signup (relleno primary y texto blanco)
private struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom(abhayaRegular, size: 17))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, minHeight: 56)
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(primary)
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 6)
        )
        .foregroundStyle(.white)
    }
}

/// Barra inferior de marcas
private struct BrandsStrip: View {
    var body: some View {
        HStack {
            BrandLogo(imageName: "zara", fallback: "ZARA")
            BrandLogo(imageName: "bershka", fallback: "BERSHKA")
            BrandLogo(imageName: "hm", fallback: "H&M")
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}

private struct BrandLogo: View {
    let imageName: String
    let fallback: String
    var body: some View {
        if UIImage(named: imageName) != nil {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .accessibilityLabel(Text(fallback))
        } else {
            Text(fallback)
                .font(.custom(abhayaRegular, size: 17))
                .foregroundStyle(.black.opacity(0.6))
        }
    }
}

/// Fila con imagen y texto (soporta cualquiera de los lados)
private struct PromoRow: View {
    var leftImage: String? = nil
    var rightImage: String? = nil
    var leftText: String? = nil
    var rightText: String? = nil

    var body: some View {
        HStack(spacing: 16) {
            // IZQUIERDA
            Group {
                if let name = leftImage {
                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                } else if let text = leftText {
                    Text(text)
                        .font(.custom(abhayaRegular, size: 20))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                }
            }

            // DERECHA
            Group {
                if let name = rightImage {
                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                } else if let text = rightText {
                    Text(text)
                        .font(.custom(abhayaRegular, size: 20))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                }
            }
        }
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
