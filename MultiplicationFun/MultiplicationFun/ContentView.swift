//
//  ContentView.swift
//  MultiplicationFun
//
//  Created by Lukas Esch on 26.07.24.
//

import SwiftUI

struct Questions {
    var question: String
    var answer: Int
}

struct ContentView: View {
    
    @State private var question = ""
    @State private var settingsScreen = true
    @State private var selectedQuestionNumber = 5
    @State private var selectedTableNumber = 10
    @State private var QuestionsArray: [Questions] = []
    let numberOfQuestions = [5, 10, 20]
    
    var body: some View {
        
        //SETTINGS MENU
        
        if settingsScreen {
            NavigationView {
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
                    Button(action: {startGame()}, label: {
                        Text("Play!")
                    })
                }
                .navigationTitle("Multiplication Fun")
                
                
    
            }
            
            
        //ACTUAL GAME
            
        } else {
            VStack {
                Button(action: {resetGame()}, label: {
                    Text("Reset Game!")
                })
                .buttonStyle(.borderedProminent)
                Text("Hello, Lukas!")
            }
            .padding()
        }
    }
    
    func startGame() {
        generateQuestions()
        withAnimation() {
            settingsScreen.toggle()
        }
    }
    
    func resetGame() {
        selectedQuestionNumber = 5
        selectedTableNumber = 10
        QuestionsArray.removeAll()
        withAnimation() {
            settingsScreen.toggle()
        }
    }
    
    func generateQuestions() {
        for i in 1 ... selectedQuestionNumber {
            var number1 = Int.random(in: 1...selectedTableNumber)
            var number2 = Int.random(in: 1...selectedTableNumber)
            var result = number1 * number2
            let question = Questions(question:"What is \(number1) * \(number2)?", answer: result)
            QuestionsArray.append(question)
        }
    }
}

#Preview {
    ContentView()
}
