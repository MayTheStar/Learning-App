//
//  ContentView.swift
//  Learning
//
//  Created by May Bader Alotaibi on 20/04/1446 AH.
//



import SwiftUI


struct ContentView: View {
    @State private var goal: String = "" // State variable for the TextField input
    @State private var selectedTimeframe: String? = nil // State variable for selected button
    
    
    var body: some View {
        NavigationStack{
            VStack {
                // Circle with fire emoji
                ZStack {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 150, height: 150)
                    
                    Text("🔥")
                        .font(.system(size: 70))
                }
                .padding(.top, 50)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Hello learner!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("This app will help you learn everyday")
                            .font(.title3) // Smaller font size
                            .foregroundColor(.gray2) // Gray text color
                    }
                    .padding(.leading, 20)
                    
                    Spacer() // Push the text to the left side
                }
                .padding(.top, 20)
                
                
                // Input and Timeframe Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("I want to learn")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                    
                    TextField("", text: $goal)
                        .modifier(PlaceholderStyle(showPlaceholder: goal.isEmpty, placeholder: "Swift"))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .tint(.orange)
                        .background(Color.clear)
                        .overlay(
                            Rectangle()
                                .frame(width: 360, height: 2)
                                .foregroundColor(Color.accentColor),
                            alignment: .bottom
                        )
                    
                    Text("I want to learn it in a")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                    
                    // Timeframe buttons
                    HStack {
                        ForEach(["Week", "Month", "Year"], id: \.self) { timeframe in
                            Button(action: {
                                selectedTimeframe = timeframe
                            }) {
                                Text(timeframe)
                                    .font(.title3)
                                    .foregroundColor(selectedTimeframe == timeframe ? .black : .orange)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(selectedTimeframe == timeframe ? Color.orange : Color.accentColor)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.top, 30)
                
                Spacer()
                
           
                // Start button at the bottom
          
               /* NavigationLink(destination: Main())*/
                NavigationLink(destination: Main(goal: goal)) {
                   
                    HStack {
                      Text("Start")
                       .font(.title3)
                       .bold()
                    Image(systemName: "arrow.right")
                       .font(.title3)
                      
                                          }
                    
                    .foregroundColor(.black)
                    .padding(.vertical, 17)
                    .padding(.horizontal, 50)
                    .background(Color.orange)
                    .cornerRadius(8)
                    
                }
             
                
                .padding(.bottom, 110)
               
            }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color.black)
//                .ignoresSafeArea()
         
             .background(Color.black.ignoresSafeArea())
        }
        .navigationBarBackButtonHidden()
        
    }
}

struct PlaceholderStyle: ViewModifier {
    var showPlaceholder: Bool
    var placeholder: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceholder {
                Text(placeholder)
                    .foregroundColor(.gray2) // Gray placeholder text
            }
            content
                .foregroundColor(.white) // Text color when typing
        }
    }
}

#Preview {
    ContentView()
}



