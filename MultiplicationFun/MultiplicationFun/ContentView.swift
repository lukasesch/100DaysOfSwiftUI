//
//  ContentView.swift
//  MultiplicationFun
//
//  Created by Lukas Esch on 26.07.24.
//

// TODO: You won Popup or screen
//
// Longterm
// TODO: Premade 3 Choice Answers as Button, they flip green / red if right / wrong answer


import SwiftUI

struct Questions {
    var question: String
    var popUpQuestion: String
    var answer: Int
}

struct ContentView: View {
    
    @State private var question = ""
    @State private var settingsScreen = true
    @State private var selectedQuestionNumber = 5
    @State private var selectedTableNumber = 10
    @State private var questionsArray: [Questions] = []
    @State private var questionNumber = 0
    @State private var userAnswer = ""
    @State private var userScore = 0;
    @State private var showingAlert = false
    @State private var alertHeader = ""
    @State private var alertMessage = ""
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
            NavigationView {
                Form {
                    Section {
                        Text("\(questionsArray[questionNumber].question)")
                        TextField("Answer:", text: $userAnswer)
                            .keyboardType(.decimalPad)
                            .onSubmit {
                                submit(answer: userAnswer)
                            }
                        
                        
                    }
                    Section {
                        Button(action: {submit(answer: userAnswer)}, label: {
                            Text("Submit")
                        })
                    }
                    Section {
                        Button(role: .destructive, action: {resetGame()}, label: {
                            Text("Reset Game!")
                        })
                        
                    }
                }
                .navigationTitle("Round: \(questionNumber+1)  -  Points: \(userScore)")
            }
            .alert(alertHeader, isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("\(alertMessage)")
            }
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
        withAnimation() {
            settingsScreen.toggle()
        }
        questionsArray.removeAll()
    }
    
    func submit(answer: String) {
        if let userAnswer = Int(answer), userAnswer == questionsArray[questionNumber].answer {
            userScore += 1
            alertHeader = "Correct answer!"
            alertMessage = "\(questionsArray[questionNumber].popUpQuestion) is indeed \(answer)! Great job!"
            showingAlert = true;
        } else {
            alertHeader = "Wrong answer!"
            alertMessage = "\(questionsArray[questionNumber].popUpQuestion) is actually \(questionsArray[questionNumber].answer)! Maybe next time!"
            showingAlert = true;
        }
        
        nextQuestion()
    }
    
    func nextQuestion() {
        userAnswer = ""
        if (questionNumber < questionsArray.count-1) {
            questionNumber += 1
        } else {
            alertHeader = "Game done!"
            alertMessage = "The Game is over."
            showingAlert = true;
        }
        
    }
    
    func generateQuestions() {
        for _ in 1 ... selectedQuestionNumber {
            let number1 = Int.random(in: 1...selectedTableNumber)
            let number2 = Int.random(in: 1...selectedTableNumber)
            let result = number1 * number2
            let question = Questions(question:"What is \(number1) * \(number2)?", popUpQuestion:"\(number1) * \(number2)", answer: result)
            questionsArray.append(question)
        }
    }
}

#Preview {
    ContentView()
}
