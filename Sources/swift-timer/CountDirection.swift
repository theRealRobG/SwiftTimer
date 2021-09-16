import ArgumentParser

enum CountDirection: ExpressibleByArgument {
    case up
    case down

    init?(argument: String) {
        switch argument {
        case "up": self = .up
        case "down": self = .down
        default: return nil
        }
    }
}
