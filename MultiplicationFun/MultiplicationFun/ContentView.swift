//
//  ContentView.swift
//  MultiplicationFun
//
//  Created by Lukas Esch on 26.07.24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var question = ""
    @State private var settingsScreen = true
    @State private var selectedQuestionNumber = 5
    @State private var selectedTableNumber = 10
    let numberOfQuestions = [5, 10, 20]
    
    var body: some View {
        
        //SETTINGS MENU
        
        if settingsScreen {
            VStack {
                Text("Multiplication Fun")
                    .font(.largeTitle)
                Form {
                    Section {
                        Text("Maximum number of table?")
                            .fontWeight(.bold)
                        Stepper(value: $selectedTableNumber, in: 2...12, step: 1) {
                            Text("Up to \(selectedTableNumber)")
                        }
                    }
                    Section {
                        Text("How many questions do you want?")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Picker("Select a number", selection: $selectedQuestionNumber) {
                            ForEach(numberOfQuestions, id: \.self) {
                                Text("\($0)")
                            }
                        }
                    }
                }
                Button(action: {startGame()}, label: {
                    Text("Play!")
                })
                .buttonStyle(.borderedProminent)
    
            }
            .padding()
            
        //ACTUAL GAME 
            
        } else {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, Lukas!")
            }
            .padding()
        }
    }
    
    func startGame() {
        withAnimation() {
            settingsScreen.toggle()
        }
        
    }
}

#Preview {
    ContentView()
}
