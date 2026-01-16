//
//  MenschMeierModus.swift
//  IMops
//
//  Created by Andreas Pelczer on 16.01.26.
//


import Foundation
import SwiftData

/// Das Immunsystem von GastroGrid Omni.
/// Verhindert, dass operative Daten für personenbezogene Überwachung missbraucht werden.
struct MenschMeierModus {
    
    /// Berechnet die Last der Brigade, ohne den Einzelnen bloßzustellen.
    /// - Parameter tasks: Die Liste der aktuellen Aufgaben
    /// - Returns: Ein aggregierter Belastungswert (0.0 - 1.0)
    static func calculateBrigadeLoad(from tasks: [Task]) -> Double {
        let totalSteps = tasks.flatMap { $0.steps }.count
        guard totalSteps > 0 else { return 0.0 }
        
        let completedSteps = tasks.flatMap { $0.steps }.filter { $0.isDone }.count
        let rawLoad = Double(completedSteps) / Double(totalSteps)
        
        // Rio-Reiser-Prinzip: Wir geben dem Admin nur ein "Rauschen", 
        // damit er keine Mikrosekunden zählt.
        let jitter = Double.random(in: -0.05...0.05)
        return min(max(rawLoad + jitter, 0.0), 1.0)
    }
    
    /// Die "Giftpille": Anonymisierung von Evidenz-Daten für den Admin-Modus.
    /// Ein Admin sieht DAS etwas getan wurde, aber im Stress-Fall nicht von WEM.
    static func anonymizeForAdmin(entry: EvidenceEntry, currentSecurity: SecurityLevel) -> String {
        switch currentSecurity {
        case .standard:
            return entry.author // Im Normalbetrieb okay
        case .deEscalation:
            // Im Guerilla-Modus wird der Name durch "Brigade" ersetzt.
            // Der Schutz der Gruppe schlägt die Rückverfolgbarkeit.
            return "Brigade" 
        }
    }
    
    /// Prüft auf "Management-Missbrauch"
    /// Wenn zu viele Detail-Abfragen in zu kurzer Zeit kommen, 
    /// schaltet das System den Datenstrom temporär auf "Unschärfe".
    static func shouldTriggerPrivacyShield(requestCount: Int) -> Bool {
        return requestCount > 50 // Beispiel-Schwellenwert
    }
}

extension Task {
    /// Gibt an, ob diese Aufgabe gerade "ethisch geschützt" ist.
    var isPrivacyShieldActive: Bool {
        // Kritische Aufgaben (Allergene) sind immer transparent, 
        // Routine-Aufgaben werden bei Stress geschützt.
        self.priorityValue != "allergen"
    }
}