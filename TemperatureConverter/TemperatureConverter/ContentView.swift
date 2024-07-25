//
//  ContentView.swift
//  TemperatureConverter
//
//  Created by Lukas Esch on 26.06.24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var metrics: [String] = ["Celsius", "Fahrenheit", "Kelvin"]
    @State private var inputMetric: String = "Celsius"
    @State private var outputMetric: String = "Fahrenheit"
    @State private var input: Double = 20
    @FocusState private var textFieldFocus: Bool
    
    var output: Double {
        if inputMetric == "Celsius" && outputMetric == "Fahrenheit"{
            return (input * 1.8) + 32
        } else if inputMetric == "Celsius" && outputMetric == "Celsius" {
            return input
        } else if inputMetric == "Celsius" && outputMetric == "Kelvin" {
            return input + 273.15
        } else if inputMetric == "Fahrenheit" && outputMetric == "Celsius" {
            return (input - 32) / 1.8
        } else if inputMetric == "Fahrenheit" && outputMetric == "Fahrenheit" {
            return input
        } else if inputMetric == "Fahrenheit" && outputMetric == "Kelvin" {
            return (input - 32) * 5 / 9 + 273.15
        } else if inputMetric == "Kelvin" && outputMetric == "Celsius" {
            return input - 273.15
        } else if inputMetric == "Kelvin" && outputMetric == "Kelvin" {
            return input
        } else if inputMetric == "Kelvin" && outputMetric == "Fahrenheit" {
            return (input - 273.15) * 1.8 + 32
        } else {
            return 0;
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Input number:"){
                    TextField("Input Number", value: $input, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($textFieldFocus)
                    Picker("Metric", selection: $inputMetric) {
                        ForEach(metrics, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section("Output number:"){
                    Text((output * 100).rounded() / 100, format: .number)
                    Picker("Metric", selection: $outputMetric) {
                        ForEach(metrics, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Temperature Converter")
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
