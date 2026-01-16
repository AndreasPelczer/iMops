//
//  AssistantSheet.swift
//  IMops
//
//  Created by Andreas Pelczer on 16.01.26.
//


import SwiftUI
import SwiftData

struct AssistantSheet: View {
    @Bindable var task: Task
    @Environment(AppRouter.self) private var router
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    
                    // MARK: - 1. STAND (Die nackte Wahrheit)
                    AssistantSection(title: "STAND", icon: "info.circle.fill", color: .blue) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Aufgabe: \(task.title)")
                                .font(.headline)
                            Text("Fortschritt: \(task.steps.filter { $0.isDone }.count) von \(task.steps.count) Schritten erledigt.")
                            if router.securityLevel == .deEscalation {
                                Text("SCHUTZMODUS AKTIV: Datenfluss zum Admin geglättet.")
                                    .foregroundColor(.orange)
                                    .font(.caption.bold())
                            }
                        }
                    }
                    
                    // MARK: - 2. RISIKEN (Was schiefgehen kann)
                    AssistantSection(title: "RISIKEN", icon: "exclamationmark.triangle.fill", color: .red) {
                        VStack(alignment: .leading, spacing: 12) {
                            if task.priorityValue == "allergen" {
                                RiskRow(text: "KREUZKONTAMINATION: Höchste Vorsicht bei Gerätschaften.")
                            }
                            RiskRow(text: "ZEITDRUCK: Aktuelle Geschwindigkeit gefährdet Pünktlichkeit für Halle 3.")
                            RiskRow(text: "MAILLARD-PEAK: Bei aktueller Hitze droht Bitterkeit in 120 Sekunden.")
                        }
                    }
                    
                    // MARK: - 3. OPTIONEN (Was jetzt zu tun ist)
                    AssistantSection(title: "OPTIONEN", icon: "lightbulb.fill", color: .yellow) {
                        VStack(spacing: 12) {
                            OptionButton(text: "Priorität erhöhen & Hilfe anfordern", icon: "person.2.wave.2.fill") {
                                task.priorityValue = "critical"
                                dismiss()
                            }
                            
                            OptionButton(text: "Garprozess verlangsamen (Hitze runter)", icon: "thermometer.snowflake") {
                                saveAdviceAsNote("Option gewählt: Hitze reduziert, um Zeit zu gewinnen.")
                                dismiss()
                            }
                            
                            OptionButton(text: "Schritt überspringen (Qualitäts-Tradeoff)", icon: "forward.fill") {
                                saveAdviceAsNote("Option gewählt: Zwischenschritt übersprungen wegen Zeitmangel.")
                                dismiss()
                            }
                        }
                    }
                }
                .padding(24)
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("HANNES ADVISOR")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Schließen") { dismiss() }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func saveAdviceAsNote(_ note: String) {
        let evidence = EvidenceEntry(kindValue: "note", payload: note, author: "Advisor")
        task.evidences.append(evidence)
    }
}

// MARK: - Unterstützende UI-Komponenten
struct AssistantSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: Content
    
    init(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.system(.caption, design: .monospaced))
                .bold()
                .foregroundColor(color)
            
            content
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(white: 0.12)))
        }
    }
}

struct RiskRow: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•").foregroundColor(.red)
            Text(text).font(.subheadline)
        }
    }
}

struct OptionButton: View {
    let text: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(text)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.05)))
            .foregroundColor(.white)
        }
    }
}