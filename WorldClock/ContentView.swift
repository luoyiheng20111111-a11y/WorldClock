import SwiftUI

struct CityClock: Identifiable {
    let id = UUID()
    let name: String
    let timezone: TimeZone
    let flag: String
}

struct ContentView: View {
    @State private var currentTime = Date()
    @State private var selectedCities: [CityClock] = [
        CityClock(name: "北京", timezone: TimeZone(identifier: "Asia/Shanghai")!, flag: "🇨🇳"),
        CityClock(name: "东京", timezone: TimeZone(identifier: "Asia/Tokyo")!, flag: "🇯🇵"),
        CityClock(name: "纽约", timezone: TimeZone(identifier: "America/New_York")!, flag: "🇺🇸"),
        CityClock(name: "伦敦", timezone: TimeZone(identifier: "Europe/London")!, flag: "🇬🇧"),
        CityClock(name: "巴黎", timezone: TimeZone(identifier: "Europe/Paris")!, flag: "🇫🇷"),
        CityClock(name: "悉尼", timezone: TimeZone(identifier: "Australia/Sydney")!, flag: "🇦🇺")
    ]
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(selectedCities) { city in
                    CityClockRow(city: city, currentTime: currentTime)
                }
            }
            .navigationTitle("世界时钟")
            .onReceive(timer) { input in
                currentTime = input
            }
        }
    }
}

struct CityClockRow: View {
    let city: CityClock
    let currentTime: Date
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.timeZone = city.timezone
        return formatter
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 EEEE"
        formatter.timeZone = city.timezone
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }
    
    private var hour: Int {
        let calendar = Calendar.current
        var cal = calendar
        cal.timeZone = city.timezone
        return cal.component(.hour, from: currentTime)
    }
    
    private var isDaytime: Bool {
        hour >= 6 && hour < 18
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Text(city.flag)
                .font(.system(size: 40))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(city.name)
                    .font(.headline)
                Text(dateFormatter.string(from: currentTime))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(timeFormatter.string(from: currentTime))
                    .font(.system(size: 24, weight: .semibold, design: .monospaced))
                Image(systemName: isDaytime ? "sun.max.fill" : "moon.stars.fill")
                    .foregroundColor(isDaytime ? .yellow : .blue)
                    .font(.caption)
            }
        }
        .padding(.vertical, 8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
