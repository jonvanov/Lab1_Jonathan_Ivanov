import SwiftUI
import Combine

struct ContentView: View {
    
    @State private var currentNumber = Int.random(in: 1...100)
    @State private var correctAnswers = 0
    @State private var wrongAnswers = 0
    @State private var totalAttempts = 0
    @State private var resultSymbol = ""
    @State private var showAlert = false
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Prime Number Checker")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("\(currentNumber)")
                .font(.system(size: 60, weight: .bold))
                .padding()
            
            Text(resultSymbol)
                .font(.system(size: 50))
            
            HStack(spacing: 20) {
                Button("Prime") {
                    checkAnswer(userSaysPrime: true)
                }
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                Button("Not Prime") {
                    checkAnswer(userSaysPrime: false)
                }
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal)
            
            VStack(spacing: 10) {
                Text("Correct Answers: \(correctAnswers)")
                    .font(.title3)
                Text("Wrong Answers: \(wrongAnswers)")
                    .font(.title3)
                Text("Attempts: \(totalAttempts)/10")
                    .font(.title3)
            }
            
            Spacer()
        }
        .padding()
        .onReceive(timer) { _ in
            timeRanOut()
        }
        .alert("Results After 10 Attempts", isPresented: $showAlert) {
            Button("Continue") {
                resetGame()
            }
        } message: {
            Text("Correct: \(correctAnswers)\nWrong: \(wrongAnswers)")
        }
    }
    
    func isPrime(_ number: Int) -> Bool {
        if number < 2 {
            return false
        }
        
        if number == 2 {
            return true
        }
        
        for i in 2..<number {
            if number % i == 0 {
                return false
            }
        }
        
        return true
    }
    
    func checkAnswer(userSaysPrime: Bool) {
        let actualAnswer = isPrime(currentNumber)
        
        if userSaysPrime == actualAnswer {
            correctAnswers += 1
            resultSymbol = "✓"
        } else {
            wrongAnswers += 1
            resultSymbol = "✗"
        }
        
        totalAttempts += 1
        nextRound()
    }
    
    func timeRanOut() {
        wrongAnswers += 1
        totalAttempts += 1
        resultSymbol = "✗"
        nextRound()
    }
    
    func nextRound() {
        if totalAttempts == 10 {
            showAlert = true
        } else {
            currentNumber = Int.random(in: 1...100)
        }
    }
    
    func resetGame() {
        correctAnswers = 0
        wrongAnswers = 0
        totalAttempts = 0
        resultSymbol = ""
        currentNumber = Int.random(in: 1...100)
    }
}

#Preview {
    ContentView()
}
