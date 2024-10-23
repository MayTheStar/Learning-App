//
//  Main.swift
//  Learning
//
//  Created by May Bader Alotaibi on 20/04/1446 AH.
//




import SwiftUI

struct Main: View {
    @State private var currentDate = Date()
    @State private var streakCount = 10
    @State private var frozenCount = 2
    @State private var totalFreezesUsed = 2
    @State private var logStatus: LogStatus = .logToday
    @State private var selectedDate = Date() // For calendar date selection
    @State private var learningDays: Set<Date> = [] // Store learning days in the calendar
    @State private var freezeDays: Set<Date> = []   // Store freeze days in the calendar
    @State private var isMonthlyView = false // Toggle between weekly and monthly view
    var goal: String
    
    enum LogStatus {
        case logToday
        case learnedToday
        case freezedToday
    }
    
    var freezeLimit: Int {
        return 6 // Example for a month, can be adjusted dynamically
    }
    var body: some View {
        NavigationStack {
            ScrollView { // Wrap all content inside a ScrollView
                VStack {
                    // Header with title and streak tracker
                    headerView()
                    
                    // Border around calendar and counters
                    VStack(spacing: 10) { // Reduce spacing between calendar and counters
                        // Weekly or Monthly Calendar view replacing the rectangle
                        calendarView()
                        
                        // Add a line under the calendar
                        Divider().background(Color.gray)
                        
                        // Display streak and freeze counts
                        HStack(spacing: 20) { // Reduced horizontal spacing between counters
                            streakCounterView
                            Divider() // Line between day streak and day frozen
                                .background(Color.gray)
                            freezeCounterView
                        }
                        .padding(.vertical, 5) // Reduced vertical padding for compact spacing
                    }
                    .padding(10) // Reduce the overall padding around the calendar and counters
                    .background(Color.black) // Background color inside the border
                    .cornerRadius(10) // Round corners for the entire section
                    .overlay( // Adding the border to enclose the calendar and counters
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.accentColor, lineWidth: 2) // Border color and thickness
                    )
                    
                    // Log as Learned Button (Circle)
                    logButton
                    
                    // Freeze Day Button
                    freezeButton
                    
                    // Display freeze usage information
                    freezeUsageInfo
                    
                }
                .padding() // Optional padding to adjust view spacing
                
            }
            .background(Color.black.ignoresSafeArea()) // Black background, ignoring safe area
        }
    }
    
    
    private func headerView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(formattedDate)
                    .foregroundColor(.gray)
                
                Text(goal.isEmpty ? "Learning Swift" : goal) // Display the passed goal
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
            }
            .onAppear {
                updateDate() // Ensure the date is updated when the view appears
            }
            
            Spacer()
            
            // Fire emoji for streak display, wrapped with NavigationLink
            NavigationLink(destination: UpdateView()) {
                ZStack {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 50, height: 50)
                    
                    Text("🔥")
                        .font(.system(size: 30))
                }
            }
           
            .navigationBarBackButtonHidden()
        }
       
