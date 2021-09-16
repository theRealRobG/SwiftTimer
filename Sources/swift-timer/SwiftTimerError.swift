import Foundation

enum SwiftTimerError: CustomNSError, LocalizedError {
    case limitGreaterThanStartWithDownCount(limit: Int, start: Int)
    case limitLessThanStartWithUpCount(limit: Int, start: Int)

    static var errorDomain = "SwiftTimerErrorDomain"

    var errorCode: Int {
        switch self {
        case .limitGreaterThanStartWithDownCount: return 1
        case .limitLessThanStartWithUpCount: return 2
        }
    }

    var errorDescription: String? {
        switch self {
        case .limitGreaterThanStartWithDownCount(let limit, let start):
            return "Count until limit (\(limit)) was greater than the start count (\(start)) when set to count down"
        case .limitLessThanStartWithUpCount(let limit, let start):
            return "Count until limit (\(limit)) was less than the start count (\(start)) when set to count up"
        }
    }
}
