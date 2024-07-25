//
//  ContentView.swift
//  WordScramble
//
//  Created by Lukas Esch on 08.07.24.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showError = false
    
    @State private var userScore = 0
    
    @FocusState private var textFieldFocus: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        TextField("Enter your word:", text: $newWord)
                            .textInputAutocapitalization(.never)
                            .focused($textFieldFocus)
                    }
                    
                    Section {
                        ForEach(usedWords, id: \.self) { word in
                            HStack {
                                Image(systemName: "\(word.count).circle")
                                Text(word)
                            }
                        }
                    }
                }
                .navigationTitle(rootWord)
                .onSubmit(addNewWord)
                .onAppear(perform: startGame)
                .alert(errorTitle, isPresented: $showError) {
                    Button("Ok") {}
                } message: {
                    Text(errorMessage)
                }
                .toolbar {
                    if textFieldFocus {
                        Button("Done") {
                            textFieldFocus = false
                        }
                    } else {
                        Button("Restart", role: .destructive) {
                            usedWords.removeAll()
                            newWord = ""
                            userScore = 0
                            startGame()
                        }
                        .foregroundColor(.red)
                    }
                }
                
                
            }
            VStack {
                Text("Your score is:")
                    .font(.title3)
                Text(userScore.formatted())
                    .font(.title)
                    .fontWeight(.bold)
            }
            HStack {
                Button("Submit word") {
                    addNewWord()
                }
                .buttonStyle(.borderedProminent)
                Button("Get new word") {
                    usedWords.removeAll()
                    newWord = ""
                    
                    startGame()
                }
                .buttonStyle(.borderedProminent)
                .padding()
//                Button("Restart", role: .destructive) {
//                    usedWords.removeAll()
//                    newWord = ""
//                    userScore = 0
//                    startGame()
//                }
//                .buttonStyle(.borderedProminent)
//                .padding()
                
            }
            
            

        }
        
        
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Error: Could not load start.txt from bundle!")
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already!", message: "Please be more original!")
            return
        }
        
        guard shorterThanThree(word: answer) else {
            wordError(title: "Word length!", message: "Your word is shorter than 3 characters.")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible!", message: "You can't spell this word from \(rootWord)!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized!", message: "You can't make up random words!")
            return
        }
        
        userScore += calculatePoints(word: answer)
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        
        newWord = ""
    }
    
    func isOriginal(word: String) -> Bool {
        !(rootWord==word) && !usedWords.contains(word)
    }
    
    func shorterThanThree(word: String) -> Bool {
        word.count > 2
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word:String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title:String, message:String) {
        errorTitle = title
        errorMessage = message
        showError = true
    }
    
    func calculatePoints(word:String) -> Int {
        return word.count
    }
}

#Preview {
    ContentView()
}
