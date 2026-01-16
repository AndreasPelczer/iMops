//
//  TodayView.swift
//  IMops
//
//  Created by Andreas Pelczer on 16.01.26.
//


import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppRouter.self) private var router
    
    // Wir holen alle Tasks des Tages
    @Query private var allTasks: [Task]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: - Brigade Puls (Status Kacheln)
                HStack(spacing: 16) {
                    StatusCard(
                        title: "OFFEN",
                        count: allTasks.filter { $0.statusValue == "open" }.count,
                        color: .secondary
                    )
                    StatusCard(
                        title: "IN ARBEIT",
                        count: allTasks.filter { $0.statusValue == "inProgress" }.count,
                        color: .blue
                    )
                }
                
                // MARK: - Die Firewall-Anzeige
                MenschMeierStatusView(securityLevel: router.securityLevel)
                
                // MARK: - Kritische Zone (Was brennt?)
                VStack(alignment: .leading, spacing: 12) {
                    Label("KRITISCHE PRIORITÄT", systemImage: "flame.fill")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.red)
                        .bold()
                    
                    let criticalTasks = allTasks.filter { $0.priorityValue == "critical" || $0.priorityValue == "allergen" }
                    
                    if criticalTasks.isEmpty {
                        Text("Aktuell keine kritischen Engpässe. Bleib fokussiert.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(white: 0.1)))
                    } else {
                        ForEach(criticalTasks) { task in
                            NavigationLink(value: task) {
                                CriticalTaskRow(task: task)
                            }
                        }
                    }
                }
                
                // MARK: - Team Spirit (Wer ist am Start?)
                VStack(alignment: .leading, spacing: 12) {
                    Text("AKTIVE BRIGADE")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.orange)
                        .bold()
                    
                    // Hier würde im echten System die Liste der angemeldeten MA stehen
                    Text("Stefan, Michel, Frank, Daniel")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(white: 0.1)))
                }
                
                Spacer(minLength: 100)
            }
            .padding(20)
        }
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("HEUTE")
    }
}

// MARK: - UI Komponenten

struct StatusCard: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(.caption2, design: .monospaced))
                .bold()
            Text("\(count)")
                .font(.system(size: 32, weight: .black, design: .monospaced))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(color.opacity(0.15)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(0.3), lineWidth: 1))
        .foregroundColor(color)
    }
}

struct MenschMeierStatusView: View {
    let securityLevel: SecurityLevel
    
    var body: some View {
        HStack {
            Image(systemName: securityLevel == .deEscalation ? "shield.fill" : "shield")
                .font(.title2)
            VStack(alignment: .leading) {
                Text("MENSCH-MEIER-SCHUTZ")
                    .font(.system(.caption, design: .monospaced)).bold()
                Text(securityLevel == .deEscalation ? "DE-ESKALATION AKTIV (Guerilla-Modus)" : "STANDARD (Privatsphäre gewahrt)")
                    .font(.caption2)
            }
            Spacer()
        }
        .padding()
        .background(securityLevel == .deEscalation ? Color.orange.opacity(0.2) : Color.green.opacity(0.15))
        .foregroundColor(securityLevel == .deEscalation ? .orange : .green)
        .cornerRadius(12)
    }
}

struct CriticalTaskRow: View {
    let task: Task
    var body: some View {
        HStack {
            Rectangle()
                .fill(task.priorityValue == "allergen" ? Color.green : Color.red)
                .frame(width: 4)
            VStack(alignment: .leading) {
                Text(task.title).bold()
                Text(task.priorityValue == "allergen" ? "ALLERGEN-GEFAHR" : "Prio: Kritisch")
                    .font(.caption2).opacity(0.8)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .padding()
        .background(Color(white: 0.15))
        .cornerRadius(8)
    }
}