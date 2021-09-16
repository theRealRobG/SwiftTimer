import ArgumentParser

enum TimeFormat: ExpressibleByArgument {
    case seconds
    case clock

    init?(argument: String) {
        switch argument {
        case "seconds": self = .seconds
        case "clock": self = .clock
        default: return nil
        }
    }
}
