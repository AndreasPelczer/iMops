//
//  MajorEvent.swift
//  IMops
//
//  Created by Andreas Pelczer on 16.01.26.
//


import Foundation
import SwiftData

@Model
final class MajorEvent {
    var id: UUID = UUID()
    var title: String
    var startDate: Date
    var endDate: Date
    @Relationship(deleteRule: .cascade) var orders: [Order] = []
    
    init(title: String, startDate: Date = Date(), endDate: Date = Date().addingTimeInterval(86400)) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }
}

@Model
final class Order {
    var id: UUID = UUID()
    var title: String
    var statusValue: String = "open"
    @Relationship(deleteRule: .cascade) var tasks: [Task] = []
    
    init(title: String) {
        self.title = title
    }
}

@Model
final class Task {
    var id: UUID = UUID()
    var title: String
    var detailText: String?
    var statusValue: String = "open"
    var priorityValue: String = "standard"
    var assignedTo: [String] = [] // Mitarbeiter-IDs
    @Relationship(deleteRule: .cascade) var steps: [Step] = []
    @Relationship(deleteRule: .cascade) var evidences: [EvidenceEntry] = []
    
    init(title: String, detailText: String? = nil) {
        self.title = title
        self.detailText = detailText
    }
}

@Model
final class Step {
    var id: UUID = UUID()
    var title: String
    var isDone: Bool = false
    var requiresEvidence: Bool = false
    var sortIndex: Int = 0
    
    init(title: String, sortIndex: Int = 0, requiresEvidence: Bool = false) {
        self.title = title
        self.sortIndex = sortIndex
        self.requiresEvidence = requiresEvidence
    }
}

@Model
final class EvidenceEntry {
    var id: UUID = UUID()
    var timestamp: Date = Date()
    var kindValue: String // "note", "photo", "measurement"
    var payload: String // Hier landet die Notiz oder der Messwert
    var author: String
    
    init(kindValue: String, payload: String, author: String) {
        self.kindValue = kindValue
        self.payload = payload
        self.author = author
    }
}