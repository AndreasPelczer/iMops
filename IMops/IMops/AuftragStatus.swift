//
//  AuftragStatus.swift
//  IMops
//
//  Created by Andreas Pelczer on 16.01.26.
//


import SwiftUI

// MARK: - AuftragStatus
/// Die stabilen Zustände einer Aufgabe. 
/// Ersetzt "vielleicht", "gleich" und "da" durch binäre Klarheit.
enum AuftragStatus: String, CaseIterable, Codable {
    case pending = "open"
    case inProgress = "inProgress"
    case onHold = "onHold"
    case completed = "done"
    
    var displayName: String {
        switch self {
        case .pending: return String(localized: "Offen")
        case .inProgress: return String(localized: "In Arbeit")
        case .onHold: return String(localized: "Pausiert")
        case .completed: return String(localized: "Erledigt")
        }
    }
    
    var iconName: String {
        switch self {
        case .pending: return "clock"
        case .inProgress: return "play.circle.fill"
        case .onHold: return "pause.circle.fill"
        case .completed: return "checkmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .pending: return .secondary
        case .inProgress: return .blue
        case .onHold: return .orange
        case .completed: return .green
        }
    }
}

// MARK: - Priority
/// Die Dringlichkeit. Bestimmt die Sichtbarkeit im "Live-Modus".
enum Priority: String, CaseIterable, Codable {
    case standard = "standard"
    case important = "important"
    case critical = "critical"
    case allergen = "allergen"
    
    var iconName: String? {
        switch self {
        case .critical: return "exclamationmark.octagon.fill"
        case .allergen: return "leaf.fill"
        case .important: return "exclamationmark.circle.fill"
        default: return nil
        }
    }
    
    var color: Color {
        switch self {
        case .critical: return .red
        case .allergen: return .green
        case .important: return .orange
        default: return .secondary
        }
    }
}

// MARK: - ToneMode
/// Löst das Problem der Indexikalität. 
/// Bestimmt, wie das System mit dem Menschen spricht.
enum ToneMode: String, Codable {
    case normal  // Wertschätzend, erklärend (Vorbereitung/Nachbereitung)
    case live    // Kurz, prägnant, befehlend (Stress-Situation/Service)
}

// MARK: - AppMode
/// Die ethische Trennung der Machtbereiche.
enum AppMode: String, Codable {
    case employee // Fokus: Arbeit erledigen, Schutz aktiv
    case admin    // Fokus: Planung & Überblick, keine Überwachung
}

// MARK: - EvidenceKind
/// Die Art des Nachweises. 
/// "Dokumentation als Nebenprodukt".
enum EvidenceKind: String, Codable {
    case note = "note"
    case photo = "photo"
    case measurement = "measurement"
}

// MARK: - Mensch-Meier-Sicherheit
/// Stufen der ethischen Firewall.
enum SecurityLevel: String, Codable {
    case standard    // Schutz der Identität aktiv
    case deEscalation // Guerilla-Modus: System täuscht Management, um MA zu schützen
}