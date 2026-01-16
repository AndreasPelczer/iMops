//
//  AddEvidenceSheet.swift
//  IMops
//
//  Created by Andreas Pelczer on 16.01.26.
//


import SwiftUI
import SwiftData

struct AddEvidenceSheet: View {
    @Bindable var task: Task
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.self) private var router
    
    @State private var selectedKind: EvidenceKind = .note
    @State private var payload: String = ""
    @State private var measurementValue: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Auswahl der Art des Nachweises
                Picker("Art", selection: $selectedKind) {
                    Label("Notiz", systemImage: "pencil.line").tag(EvidenceKind.note)
                    Label("Messwert", systemImage: "thermometer.medium").tag(EvidenceKind.measurement)
                    Label("Foto", systemImage: "camera").tag(EvidenceKind.photo)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Eingabebereich je nach Typ
                VStack(alignment: .leading, spacing: 10) {
                    Text(selectedKind == .measurement ? "MESSWERT (°C / kg / %)" : "BESCHREIBUNG")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                    
                    if selectedKind == .measurement {
                        TextField("Zahl eingeben", text: $measurementValue)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 40, weight: .bold, design: .monospaced))
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color(white: 0.1))
                            .cornerRadius(12)
                    } else if selectedKind == .note {
                        TextEditor(text: $payload)
                            .frame(minHeight: 150)
                            .padding(8)
                            .background(Color(white: 0.1))
                            .cornerRadius(12)
                            .overlay(
                                Text(payload.isEmpty ? "Was ist passiert? (z.B. Bräunung erreicht, Ware geprüft)" : "")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 16)
                                    .allowsHitTesting(false),
                                alignment: .topLeading
                            )
                    } else {
                        // Foto Placeholder für MVP
                        VStack(spacing: 12) {
                            Image(systemName: "camera.viewfinder")
                                .font(.system(size: 60))
                            Text("Kamera-Modul wird geladen...")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity, minHeight: 150)
                        .background(Color(white: 0.1))
                        .cornerRadius(12)
                        .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: saveEvidence) {
                    Text("BEWEIS SICHERN")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }
                .padding()
                .disabled(selectedKind == .note && payload.isEmpty)
                .disabled(selectedKind == .measurement && measurementValue.isEmpty)
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("NACHWEIS")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func saveEvidence() {
        // Wir holen den aktiven Mitarbeiter-Namen aus dem Router/Context
        let authorName = "Brigade Member" // MVP-Vereinfachung
        
        let finalPayload = selectedKind == .measurement ? measurementValue : payload
        
        let newEvidence = EvidenceEntry(
            kindValue: selectedKind.rawValue,
            payload: finalPayload,
            author: authorName
        )
        
        task.evidences.append(newEvidence)
        
        // Haptisches Feedback für "Gespeichert"
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        dismiss()
    }
}