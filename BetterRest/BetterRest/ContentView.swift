//
//  ContentView.swift
//  BetterRest
//
//  Created by Lukas Esch on 06.07.24.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var sleepHours = 8.0
    @State private var wakeUpTime = defaultWakeUpTime
    @State private var coffeeCups = 1
    
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    private var bedtime: String {
        var sleepTime = Date.now
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepHours, coffee: Double(coffeeCups))
            
            sleepTime = wakeUpTime - prediction.actualSleep
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
            
        } catch {
            alertMessage = "Something went wrong trying to calculate your estimated sleep time. Please try again."
        }
        return sleepTime.formatted(date: .omitted, time: .shortened)
    }
    
    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section ("Input Data:"){
                    VStack (alignment: .leading) {
                        Text("When do you want to wake up?")
                            .font(.headline)
                        DatePicker("Wake up time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    
                    VStack (alignment: .leading) {
                        Text("Desired amount of sleep")
                            .font(.headline)
                        Stepper("\(sleepHours.formatted()) hours", value: $sleepHours, in: 4...12, step: 0.25)
                    }
                    
                    VStack (alignment: .leading) {
                        Text("Cups of coffee")
                            .font(.headline)
                        Stepper("\(coffeeCups) \(coffeeCups == 1 ? "cup" : "cups")", value: $coffeeCups, in: 1...20, step: 1)
                    }
                }
                Section ("Estimated Sleep Time:"){
                    Text("You should go to bed at \(bedtime)")
                        .font(.headline)
                }
            }
            .navigationTitle("Better Rest")
        }
        
    }

}

#Preview {
    ContentView()
}
