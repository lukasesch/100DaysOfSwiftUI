//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Lukas Esch on 01.07.24.
//

import SwiftUI

struct FlagImage: View {
    var countries: [String]
    var flagNumber: Int
    
    var body: some View {
        Image(countries[flagNumber])
            .clipShape(.rect(cornerRadius: 10))
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showAnswer = false
    @State private var scoreTitle = ""
    @State private var score = 0;
    @State private var animationAmount = 0.0
    @State private var selectedButton: Int?
    @State private var buttonOpacity = 1.0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [.init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                                   .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)],
                           center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.white)
                VStack(spacing: 15) {
                    VStack {
                        
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    VStack(spacing: 15){
                        ForEach(0..<3) { number in
                            Button {
                                
                                withAnimation {
                                    selectedButton = number
                                    animationAmount += 360
                                    buttonOpacity = 0.5
                                }
                                flagTapped(number)
                                
                              
                            } label: {
                                FlagImage(countries: countries, flagNumber: number)
                                //Image(countries[number])
                                //.clipShape(.rect(cornerRadius: 10))
                                //.shadow(radius: 5)
                            }
                            .rotation3DEffect(.degrees(number == selectedButton ? animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                            .opacity(number == selectedButton ? 1 : buttonOpacity)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(Color.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showAnswer) {
            Button("Continue", action: {
                askQuestion()
                withAnimation {
                    buttonOpacity = 1.0
                }
            })
        } message: {
            Text("Your score is \(score) points!")
        }
    
    }
    
    func flagTapped(_ number: Int) {
        
        if number==correctAnswer {
            scoreTitle="Correct!"
            score += 1
        } else {
            scoreTitle="Wrong!"
        }
        showAnswer = true
        //askQuestion()
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        animationAmount = 0
    }
}

#Preview {
    ContentView()
}
