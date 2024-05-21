//
//  OnboardingView.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 21/05/24.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingShowing : Bool
    @State var currentTab = 0
    @State private var animationAmount = 1.0
    
    var body: some View {
        NavigationStack{
            TabView(selection: $currentTab,
                    content: {
                // 1 VIEW
                VStack{
                    Spacer()
                    
                    HStack{
                        Spacer()
                        Text("Welcome to Magical Garden AR-Experience")
                            .padding()
                            .font(.system(.title, design: .serif))
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                    Image("MetallicPlants")
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .cornerRadius(50)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .padding()
                    
                                    
        
                        ZStack{

                            VStack (alignment: .leading){
                                Text("Concept")
                                    .font(.system(.title, design: .serif))
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding()
                                 
                                    
                                Text("Magical Garden is an enchanting augmented reality app that allows users to cultivate a garden of mystical metallic plants on their Apple devices.\n\nThis app combines the wonder of magic with the personal touch of gardening, where each interaction not only contributes to the growth of vibrant, animated plants but also unlocks whimsical effects that enhance the user's environment.")
                                    .padding(.horizontal,20)
                                    .font(.system(.title3,weight: .light))
                                    .foregroundColor(.white)
                                
                            }
                        }
                    Spacer()
                    
                }
                .tag(0)
                .opacity(currentTab == 0 ? 1 : 0)
                .animation(.easeInOut)
                
                
                // 2 VIEW
                createPage(title: "1. Getting Started", description: "*Choose Your Plant*: You will have access to three buttons, each representing a unique type of magical plant. Tap any button to enter the placing mode for that specific plant.", imageName: "Buttons", currentTab: $currentTab, tabIndex: 1)
                
                // 3 View
                
                createPage(title: "Placing Mode", description: "In placing mode, a square will appear to help you find a flat surface to place your plant.\n\nIf the square is complete, it means you can place the plant there.\n\nIf the square is incomplete, you'll need to find a flatter surface.", imageName: "Square", currentTab: $currentTab, tabIndex: 2)
                
                // 4 View
                createPage(title: "Growing Your Plant", description: "Start the Timer: Once you place your plant, a timer will start. You need to wait for the plant to be ready to grow. You can check the progress around each plant.", imageName: "Progress", currentTab: $currentTab, tabIndex: 3)
                
                // 5 View
                
                createPage(title: "Attend Your Plant", description: "When the timer finishes, the plant will call you. It will keep calling until you tap it, signaling your attention, and making it grow.", imageName: "Plant", currentTab: $currentTab, tabIndex: 4, optionalText: "If you manage to grow all three plants, be prepared for an amazing surprise!")
                
                // 6 View
                
                createPage(title: "Saving Your Progress", description: "Save Your Garden: You can save your garden at any time by pressing the save button in the top right corner. It's crucial to save your garden before closing the app to avoid losing your progress.", imageName: "Save", currentTab: $currentTab, tabIndex: 5, optionalText: "Loading Your Garden: Remember, your saved garden is linked to the specific scene in the real world where you created it. To load your garden, you'll need to be in the same location.")
                
                // 7 View
                
                VStack {
                    Spacer()
                    ZStack {
                        VStack(alignment: .leading) {
                            Text("Resetting Your Garden")
                                .font(.system(.title, design: .serif))
                                .foregroundStyle(.white)
                                .padding()
                            
                            Text("If you want to start fresh, you can reset your garden by tapping the button at the top left of the screen.")
                                .padding()
                                .foregroundStyle(.white)
                                .font(.system(.title3, weight: .light))
                        }
                        .padding(.top, 50)
                    }
                    
                    Image("Reset")
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .cornerRadius(50)
                        .shadow(radius: 10)
                        .padding()
                    
                   
                        Text("Now you're ready to embark on this magical journey. Enjoy the enchanting world of your Magical Plant Garden!")
                            .padding()
                            .foregroundStyle(.white)
                            .font(.system(.title3, weight: .light))
                            .padding(.vertical)
                    
                    
                    Spacer()
                    
                    Button{
                        isOnboardingShowing = false
                        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
                    } label: {
                        ZStack{
                            Rectangle()
                                .cornerRadius(15)
                                .frame(width:240, height:50)
                                .foregroundColor(.black)
                                .shadow(radius: 10)
                            
                            Text ("Start now")
                                .foregroundStyle(.white)
                        }
                    }.padding()
                    
                    Spacer()
                }
                .tag(6)
                .opacity(currentTab == 6 ? 1 : 0)
                .animation(.easeInOut)

                
            })
            .ignoresSafeArea()
            .background(Color.carbon)
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
        }
    }
    
    func createPage(title: String, description: String, imageName: String, currentTab: Binding<Int>, tabIndex: Int, optionalText: String? = nil) -> some View {
           VStack {
               ZStack {
                   VStack(alignment: .leading) {
                       Text(title)
                           .font(.system(.title, design: .serif))
                           .foregroundStyle(.white)
                           .padding()
                       
                       Text(description)
                           .padding()
                           .foregroundStyle(.white)
                           .font(.system(.title3, weight: .light))
                   }
                   .padding(.top, 50)
               }
               
               Image(imageName)
                   .resizable()
                   .scaledToFit()
                   .clipped()
                   .cornerRadius(50)
                   .shadow(radius: 10)
                   .padding()
               
               if let optionalText = optionalText {
                   Text(optionalText)
                       .padding()
                       .foregroundStyle(.white)
                       .font(.system(.title3, weight: .light))
                       .padding(.vertical)
               }
           }
           .tag(tabIndex)
           .opacity(currentTab.wrappedValue == tabIndex ? 1 : 0)
           .animation(.easeInOut)
       }
}

extension Color {
    static let carbon = Color(red: 0.11, green: 0.12, blue: 0.13)
}

#Preview {
    OnboardingView(isOnboardingShowing: .constant(true))
}
