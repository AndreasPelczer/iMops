//
//  MyTasksView.swift
//  IMops
//
//  Created by Andreas Pelczer on 16.01.26.
//


import SwiftUI
import SwiftData

struct MyTasksView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppRouter.self) private var router
    
    // Status-Filter für die Ansicht
    @State private var selectedStatus: AuftragStatus = .inProgress
    
    // Dynamische Abfrage basierend auf dem aktiven Mitarbeiter
    @Query private var tasks: [Task]
    
    init(employeeID: UUID?) {
        let idString = employeeID?.uuidString ?? ""
        let predicate = #Predicate<Task> { task in
            task.assignedTo.contains(idString)
        }
        _tasks = Query(filter: predicate, sort: \Task.priorityValue, order: .reverse)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter-Bar
            Picker("Status", selection: $selectedStatus) {
                ForEach(AuftragStatus.allCases, id: \.self) { status in
                    Text(status.displayName).tag(status)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .background(Color(white: 0.05))
            
            List {
                let filteredTasks = tasks.filter { $0.statusValue == selectedStatus.rawValue }
                
                if filteredTasks.isEmpty {
                    ContentUnavailableView(
                        "Keine Aufgaben",
                        systemImage: selectedStatus.iconName,
                        description: Text("In diesem Status gibt es aktuell nichts zu tun.")
                    )
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(filteredTasks) { task in
                        NavigationLink(value: task) {
                            TaskRow(task: task)
                        }
                        .listRowBackground(Color(white: 0.1))
                        .listRowSeparatorTint(Color.white.opacity(0.1))
                    }
                }
            }
            .listStyle(.plain)
        }
        .background(Color.black)
        .navigationTitle(selectedStatus.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Task Row Komponente
struct TaskRow: View {
    let task: Task
    
    var body: some View {
        HStack(spacing: 16) {
            // Prioritäts-Indikator
            if let icon = Priority(rawValue: task.priorityValue)?.iconName {
                Image(systemName: icon)
                    .foregroundColor(Priority(rawValue: task.priorityValue)?.color ?? .secondary)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                if let detail = task.detailText {
                    Text(detail)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Fortschritts-Anzeige (Steps)
            if !task.steps.isEmpty {
                let done = task.steps.filter { $0.isDone }.count
                Text("\(done)/\(task.steps.count)")
                    .font(.system(.caption, design: .monospaced))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(4)
            }
        }
        .padding(.vertical, 8)
    }
}