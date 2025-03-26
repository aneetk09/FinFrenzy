import SwiftUI
import AVFoundation

@MainActor

struct ContentView: View {
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "Ivory")
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")

    }
    
    var body: some View {
        TabView {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            NavigationView {
                MilestonesView()
            }
            .tabItem {
                Image(systemName: "rosette")
                Text("Milestones")
            }
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "wrench.and.screwdriver")
                Text("Settings")
            }
        }
        .tint(Color("Gold"))
    }
}
