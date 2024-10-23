//
//  UpdateView.swift
//  Learning
//
//  Created by May Bader Alotaibi on 20/04/1446 AH.
//


import SwiftUI

struct UpdateView: View {
    @State private var goal: String = "" // State variable for the TextField input
    @State private var selectedTimeframe: String? = nil // State variable for selected button
    
    init() {
        // Set the navigation bar title color to orange
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    var body: some View {
        NavigationStack {
            VStack {
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
                .padding(.top, 80)
                
                Spacer()
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("My Navigation Title")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: Main(goal: goal)) { // Navigate to Main
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.orange)
                                .bold()
                            Text("Back")
                                .foregroundColor(.orange)
                                .bold()
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: Main(goal: goal)) { // Navigate to Main
                        HStack {
                            Text("Update")
                                .foregroundColor(.orange)
                                .bold()
                        }
                    }

                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
       
        .navigationBarBackButtonHidden(true) // this one make the defult button dispear
    }
}

#Preview {
    UpdateView()
}


//
//import SwiftUI
//
//struct UpdateView: View {
//    @State private var goal: String = "" // State variable for the TextField input
//    @State private var selectedTimeframe: String? = nil // State variable for selected button
//
////    init() {
////        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
////    }
//
//    var body: some View {
//
//
//        NavigationStack{
//
//            VStack {
//
//
//
//
//                // Input and Timeframe Section
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("I want to learn")
//                        .font(.title3)
//                        .bold()
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 20)
//
//                    TextField("", text: $goal)
//                        .modifier(PlaceholderStyle(showPlaceholder: goal.isEmpty, placeholder: "Swift"))
//                        .padding(.vertical, 10)
//                        .padding(.horizontal, 20)
//                        .tint(.orange)
//                        .background(Color.clear)
//                        .overlay(
//                            Rectangle()
//                                .frame(width: 360, height: 2)
//                                .foregroundColor(Color.accentColor),
//                            alignment: .bottom
//                        )
//
//                    Text("I want to learn it in a")
//                        .font(.title3)
//                        .bold()
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 20)
//
//                    // Timeframe buttons
//                    HStack {
//                        ForEach(["Week", "Month", "Year"], id: \.self) { timeframe in
//                            Button(action: {
//                                selectedTimeframe = timeframe
//                            }) {
//                                Text(timeframe)
//                                    .font(.title3)
//                                    .foregroundColor(selectedTimeframe == timeframe ? .black : .orange)
//                                    .padding(.vertical, 8)
//                                    .padding(.horizontal, 16)
//                                    .background(selectedTimeframe == timeframe ? Color.orange : Color.accentColor)
//                                    .cornerRadius(8)
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 30)
//                }
//                .padding(.top, 80)
//
//                Spacer()
//
//
//            }
//
//
//             .background(Color.black.ignoresSafeArea())
//
//             .navigationTitle("My Navigation Title")
//
//             .toolbar{
//                 ToolbarItem (placement: .topBarLeading){
//                     NavigationLink(destination: Main(goal: goal)) { // Navigate to Main
//                         HStack {
//                             Image(systemName: "chevron.left")
//                                 .foregroundColor(.orange)
//                             Text("Back")
//                                 .foregroundColor(.orange)
//                         }
//                     }
//
//                 }
//                 ToolbarItem (placement: .topBarTrailing){
//                     NavigationLink(destination: Main(goal: goal)) { // Navigate to Main
//                         HStack {
//                             Text("Update")
//                                 .foregroundColor(.orange)
//                         }
//                     }
//
//                 }
////                 ToolbarItem (placement: .topBarTrailing){
////                     Button( action: {
////                         //to do
////                     }, label: {
////                         HStack{
////                             Text("Update")
////                                 .foregroundColor(.orange)
////                         }
////                     })
////                 }
//             }
//
//             .navigationBarTitleDisplayMode(.inline)
//
//        }
//
//        .navigationBarBackButtonHidden(true)
//
//
//    }
//}
//
//
//
//
//
//#Preview {
//    UpdateView()
//}

