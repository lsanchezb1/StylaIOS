//  StartScreen.swift
//  StylaSwift
//
//  Created by Telematica on 4/11/25.
//

import SwiftUI
import Combine
#if canImport(UIKit)
import UIKit
#endif

private let abhayaRegular = "AbhayaLibre-Regular"

private enum CategoryIcon { case sfSymbol(String), asset(String) }
private struct CategoryItem: Identifiable { let id = UUID(); let name: String; let icon: CategoryIcon }
private struct CarouselItem: Identifiable { let id = UUID(); let title: String; let description: String; let imageName: String }

struct StartScreen: View {
    // Navegación (abre cámara)
    let onOpenCamera: () -> Void

    // Colores
    private let primaryColor = Color(red: 0x9C/255.0, green: 0x5A/255.0, blue: 0x2D/255.0)
    private let backgroundColor = Color(red: 0xF3/255.0, green: 0xE9/255.0, blue: 0xD4/255.0)
    private let cardColor = Color(red: 0xE7/255.0, green: 0xDC/255.0, blue: 0xCC/255.0)

    // Estado
    @State private var loading: Bool = false
    @State private var firstName: String = "Usuario"
    @State private var searchText: String = ""
    @State private var currentPage: Int = 0
    @State private var selectedTabIndex: Int = 0

    // Data
    private let carouselItems: [CarouselItem] = [
        .init(title: "Tendencias",   description: "Conoce las tendencias\npara este otoño 2025", imageName: "foto"),
        .init(title: "Colorimetría", description: "Potencia tu estilo eligiendo los colores que mejor armonicen con tu piel.", imageName: "color"),
        .init(title: "Siluetas",     description: "Descubre los cortes y formas que definen la temporada.", imageName: "silueta")
    ]
    private let categories: [CategoryItem] = [
        .init(name: "Blusas",   icon: .sfSymbol("hanger")),
        .init(name: "Zapatos",  icon: .asset("zapato1")),
        .init(name: "Gafas",    icon: .asset("gafas")),
        .init(name: "Vestidos", icon: .sfSymbol("figure.dress"))
    ]

