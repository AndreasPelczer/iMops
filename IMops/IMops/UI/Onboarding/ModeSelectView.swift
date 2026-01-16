//
//  ModeSelectView.swift
//  IMops
//
//  Created by Andreas Pelczer on 16.01.26.
//


import SwiftUI

struct ModeSelectView: View {
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        NavigationStack(path: Bindable(router).path) {
            VStack(spacing: 40) {
                Spacer()
                
                // Das Logo-Ersatz: Die Haltung
                VStack(spacing: 10) {
                    Text("GASTRO-GRID OMNI")
                        .font(.system(size: 24, weight: .black, design: .monospaced))
                        .tracking(4)
                    Text("EST. 2026 / FRANKFURT")
                        .font(.caption)
                        .opacity(0.6)
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    // DER COMMANDER (Admin)
                    Button {
                        selectMode(.admin)
                    } label: {
                        RoleCard(
                            title: "COMMANDER",
                            subtitle: "Planung, Standards & Überblick",
                            icon: "shield.checkerboard",
                            color: .orange
                        )
                    }
                    
                    // DIE BRIGADE (Mitarbeiter)
                    Button {
                        selectMode(.employee)
                    } label: {
                        RoleCard(
                            title: "BRIGADE",
                            subtitle: "Service, Produktion & Fokus",
                            icon: "person.2.fill",
                            color: .blue
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Text("V 1.0 - NO BULLSHIT EDITION")
                    .font(.system(.caption2, design: .monospaced))
                    .opacity(0.4)
            }
            .background(Color(white: 0.05).ignoresSafeArea())
            .preferredColorScheme(.dark)
            .navigationDestination(for: AppMode.self) { mode in
                if mode == .employee {
                    EmployeeSelectView()
                } else {
                    // AdminDashboardView() // Kommt später
                    Text("Admin Dashboard (Coming Soon)")
                }
            }
        }
    }
    
    private func selectMode(_ mode: AppMode) {
        var mutableRouter = router
        mutableRouter.currentMode = mode
        router.path.append(mode)
        
        // Haptisches Feedback: Ein kurzer Schlag, wie ein Klaps auf die Schulter
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
    }
}

// MARK: - Unterstützende UI-Komponente
struct RoleCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(color)
                .frame(width: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.title2, weight: .bold))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(white: 0.12))
                .shadow(color: color.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

#Preview {
    ModeSelectView()
        .environment(AppRouter())
}