//        .padding()
    
        .background(Color.black)
    }
    
    // MARK: - Calendar View (Merged)
    private func calendarView() -> some View {
        VStack {
            HStack {
                // Month, Year, and Toggle button for calendar
                HStack {
                    Text(monthAndYearString())
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    
                    // Right pointing arrow for toggling view
                    Button(action: toggleView) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.orange)
                    }
                }
                //                .padding(.leading)
                
                Spacer()
                
                // Arrows to navigate between weeks or months
                HStack(spacing: 20) {
                    Button(action: previousPeriod) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }
                    
                    Button(action: nextPeriod) {
                        Image(systemName: "arrow.right")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }
                }
                //                .padding(.trailing)
            }
            .padding(.top, 0)
            .padding(.bottom, 10)
            
            if isMonthlyView {
                monthlyCalendarView
            } else {
                weeklyCalendarView
            }
        }
    }
    
    private var weeklyCalendarView: some View {
        let weekDays = currentWeekDates()
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        
        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(weekDays, id: \.self) { date in
                dayView(for: date)
            }
        }
        //        .padding(.horizontal)
        //        .padding(.bottom, 20)
    }
    
    private var monthlyCalendarView: some View {
        let monthDays = currentMonthDates()
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        
        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(monthDays, id: \.self) { date in
                dayView(for: date)
            }
        }
        
    }
    
    // MARK: - Day View
    private func dayView(for date: Date) -> some View {
        let isLearningDay = learningDays.contains { Calendar.current.isDate($0, inSameDayAs: date) }
        let isFreezeDay = freezeDays.contains { Calendar.current.isDate($0, inSameDayAs: date) }
        
        return VStack {
            Text(weekdayString(for: date))
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(dayNumber(for: date))
                .font(.title3)
                .frame(width: 40, height: 40)
                .background(isLearningDay ? Color.orange : (isFreezeDay ? Color.blue1 : Color.clear))
                .clipShape(Circle())
                .foregroundColor(isLearningDay || isFreezeDay ? .white : .gray)
                .onTapGesture {
                    selectedDate = date
                }
        }
    }
    
    // MARK: - Log Button
    private var logButton: some View {
        Button(action: {
            handleLogAction()
        }) {
            Text(buttonTitle)
                .font(.largeTitle)
                .bold()
                .frame(width: 290, height: 290)
                .foregroundColor(foregroundColorForStatus) // Set the text color based on status
                .background(Circle().fill(backgroundColorForStatus)) // Set the circle color based on status
        }
        .padding()
    }
    
    // MARK: - Colors based on Log Status
    private var backgroundColorForStatus: Color {
        switch logStatus {
        case .logToday:
            return Color.orange // Log today as learner: orange background
        case .learnedToday:
            return Color.brown1 // Learned today: brown background
        case .freezedToday:
            return Color.blue1 // Freezed today: blue background
        }
    }
    
    private var foregroundColorForStatus: Color {
        switch logStatus {
        case .logToday:
            return Color.black // Log today as learner: black text
        case .learnedToday:
            return Color.orange // Learned today: orange text
        case .freezedToday:
            return Color.blue.opacity(0.8) // Freezed today: dark blue text
        }
    }
    
    // MARK: - Freeze Button
    private var freezeButton: some View {
        Button(action: {
            handleFreezeAction()
        }) {
            Text("Freeze day")
                .font(.callout)
                .bold()
                .foregroundColor(.blue)
                .padding()
                .frame(width: 150, height: 60)
                .background(Color(.colorB))
                .cornerRadius(8)
        }
        .padding(.bottom, 30)
    }
    // MARK: - Streak Counter View
    private var streakCounterView: some View {
        VStack { // Change the outer container to VStack
            HStack {
                Text("\(streakCount)")
                    .font(.title)
                    .foregroundColor(.white)
                Text("🔥")
                    .font(.title) // Ensure the fire emoji is the same size as the number
                    .foregroundColor(.white)
            }
            Text("Day streak")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
    // MARK: - Streak Counter View
    private var freezeCounterView: some View {
        VStack { // Change the outer container to VStack
            HStack {
                Text("\(frozenCount)")
                    .font(.title)
                    .foregroundColor(.white)
                Text("🧊")
                    .font(.title) // Ensure the fire emoji is the same size as the number
                    .foregroundColor(.white)
            }
            Text("Day frozen")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
    
    
    private var freezeUsageInfo: some View {
        Text("\(totalFreezesUsed) out of \(freezeLimit) freezes used")
            .foregroundColor(.gray)
            .padding(.bottom)
    }

    // MARK: - Log and Freeze Handlers
    private var buttonTitle: String {
        switch logStatus {
        case .logToday:
            return "Log today as Learned"
        case .learnedToday:
            return "Learned today"
        case .freezedToday:
            return "Freezed today"
        }
    }

    private func handleLogAction() {
        switch logStatus {
        case .logToday:
            logStatus = .learnedToday
            streakCount += 1
            learningDays.insert(selectedDate) // Mark selected date as learned
        case .learnedToday:
            break
        case .freezedToday:
            break
        }
    }

    private func handleFreezeAction() {
        if totalFreezesUsed < freezeLimit {
            frozenCount += 1
            totalFreezesUsed += 1
            logStatus = .freezedToday
            freezeDays.insert(selectedDate) // Mark selected date as frozen
        }
    }

    // MARK: - Helper Functions
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMM" // "Tuesday 22 Oct"
        return formatter.string(from: currentDate)
    }

    private func updateDate() {
        currentDate = Date() // Update the date
    }

    private func toggleView() {
        isMonthlyView.toggle()
    }

    private func previousPeriod() {
        if isMonthlyView {
            currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        } else {
            currentDate = Calendar.current.date(byAdding: .day, value: -7, to: currentDate)!
        }
    }

    private func nextPeriod() {
        if isMonthlyView {
            currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        } else {
            currentDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
        }
    }

    private func weekdayString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    private func dayNumber(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    private func monthAndYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }

    private func currentWeekDates() -> [Date] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: currentDate)
        let startOfWeek = calendar.date(byAdding: .day, value: -weekday + 1, to: currentDate)!

        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    private func currentMonthDates() -> [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let components = calendar.dateComponents([.year, .month], from: currentDate)

        return range.compactMap { day -> Date? in
            calendar.date(from: DateComponents(year: components.year, month: components.month, day: day))
        }
    }
}

#Preview {
    Main(goal: "Learning Swift")
}

