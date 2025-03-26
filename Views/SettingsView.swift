import SwiftUI
import UIKit

struct SettingsView: View {
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    @AppStorage("isNotificationOn") private var isNotificationOn: Bool = true
    
    @State private var showResetAlert = false

    var body: some View {
        ZStack {
            Image("bgf")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Gold"))
                    .padding(.top, 40)

                List {
                    Section(header: CustomHeader(title: "Preferences")) {
                        Toggle(isOn: $isNotificationOn) {
                            Label("Notifications", systemImage: "bell.and.waves.left.and.right")
                                .foregroundColor(.black)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: Color("Next")))
                        .listRowBackground(Color.white.opacity(0.7))

                        Toggle(isOn: $hapticsEnabled) {
                            Label("Haptic Feedback", systemImage: "iphone.radiowaves.left.and.right")
                                .foregroundColor(.black)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: Color("Next")))
                        .listRowBackground(Color.white.opacity(0.7))
                    }

                    // Account Section
                    Section(header: CustomHeader(title: "Account")) {
                        Button(action: {
                            showResetAlert = true
                            triggerHapticFeedback()
                        }) {
                            Label("Reset Progress", systemImage:"arrow.triangle.2.circlepath")
                                .foregroundColor(.red)
                        }
                        .listRowBackground(Color.white.opacity(0.7))
                    }

                    // About Section
                    Section(header: CustomHeader(title: "About")) {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0")
                                .foregroundColor(.black).opacity(0.8)
                        }
                        .listRowBackground(Color.white.opacity(0.7))

                        HStack {
                            Text("Developed by")
                            Spacer()
                            Text("FinFrenzy Team")
                                .foregroundColor(.black).opacity(0.8)
                        }
                        .listRowBackground(Color.white.opacity(0.7))
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .scrollContentBackground(.hidden)

                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)
        }
        .alert(isPresented: $showResetAlert) {
            Alert(
                title: Text("Reset Progress?"),
                message: Text("This will erase all your achievements and levels. Are you sure?"),
                primaryButton: .destructive(Text("Reset")) {
                    resetProgress()
                },
                secondaryButton: .cancel()
            )
        }
        .environment(\.colorScheme, .light)
    }

    func resetProgress() {
        
        UserDefaults.standard.removeObject(forKey: "quizPoints")
        UserDefaults.standard.removeObject(forKey: "level")
        UserDefaults.standard.removeObject(forKey: "achievements")
        UserDefaults.standard.removeObject(forKey: "streak")

        
        hapticsEnabled = true
        isNotificationOn = true

        print("Progress reset triggered")
    }

    func triggerHapticFeedback() {
        if hapticsEnabled {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
        }
    }
}

struct CustomHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title3)
            .foregroundColor(Color("Ivory"))
            .padding(.top, 5)
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}
