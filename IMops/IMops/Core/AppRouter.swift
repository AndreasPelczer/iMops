//
//  AppRouter.swift
//  IMops
//
//  Created by Andreas Pelczer on 16.01.26.
//


import SwiftUI
import Observation

@Observable
final class AppRouter {
    // MARK: - App Status
    var currentMode: AppMode = .employee
    var currentTone: ToneMode = .normal
    var securityLevel: SecurityLevel = .standard
    
    // MARK: - User Context
    var activeEmployeeID: UUID? = nil
    var activeMajorEventID: UUID? = nil
    
    // MARK: - Navigation
    // Wir nutzen NavigationPath für modernes, entkoppeltes Routing
    var path = NavigationPath()
    
    // MARK: - Logic
    
    /// Schaltet in den Live-Modus (Bourdain-Style)
    func enterServiceMode() {
        withAnimation {
            currentTone = .live
        }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    /// Zurück zur Normalität (Nachbereitung/Planung)
    func exitServiceMode() {
        withAnimation {
            currentTone = .normal
        }
    }
    
    /// Der Rio-Reiser-Sicherheitscheck
    /// Verhindert, dass Admins auf MA-Details zugreifen, wenn das System "heiß" läuft.
    func validateAccess() -> Bool {
        if currentMode == .admin && securityLevel == .deEscalation {
            // Hier greift die Giftpille: Admin sieht nur aggregierte Daten
            return false 
        }
        return true
    }
    
    /// Reset der Session (Schichtende)
    func resetSession() {
        path = NavigationPath()
        activeEmployeeID = nil
        exitServiceMode()
        securityLevel = .standard
    }
}