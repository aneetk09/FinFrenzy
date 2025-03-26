import SwiftUI

struct MilestonesView: View {
    @State private var level: Int = 1
    @State private var progress: Double = 0.3
    @State private var achievements: [Achievement] = [
        Achievement(title: "First Step", tier: .bronze, description: "Complete your first challenge!", unlocked: true),
        Achievement(title: "Budget Master", tier: .silver, description: "Save $500 in the budgeting game.", unlocked: false),
        Achievement(title: "Financial Guru", tier: .gold, description: "Reach Level 10.", unlocked: false)
    ]
    
    @State private var showMilestonePopup = false
    @State private var selectedMilestone: Achievement?

    var body: some View {
        ZStack {
            // Background
            Image("bgf")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Text("Milestones")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Gold"))
                    .padding(.top, 40)

                // Level Display
                VStack {
                    Text("Level \(level)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color("Gold")))
                        .frame(width: 250)
                        .padding(.top, 5)
                    
                    Text("\(Int(progress * 100))% to next level")
                        .foregroundColor(Color("Ivory"))
                        .font(.subheadline)
                }
                .padding()
                .background(Color.gray.opacity(0.44))
                .cornerRadius(15)

                // Achievements List
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(achievements) { achievement in
                            AchievementRow(achievement: achievement)
                                .onTapGesture {
                                    if achievement.unlocked {
                                        selectedMilestone = achievement
                                        showMilestonePopup = true
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                Spacer()
            }
            .blur(radius: showMilestonePopup ? 5 : 0) // Blur when popup is active

            // Milestone Details Popup
            if showMilestonePopup, let milestone = selectedMilestone {
                MilestonePopup(milestone: milestone) {
                    showMilestonePopup = false
                }
            }
        }
    }
}

// Struct for Achievements
struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let tier: Tier
    let description: String
    let unlocked: Bool
}

// Tier Levels
enum Tier {
    case bronze, silver, gold

    var color: Color {
        switch self {
        case .bronze: return .brown
        case .silver: return .gray
        case .gold: return .yellow
        }
    }

    var icon: String {
        switch self {
        case .bronze: return "medal"
        case .silver: return "star.fill"
        case .gold: return "trophy.fill"
        }
    }
}

// Achievement Row
struct AchievementRow: View {
    let achievement: Achievement
    
    var body: some View {
        HStack {
            Image(systemName: achievement.tier.icon)
                .foregroundColor(achievement.unlocked ? achievement.tier.color : .gray)
                .font(.title2)

            VStack(alignment: .leading) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            if achievement.unlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title2)
            } else {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
                    .font(.title2)
            }
        }
        .padding()
        .padding(.horizontal, 8)
        .background(Color.gray.opacity(0.44))
        .cornerRadius(12)
    }
}

// Milestone Popup
struct MilestonePopup: View {
    let milestone: Achievement
    var onDismiss: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: milestone.tier.icon)
                .font(.largeTitle)
                .foregroundColor(milestone.tier.color)
                .padding()

            Text(milestone.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(milestone.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding()

            Button("Close") {
                onDismiss()
            }
            .font(.headline)
            .padding()
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

struct MilestonesView_Previews: PreviewProvider {
    static var previews: some View {
        MilestonesView()
    }
}