    // Autoplay del carrusel
    private let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // ---------- Sección 1: TopBar + loading ----------
                    Group {
                        HStack {
                            Spacer()
                            Image("styla")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                            Spacer()
                            Button(action: { /* menú */ }) {
                                Image(systemName: "line.3.horizontal")
                                    .foregroundStyle(.black)
                                    .imageScale(.large)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .background(backgroundColor)

                        if loading {
                            ProgressView()
                                .tint(primaryColor)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 6)
                        }

                        Spacer().frame(height: 16)
                    }

                    // ---------- Sección 2: Header + búsqueda ----------
                    Group {
                        HStack(alignment: .center) {
                            Spacer().frame(width: 12)
                            VStack(alignment: .leading) {
                                Text("¡Hola \(firstName)!")
                                    .font(.custom(abhayaRegular, size: 22))
                                    .foregroundStyle(.black)
                                Text("Hoy me veo genial")
                                    .font(.custom(abhayaRegular, size: 16))
                                    .foregroundStyle(Color(hex: 0x4B4B4B))
                            }
                        }
                        .frame(maxWidth: .infinity)

                        Spacer().frame(height: 24)

                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                            TextField("Buscar", text: $searchText)
                                .font(.custom(abhayaRegular, size: 16))
                            Button(action: { /* voz */ }) { Image(systemName: "mic.fill") }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color(hex: 0xE0D9C5), lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        Spacer().frame(height: 24)
                    }

                    // ---------- Sección 3: Carrusel + indicadores ----------
                    Group {
                        TabView(selection: $currentPage) {
                            ForEach(carouselItems.indices, id: \.self) { i in
                                CarouselCard(
                                    item: carouselItems[i],
                                    primaryColor: primaryColor,
                                    cardColor: cardColor
                                )
                                .tag(i)
                            }
                        }
                        .frame(height: 180)
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .onReceive(timer) { _ in
                            withAnimation(.easeInOut(duration: 0.6)) {
                                currentPage = (currentPage + 1) % carouselItems.count
                            }
                        }

                        HStack(spacing: 8) {
                            ForEach(carouselItems.indices, id: \.self) { i in
                                Circle()
                                    .fill(i == currentPage ? primaryColor : Color(hex: 0xC7B197))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)

                        Spacer().frame(height: 12)
                    }

                    // ---------- Sección 4: Categorías ----------
                    Group {
                        Text("Categorías")
                            .font(.custom(abhayaRegular, size: 20))
                            .foregroundStyle(.black)
                            .padding(.bottom, 12)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(categories) { c in
                                    VStack {
                                        ZStack {
                                            Circle().fill(cardColor).frame(width: 60, height: 60)
                                            categoryIconView(c.icon)
                                                .frame(width: 40, height: 40)
                                                .foregroundStyle(primaryColor)
                                        }
                                        Text(c.name)
                                            .font(.custom(abhayaRegular, size: 14))
                                            .foregroundStyle(.black)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Spacer().frame(height: 24)
                    }

                    // ---------- Sección 5: CTA ----------
                    Group {
                        Button(action: { /* ir a vender */ }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Quiero vender\nmi ropa")
                                        .font(.custom(abhayaRegular, size: 18))
                                        .foregroundStyle(.white)
                                        .lineSpacing(4)
                                }
                                Spacer()
                                HStack(spacing: 8) {
                                    Image(systemName: "dollarsign.circle.fill").imageScale(.large)
                                    Image(systemName: "chevron.right").imageScale(.medium)
                                }
                                .foregroundStyle(.white)
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 80)
                            .frame(maxWidth: .infinity)
                            .background(primaryColor)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 2)
                        }

                        Spacer(minLength: 120) // espacio para la bottom bar
                    }
                }
                .padding(.horizontal, 16)
                .background(backgroundColor)
            }

            // ---------- Bottom Bar ----------
            BottomNavBar(
                selectedIndex: $selectedTabIndex,
                primaryColor: primaryColor,
                cardColor: cardColor,
                onTap: { idx in
                    if idx == 1 { onOpenCamera() } // Cámara
                    selectedTabIndex = idx
                }
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }

    // Icono de categoría
    @ViewBuilder
    private func categoryIconView(_ icon: CategoryIcon) -> some View {
        switch icon {
        case .sfSymbol(let name):
            Image(systemName: name).resizable().scaledToFit().padding(8)
        case .asset(let name):
            Image(name).resizable().scaledToFit().padding(8)
        }
    }
}

// ---------------- Subvistas ----------------

private struct BottomNavBar: View {
    @Binding var selectedIndex: Int
    let primaryColor: Color
    let cardColor: Color
    let onTap: (Int) -> Void

    private let items: [(label: String, symbol: String)] = [
        ("Inicio", "house.fill"),
        ("Cámara", "camera.fill"),
        ("Guardado", "heart"),
        ("Perfil", "person.fill")
    ]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(cardColor)
                .frame(height: 80)
                .shadow(radius: 1)
            HStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { idx in
                    let isSelected = idx == selectedIndex
                    Button { onTap(idx) } label: {
                        ZStack {
                            if isSelected {
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(primaryColor)
                                    .frame(width: 90, height: 65)
                            }
                            VStack(spacing: 4) {
                                Image(systemName: items[idx].symbol)
                                    .imageScale(.medium)
                                    .foregroundStyle(isSelected ? .white : primaryColor)
                                Text(items[idx].label)
                                    .font(.custom(abhayaRegular, size: 12))
                                    .foregroundStyle(isSelected ? .white : Color(hex: 0x4B4B4B))
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 0)
        .padding(.bottom, 0)
    }
}

private struct CarouselCard: View {
    let item: CarouselItem
    let primaryColor: Color
    let cardColor: Color

    var body: some View {
        HStack(spacing: 0) {
            // Texto
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.custom(abhayaRegular, size: 22))
                    .foregroundStyle(primaryColor)
                Text(item.description)
                    .font(.custom(abhayaRegular, size: 16))
                    .foregroundStyle(.black)
                    .lineSpacing(2)
                Spacer().frame(height: 12)
                Button("Ir") { }
                    .buttonStyle(.plain)
                    .font(.custom(abhayaRegular, size: 16))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(primaryColor)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)

            // Imagen
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 180)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 4, y: 1)
    }
}

// ---------------- Utilidad ----------------

private extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255,
                  opacity: alpha)
    }
}
