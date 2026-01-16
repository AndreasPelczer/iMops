//
//  TaskRepository.swift
//  IMops
//
//  Created by Andreas Pelczer on 16.01.26.
//


import Foundation
import SwiftData

/// Das Repository für den Datenzugriff.
/// Reduziert das Chaos auf die Essenz.
@MainActor
final class TaskRepository {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Mitarbeiter-Abfragen (Der Schutzraum)
    
    /// Holt alle Aufgaben für einen spezifischen Mitarbeiter, die noch nicht erledigt sind.
    func fetchActiveTasks(for employeeID: UUID) -> [Task] {
        let employeeIDString = employeeID.uuidString
        let predicate = #Predicate<Task> { task in
            task.statusValue != "done" && task.assignedTo.contains(employeeIDString)
        }
        
        let descriptor = FetchDescriptor<Task>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.priorityValue, order: .reverse)]
        )
        
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    // MARK: - Admin-Abfragen (Der Überblick)
    
    /// Holt alle Aufgaben eines Events für die Planung.
    func fetchAllTasks(for eventID: UUID) -> [Task] {
        // Hinweis: In einer realen App würden wir hier über das MajorEvent filtern.
        let descriptor = FetchDescriptor<Task>(
            sortBy: [SortDescriptor(\.title)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    // MARK: - Mutationen (Die Action)
    
    /// Ändert den Status einer Aufgabe und loggt die Änderung (Evidence).
    func updateStatus(task: Task, newStatus: AuftragStatus, author: String) {
        task.statusValue = newStatus.rawValue
        
        // Dokumentation als Nebenprodukt
        let note = "Status geändert auf \(newStatus.displayName)"
        let evidence = EvidenceEntry(kindValue: "note", payload: note, author: author)
        task.evidences.append(evidence)
        
        try? modelContext.save()
    }
    
    /// Erzeugt die Initial-Schritte aus einem Standard (Template-Logik)
    func applyStandardSteps(to task: Task, steps: [String]) {
        for (index, stepTitle) in steps.enumerated() {
            let newStep = Step(title: stepTitle, sortIndex: index)
            task.steps.append(newStep)
        }
    }
}