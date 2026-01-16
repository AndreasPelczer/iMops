//
//  EmployeeSelectView.swift
//  IMops
//
//  Created by Andreas Pelczer on 16.01.26.
//


import SwiftUI
import SwiftData

struct EmployeeSelectView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppRouter.self) private var router
    
    // Wir laden alle Personen, alphabetisch sortiert
    @Query(sort: \Person.displayName) private var employees: [Person]
    
    @State private var showingAddMember = false
    @State private var newName = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("DIE BRIGADE")
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(.orange)
                Text("Wer übernimmt die Schicht?")
                    .font(.title2.bold())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
            .background(Color(white: 0.08))
            
            // Mitarbeiter-Liste
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(employees) { person in
                        Button {
                            selectEmployee(person)
                        } label: {
                            EmployeeCard(name: person.displayName)
                        }
                    }
                    
                    // Button zum Hinzufügen (für das MVP/Setup)
                    Button {
                        showingAddMember = true
                    } label: {
                        VStack {
                            Image(systemName: "plus.circle")
                                .font(.title)
                            Text("Neu")
                                .font(.caption.bold())
                        }
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.orange.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [5])))
                        .foregroundColor(.orange)
                    }
                }
                .padding(20)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Abbrechen") { router.path.removeLast() }
                    .foregroundColor(.secondary)
            }
        }
        .sheet(isPresented: $showingAddMember) {
            NavigationStack {
                Form {
                    TextField("Name des Kollegen", text: $newName)
                }
                .navigationTitle("Neues Mitglied")
                .toolbar {
                    Button("Speichern") {
                        addEmployee()
                    }
                    .disabled(newName.isEmpty)
                }
            }
            .presentationDetents([.height(200)])
        }
    }
    
    private func selectEmployee(_ person: Person) {
        var mutableRouter = router
        mutableRouter.activeEmployeeID = person.id
        // Wir pushen zur nächsten View: MyTasksView
        router.path.append(person)
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    private func addEmployee() {
        let person = Person(displayName: newName)
        modelContext.insert(person)
        newName = ""
        showingAddMember = false
    }
}

// MARK: - Unterstützende UI-Komponente
struct EmployeeCard: View {
    let name: String
    
    var body: some View {
        VStack {
            // Ein Initial-Kreis, wie in alten Terminal-Systemen
            Text(String(name.prefix(1)).uppercased())
                .font(.system(size: 24, weight: .black, design: .monospaced))
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color(white: 0.15)))
                .foregroundColor(.orange)
            
            Text(name)
                .font(.system(.body, design: .monospaced))
                .bold()
                .lineLimit(1)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(white: 0.1)))
    }
}