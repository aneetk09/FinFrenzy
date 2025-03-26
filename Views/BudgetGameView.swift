import SwiftUI

struct BudgetGameView: View {
    @State private var income: Double = 1000
    @State private var rent: Double = 0
    @State private var food: Double = 0
    @State private var savings: Double = 0
    @State private var entertainment: Double = 0
    @State private var miscellaneous: Double = 0
    @State private var showPopup = false
    @State private var quizPoints: Double = 0
    
    var totalIncome: Double { income + quizPoints }
    var totalAllocated: Double { rent + food + savings + entertainment + miscellaneous }
    
    var needsAllocated: Double { rent + food }
    var wantsAllocated: Double { entertainment + miscellaneous }
    var savingsAllocated: Double { savings }
    
    var needsTarget: Double { totalIncome * 0.50 }
    var wantsTarget: Double { totalIncome * 0.30 }
    var savingsTarget: Double { totalIncome * 0.20 }
    
    var isBalanced: Bool {
        abs(needsAllocated - needsTarget) < 20 &&
        abs(wantsAllocated - wantsTarget) < 20 &&
        abs(savingsAllocated - savingsTarget) < 20 &&
        totalAllocated == totalIncome
    }
    
    var progressBarColor: Color {
        isBalanced ? Color("Next") : .white
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("bgf")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    Text("Budget Allocation")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color("Gold"))
                        .multilineTextAlignment(.center)
                    
                    Text("Distribute your income wisely!")
                        .font(.system(size: 18))
                        .foregroundColor(Color("Ivory"))
                        .multilineTextAlignment(.center)
                    
                    Text("Income: $\(Int(income)) (+$\(Int(quizPoints)) from quiz)")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("Gold"))
                    
                    ProgressView(value: totalAllocated, total: totalIncome)
                        .progressViewStyle(LinearProgressViewStyle())
                        .scaleEffect(y: 2)
                        .frame(width: min(geometry.size.width * 0.85, 400))
                        .accentColor(progressBarColor)
                    
                    VStack(spacing: 12) {
                        BudgetSlider(category: "🏠 Rent", amount: $rent, maxBudget: totalIncome, target: needsTarget / 2)
                        BudgetSlider(category: "🌯 Food", amount: $food, maxBudget: totalIncome, target: needsTarget / 2)
                        BudgetSlider(category: "💰 Savings", amount: $savings, maxBudget: totalIncome, target: savingsTarget)
                        BudgetSlider(category: "🎭 Entertainment", amount: $entertainment, maxBudget: totalIncome, target: wantsTarget / 2)
                        BudgetSlider(category: "📦 Miscellaneous", amount: $miscellaneous, maxBudget: totalIncome, target: wantsTarget / 2)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.44))
                    .cornerRadius(10)
                    .frame(maxWidth: min(geometry.size.width * 0.9, 500))
                    
                    Text("Total Allocated: $\(Int(totalAllocated)) / \(Int(totalIncome))")
                        .font(.system(size: 23))
                        .foregroundColor(progressBarColor)
                        .padding()
                        .background(Color.gray.opacity(0.54).cornerRadius(12))
                    
                    Button("Submit") {
                        provideHapticFeedback()
                        showPopup = true
                    }
                    .font(.headline)
                    .padding()
                    .frame(width: 150)
                    .background(Color("Gold"))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .padding()
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .navigationBarBackButtonHidden(false)
                                .toolbar(.hidden, for: .tabBar)
                
                if showPopup {
                    PopupView(isPresented: $showPopup, isBalanced: isBalanced)
                }
            }
            .onAppear {
                loadQuizPoints()
            }
        }
    }
    
    func loadQuizPoints() {
        quizPoints = UserDefaults.standard.double(forKey: "quizPoints")
    }
    
    func provideHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(isBalanced ? .success : .error)
    }
}

struct BudgetSlider: View {
    var category: String
    @Binding var amount: Double
    var maxBudget: Double
    var target: Double
    
    var sliderColor: Color {
        abs(amount - target) < 20 ? Color("Gold") : .white
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(category): $\(Int(amount)) (Target: $\(Int(target)))")
                .font(.headline)
                .foregroundColor(sliderColor)
            
            Slider(value: $amount, in: 0...maxBudget, step: 10)
                .accentColor(sliderColor)
        }
    }
}

struct PopupView: View {
    @Binding var isPresented: Bool
    var isBalanced: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    Text(isBalanced ? "Perfect Budget!" : "Adjust Your Budget")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(isBalanced ? "Your budget follows the 50/30/20 rule!" : "Try adjusting your expenses to match the 50/30/20 rule.")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("OK") {
                        isPresented = false
                    }
                    .font(.headline)
                    .padding()
                    .frame(width: 100)
                    .background(Color("Gold"))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                .padding()
                .frame(width: min(geometry.size.width * 0.8, 400))
                .background(Color("Ivory"))
                .cornerRadius(15)
                .shadow(radius: 10)
            }
        }
    }
}

struct BudgetGameView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetGameView()
    }
}
