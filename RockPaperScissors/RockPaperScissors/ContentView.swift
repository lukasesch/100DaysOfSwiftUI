//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Lukas Esch on 05.07.24.
//

import SwiftUI

struct ContentView: View {
    
    private let options = ["octagon", "paperplane", "scissors"]
    @State var choosenOption = Int.random(in: 0...2)
    @State var shouldWin = Bool.random()
    @State var score = 0
    @State var currentRound = 0;
    @State private var showResult = false
    
    
    var body: some View {
        ZStack {

            VStack {
                VStack {
                    
                    Text("Rock, Paper, Scissor!")
                        .font(.largeTitle.bold())
                
                }
                VStack (spacing: 20){
                    Spacer()
                    Text("\(shouldWin ? "Win" : "Loose") against")
                        .font(.title.bold())
                    Image(systemName: "\(options[choosenOption])")
                        .font(.system(size: 80))
                    Spacer()
                    
                    
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding()
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                VStack {
                    Spacer()
                    Spacer()
                    ForEach(0..<3) { number in
                        Button {
                            battle(number, shouldWin: shouldWin)
                        } label: {
                            Image(systemName: "\(options[number])")
                                .font(.system(size: 30))
                            //Text(options[number])
                        }
                        .foregroundStyle(.primary)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    }
                }
                VStack {
                    Spacer()
                    Divider()
                    Spacer()
                    Text("Current Score: \(score)")
                        .font(.title)
                    Text("Round: \(currentRound)")
                        .font(.title2)
                    Spacer()
                }
                
            }
            .padding()
        }
        .alert("End Result", isPresented: $showResult) {
            Button("Play again", action: resetGame)
        } message: {
            Text("Your final score is \(score)!")
        }
        
    }
    
    func battle(_ number: Int, shouldWin: Bool) {
        if shouldWin {
            if choosenOption == 0 {
                if number == 1 {
                    score += 1
                    nextRound()
                } else {
                    nextRound()
                }
            } else if choosenOption == 1 {
                if number == 2 {
                    score += 1
                    nextRound()
                } else {
                    nextRound()
                }
            } else {
                if number == 0 {
                    score += 1
                    nextRound()
                } else {
                    nextRound()
                }
            }
        } else {
            if choosenOption == 0 {
                if number == 1 {
                    nextRound()
                } else {
                    score += 1
                    nextRound()
                }
            } else if choosenOption == 1 {
                if number == 2 {
                    nextRound()
                } else {
                    score += 1
                    nextRound()
                }
            } else {
                if number == 0 {
                    nextRound()
                } else {
                    score += 1
                    nextRound()
                }
            }
        }
    }
    func nextRound() {
        if currentRound == 10 {
            showResult = true
            return
        }
        currentRound += 1
        shouldWin = Bool.random()
        choosenOption = Int.random(in: 0...2)
    }
    
    func resetGame() {
        shouldWin = Bool.random()
        choosenOption = Int.random(in: 0...2)
        currentRound = 0
        score = 0
    }
}

#Preview {
    ContentView()
}
