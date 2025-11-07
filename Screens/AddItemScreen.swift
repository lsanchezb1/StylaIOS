//
//  AddItemScreen.swift
//  StylaSwift
//
//  Created by Telematica on 4/11/25.
//

import SwiftUI

private let abhayaRegular = "AbhayaLibre-Regular"

// Colores locales
private let primaryColor    = Color(red: 0x9C/255, green: 0x5A/255, blue: 0x2D/255)  // #9C5A2D
private let backgroundColor = Color(red: 0xF3/255, green: 0xE9/255, blue: 0xD4/255)  // #F3E9D4
private let cardColor       = Color(red: 0xE7/255, green: 0xDC/255, blue: 0xCC/255)  // #E7DCCC

struct AddItemScreen: View {
    // Navegación
    let onBack: () -> Void

    // Estado
    @State private var price: String = ""
    @State private var location: String = ""
    @State private var pickedImage: Image? = nil

    var body: some View {
        VStack(spacing: 0) {
            // ---------- TopBar ----------
            HStack {
                Spacer()
                Image("styla")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                Spacer().frame(width: 44)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(backgroundColor)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Título
                    Text("Sube la foto de tu prenda")
                        .font(.custom(abhayaRegular, size: 26))
                        .foregroundStyle(primaryColor)
                        .padding(.bottom, 24)

                    // 1) Área para imagen (tap simulado)
                    Button {
                        // TODO: abrir cámara/galería
                        // Por ahora simulamos una imagen cargada:
                        pickedImage = Image(systemName: "photo")
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(cardColor)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(primaryColor.opacity(0.5), lineWidth: 2)
                                )
                            VStack(spacing: 8) {
                                if let img = pickedImage {
                                    img
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 120)
                                        .foregroundStyle(primaryColor)
                                } else {
                                    Image(systemName: "camera.viewfinder")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 48)
                                        .foregroundStyle(primaryColor)
                                    Text("Agregar Foto del Artículo")
                                        .font(.custom(abhayaRegular, size: 18))
                                        .foregroundStyle(primaryColor)
                                }
                            }
                        }
                        .frame(height: 200)
                    }
                    .buttonStyle(.plain)

                    Spacer().frame(height: 20)

                    // Campos adicionales
                    VStack(spacing: 14) {
                        FieldShell {
                            HStack {
                                Image(systemName: "dollarsign.circle")
                                TextField("Precio", text: $price)
                                    .font(.custom(abhayaRegular, size: 16))
                                    .keyboardType(.decimalPad)
                            }
                        }
                        FieldShell {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                TextField("Ubicación", text: $location)
                                    .font(.custom(abhayaRegular, size: 16))
                                    .textInputAutocapitalization(.words)
                            }
                        }
                    }

                    Spacer().frame(height: 40)

                    // Publicar
                    Button {
                        // TODO: publicar
                    } label: {
                        Text("Subir")
                            .font(.custom(abhayaRegular, size: 20))
                            .frame(maxWidth: .infinity, minHeight: 55)
                    }
                    .background(primaryColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(24)
            }
            .background(backgroundColor)
        }
        .background(backgroundColor)
        .ignoresSafeArea(edges: .top)
    }
}

// Contenedor con borde (equivalente visual a tus OutlinedTextField)
private struct FieldShell<Content: View>: View {
    let content: () -> Content
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12).fill(.white.opacity(0.9))
            RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.8), lineWidth: 1)
            HStack(spacing: 8) {
                content()
            }
            .padding(.horizontal, 12)
            .frame(height: 48)
        }
    }
}
