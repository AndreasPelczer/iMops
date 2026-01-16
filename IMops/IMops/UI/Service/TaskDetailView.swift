//
//  TaskDetailView.swift
//  IMops
//
//  Created by Andreas Pelczer on 16.01.26.
//


import SwiftUI
import SwiftData

struct TaskDetailView: View {
    @Bindable var task: Task
    @Environment(\.modelContext) private var modelContext
    @Environment(AppRouter.self) private var router
    
    @State private var showingEvidenceSheet = false
    @State private var showingAssistantSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(task.title)
                        .font(.system(.title, weight: .black))
                    Spacer()
                    StatusChipView(status: AuftragStatus(rawValue: task.statusValue) ?? .pending)
                }
                
                if let detail = task.detailText {
                    Text(detail)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(24)
            .background(Color(white: 0.08))
            
            // MARK: - Checklist (Steps)
            List {
                Section(header: Text("SCHRITTE").font(.caption.bold()).foregroundColor(.orange)) {
                    ForEach(task.steps.sorted(by: { $0.sortIndex < $1.sortIndex })) { step in
                        Button {
                            step.isDone.toggle()
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        } label: {
                            HStack {
                                Image(systemName: step.isDone ? "checkmark.square.fill" : "square")
                                    .foregroundColor(step.isDone ? .green : .orange)
                                Text(step.title)
                                    .strikethrough(step.isDone)
                                    .foregroundColor(step.isDone ? .secondary : .primary)
                                Spacer()
                                if step.requiresEvidence && !step.isDone {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                .listRowBackground(Color(white: 0.12))
            }
            .listStyle(.insetGrouped)
            
            // MARK: - Footer (Actions)
            VStack(spacing: 16) {
                HStack(spacing: 20) {
                    // Der Guerilla-Tap (Long Press für Hilfe)
                    Button(action: { showingAssistantSheet = true }) {
                        Image(systemName: "brain.head.profile")
                            .font(.title2)
                            .frame(width: 60, height: 60)
                            .background(Circle().fill(Color.orange.opacity(0.2)))
                            .foregroundColor(.orange)
                    }
                    .simultaneousGesture(LongPressGesture(minimumDuration: 2.0).onEnded { _ in
                        router.securityLevel = .deEscalation
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    })
                    
                    // Status-Action (Start / Done)
                    Button {
                        toggleTaskStatus()
                    } label: {
                        Text(task.statusValue == "inProgress" ? "ABSCHLIESSEN" : "START")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(task.statusValue == "inProgress" ? Color.green : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    // Evidence-Button
                    Button {
                        showingEvidenceSheet = true
                    } label: {
                        Image(systemName: "camera.fill")
                            .font(.title2)
                            .frame(width: 60, height: 60)
                            .background(Circle().fill(Color.white.opacity(0.1)))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(24)
            .background(Color.black)
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEvidenceSheet) { AddEvidenceSheet(task: task) }
        .sheet(isPresented: $showingAssistantSheet) { AssistantSheet(task: task) }
    }
    
    private func toggleTaskStatus() {
        if task.statusValue == "open" {
            task.statusValue = AuftragStatus.inProgress.rawValue
        } else {
            task.statusValue = AuftragStatus.completed.rawValue
        }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}