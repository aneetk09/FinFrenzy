import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack{
            VStack(spacing: 18) {
                // App Title
                Text("Welcome to")
                    .font(.system(size: 34, weight: .medium))
                    .foregroundColor(Color("Ivory"))
                    .padding(.top, 70)
                
                HStack(spacing: 0){
                    Text("Fin")
                        .font(.system(size: 55, weight: .bold))
                        .foregroundColor(Color("Ivory"))
                        .multilineTextAlignment(.center)
                    Text("Frenzy")
                        .font(.system(size: 55, weight: .bold))
                        .foregroundColor(Color("Gold"))
                        .multilineTextAlignment(.center)
                }
                
                // "Did You Know?" Section
                VStack {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(Color("Gold"))
                            .font(.title2)
                        
                        Text("Did you know?")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white).opacity(0.85)
                    }
                    .padding(.bottom, 5)
                    
                    Text("“A budget is more than numbers, it's an expression of our values.”\n— Barack Obama")
                        .font(.callout)
                        .italic()
                        .foregroundColor(Color("Ivory"))
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.44)))
                        .padding(.horizontal, 30)
                }
                .padding(.top, 30)
                
                // Game Buttons
                HStack(spacing: 80) {
                    GameOptionView(imageName: "f2", destination: QuizView())
                    GameOptionView(imageName: "f3", destination: BudgetGameView())
                }
                .padding(.top, 60)
                
                HStack(spacing: 20) {
                    NavigationLink(destination: QuizView()) {
                        Image("t1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.top, -20)
                    }
                    
                    NavigationLink(destination: BudgetGameView()) {
                        Image("t2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.top, -20)
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(
                Image("bgf")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            )
            .onAppear {
                DispatchQueue.main.async {
                    UITabBar.appearance().isHidden = false 
                }
            }
            
        }
    }
    
    struct GameOptionView<Destination: View>: View {
        let imageName: String
        let destination: Destination
        @State private var isHovered = false
        
        var body: some View {
            NavigationLink(destination: destination) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color("Gold").opacity(0.2), radius: 10, x: 0, y: 5)
                    .scaleEffect(isHovered ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isHovered)
                    .onHover { hovering in
                        isHovered = hovering
                    }
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isHovered = true }
                    .onEnded { _ in isHovered = false }
            )
        }
    }
    
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                HomeView()
            }
        }
    }
}
