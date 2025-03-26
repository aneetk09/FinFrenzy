import SwiftUI

struct QuizView: View {
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String? = nil
    @State private var showPopup = false
    @State private var isCorrect = false
    @State private var score = 0
    @State private var hasAnswered = false
    @State private var quizCompleted = false
    

    let financialTips = [
        "Start saving early to take advantage of compound interest!",
        "Diversifying your investments can reduce your financial risk.",
        "Build an emergency fund that can cover 3-6 months of living expenses.",
        "Pay off high-interest debt first to save money in the long run.",
        "Invest in yourself—your skills and education are some of the best assets.",
        "Avoid impulse spending by sticking to a budget each month.",
        "Regularly check your credit score to ensure it’s healthy for future loans.",
        "Create a realistic budget and track your expenses every month."
    ]
    
    let questions: [(question: String, options: [String], correctAnswer: String, explanation: String)] = [
        ("What is a budget?", ["A spending plan", "A savings account", "A type of investment", "A loan"], "A spending plan", "A budget helps you manage your income and expenses."),
        ("What does APR stand for?", ["Annual Percentage Rate", "Applied Payment Ratio", "Actual Profit Rate", "Average Payment Rate"], "Annual Percentage Rate", "APR represents the cost of borrowing money annually."),
        ("Which of these is a liability?", ["A car loan", "A savings account", "Stocks", "A house owned outright"], "A car loan", "Liabilities are debts or financial obligations."),
        ("Emergency fund used for:", ["Vacation", "Unexpected expenses", "Buying stocks", "Gifting money"], "Unexpected expenses", "An emergency fund is set aside for unforeseen financial needs."),
        ("What is compound interest?", ["Interest on accumulated interest", "A fixed rate of return", "A tax on savings", "An investment strategy"], "Interest on accumulated interest", "Compound interest helps savings grow exponentially."),
        ("Purpose of credit score is:", ["To determine financial risk", "To measure income", "To track expenses", "To calculate taxes"], "To determine financial risk", "A credit score reflects creditworthiness for loans and credit cards."),
        ("What is a 401(k)?", ["A retirement savings plan", "A type of loan", "A tax deduction", "A stock market index"], "A retirement savings plan", "A 401(k) is a tax-advantaged retirement savings plan."),
        ("What is diversification?", ["Spread investments wisely", "Investing in one high-return stock", "Avoiding all risk", "Maximizing short-term gains"], "Spread investments wisely", "Diversification reduces risk by spreading investments."),
        ("Which is a fixed expense?", ["Rent", "Groceries", "Dining out", "Entertainment"], "Rent", "Fixed expenses remain constant each month, like rent or mortgage payments."),
        ("What is an overdraft fee?", ["Fee for overspending balance", "A reward for saving money", "A tax on banking", "A bonus for credit card use"], "Fee for overspending balance", "Banks charge overdraft fees when an account goes negative.")
    ]
    
    @State private var randomTip: String = ""

    var body: some View {
        ZStack {
            Image("bgf")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                if quizCompleted {
                    completionView()
                } else {
                    quizContent()
                }
            }
            .padding()
            .cornerRadius(20)
            .shadow(radius: 20)
            .navigationBarBackButtonHidden(false)
            .toolbar(.hidden, for: .tabBar)

            .overlay {
                if showPopup {
                    popupView()
                }
            }
            .onAppear {
                randomTip = financialTips.randomElement() ?? "Keep learning and improving your financial knowledge!"
            }
        }
    }

    func quizContent() -> some View {
        VStack {
            HStack {
                Spacer()
                Text("Quiz Time!")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Gold"))
                    .padding(.leading, 60)
                Spacer()
                Image(systemName: "trophy.fill")
                    .foregroundColor(Color("Gold"))
                Text("\(score)")
                    .foregroundColor(Color("Ivory"))
                    .font(.title)
                    .padding(.trailing, 10)
                
            }
            
            Text(questions[currentQuestionIndex].question)
                .font(.title)
                .foregroundColor(Color("Ivory"))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 30)
            
            VStack(spacing: 20) {
                ForEach(questions[currentQuestionIndex].options, id: \.self) { option in
                    Button(action: {
                        if !hasAnswered {
                            selectedAnswer = option
                        }
                    }) {
                        Text(option)
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedAnswer == option ? Color("Gold").opacity(0.6) : Color(.gray))
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .frame(minWidth: 200, maxWidth: .infinity)
                }
            }
            .padding(.top, 30)
            
            Button(action: {
                if let answer = selectedAnswer {
                    checkAnswer(answer)
                }
            }) {
                Text("Submit")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedAnswer != nil ? Color("Gold") : Color.gray)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding(.top, 50)
            }
            .padding(.horizontal, 80)
            .frame(minWidth: 200, maxWidth: .infinity)
            .disabled(selectedAnswer == nil)
            
            Spacer()
        }
    }

    func completionView() -> some View {
        VStack(spacing: 30) {
            Text("🎉Quiz Completed!🎉")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 70)
                .foregroundColor(Color("Gold"))
            
            Text("Your score: \(score)")
                .font(.title)
                .foregroundColor(Color("Ivory"))
                .padding(.top, 50)
            
            Text("💡 Financial Tip 💡")
                .font(.title)
                .foregroundColor(Color("Gold"))
                .padding(.top, 40)
            
            Text(randomTip)
                .font(.title3)
                .foregroundColor(Color("Ivory"))
                .italic()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .frame(minWidth: 200, maxWidth: .infinity)
            
            Button(action: { resetQuiz() }) {
                Text("Retry Quiz")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("Gold"))
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .padding(.top, 80)
            }
            .padding(.horizontal, 50)
            .frame(minWidth: 200, maxWidth: .infinity)
            
            Spacer()
        }
    }

    func popupView() -> some View {
        VStack(spacing: 20) {
            Text(isCorrect ? "Correct! 🎉" : "❗Incorrect❗")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            if !isCorrect {
                Text(questions[currentQuestionIndex].explanation)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
            
            Button("Next") {
                if currentQuestionIndex < questions.count - 1 {
                    currentQuestionIndex += 1
                } else {
                    quizCompleted = true
                    UserDefaults.standard.set(score, forKey: "quizPoints")
                }
                showPopup = false
                selectedAnswer = nil
                hasAnswered = false
            }
            .padding()
            .background(Color("Gold").opacity(0.7))
            .foregroundColor(.black)
            .cornerRadius(8)
            .padding(.horizontal, 30)
        }
        .padding(.horizontal, 80)
        .padding(.vertical, 30)
        .background(Color("Ivory").opacity(0.95))
        .cornerRadius(12)
        .shadow(radius: 10)
    }

    func checkAnswer(_ answer: String) {
        if !hasAnswered {
            if answer == questions[currentQuestionIndex].correctAnswer {
                score += 10
                isCorrect = true
            } else {
                isCorrect = false
            }
            hasAnswered = true
            showPopup = true
        }
    }

    func resetQuiz() {
        currentQuestionIndex = 0
        score = 0
        hasAnswered = false
        quizCompleted = false
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
