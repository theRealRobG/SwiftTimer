import Foundation
import ArgumentParser

struct Time: Codable, Equatable, CustomStringConvertible, ExpressibleByArgument {
    static let zero = Time(hours: 0, minutes: 0, seconds: 0)

    let hours: Int
    let minutes: Int
    let seconds: Int

    var description: String {
        String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }

    var totalSeconds: Int { seconds + minutes*60 + hours*3600 }

    init(hours: Int, minutes: Int, seconds: Int) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }

    init(seconds s: Int) {
        let secondsPerMinute = 60
        let minutesPerHour = 60
        let secondsPerHour = secondsPerMinute * minutesPerHour
        self.hours = s / secondsPerHour
        self.minutes = s / secondsPerMinute % minutesPerHour
        self.seconds = s % secondsPerMinute
    }

    init?(argument: String) {
        guard let time = try? TimeDecoder().decode(string: argument) else { return nil }
        self = time
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let timeString = try container.decode(String.self)
        if let seconds = Int(timeString) {
            self = Time(seconds: seconds)
            return
        }
        let timeComponents = timeString.split(separator: ":")
        guard timeComponents.count == 3 else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid time structure: date not split into 3 components by `:` separator."
            )
        }
        guard let hours = Int(timeComponents[0]) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid time structure: hours component not valid Int."
            )
        }
        guard let minutes = Int(timeComponents[1]) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid time structure: minutes component not valid Int."
            )
        }
        guard let seconds = Int(timeComponents[2]) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid time structure: seconds component not valid Int."
            )
        }
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(String(format: "%04u-%02u-%02u", hours, minutes, seconds))
    }
}

struct TimeDecoder {
    private struct HelperJSON: Codable, Equatable {
        let time: Time
    }
    private let decoder = JSONDecoder()

    func decode(string str: String) throws -> Time {
        let stringData = Data(timeStringJSON(forTimeString: str).utf8)
        return try decoder.decode(HelperJSON.self, from: stringData).time
    }

    private func timeStringJSON(forTimeString timeString: String) -> String {
        return "{\"time\":\"\(timeString)\"}"
    }
}
