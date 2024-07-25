//
//  ContentView.swift
//  WeSplit
//
//  Created by Lukas Esch on 24.06.24.
//

import SwiftUI

struct ContentView: View {
    @State private var amount: Double = 0
    @State private var numberOfPeople = 2
    @State private var tipPercentage: [Double] = [0.10, 0.15, 0.20, 0.25, 0]
    @State private var selectedTipPercentage: Double = 0.00
    @FocusState private var textFieldFocus: Bool
    
    var finalBill: Double {
        return (amount + (amount * selectedTipPercentage)) / (Double)(numberOfPeople + 2)
    }
    
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section ("Total Bill"){
                    TextField("Total Bill:", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($textFieldFocus)
                }
                Section ("Number of People"){
                    Picker("Number of People:", selection: $numberOfPeople) {
                        ForEach(2..<50) {
                            Text("\($0) people")
                        }
                    }
                }
                Section ("Tip Percentage:"){
                    Picker("Tip Percentage", selection: $selectedTipPercentage) {
                        ForEach(tipPercentage, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section ("Final bill per person:") {
                    Text(finalBill, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .fontWeight(.semibold)
                        .foregroundStyle(selectedTipPercentage == 0.00 ? .red : .black)
                }
            }
            .navigationTitle("We Split")
            .toolbar {
                if textFieldFocus {
                    Button("Done") {
                        textFieldFocus = false
                    }
                }
            }
        
        }
    }
}


#Preview {
    ContentView()
}
