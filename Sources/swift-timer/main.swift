import ArgumentParser
import Foundation

private func finishRunning() -> Never {
    print("FINISHED")
    return SwiftTimer.exit()
}

private func logCount(count: Int) {
    print("\u{1B}[1A\u{1B}[K\(count)")
}

private func logTime(time: Time) {
    print("\u{1B}[1A\u{1B}[K\(time)")
}

struct SwiftTimer: ParsableCommand {
    @Option(completion: .list(["seconds", "clock"]), help: "The format for output time logs")
    var timeFormat: TimeFormat = .seconds
    @Option(completion: .list(["up", "down"]), help: "The direction to count in")
    var countDirection: CountDirection = .up
    @Option(help: "The value in seconds or clock format to start the count from (must be positive) e.g. 90s can be expressed as 90 or 00:01:30")
    var startFrom: Time = .zero
    @Option(help: "The value in seconds or clock format to count until (must be positive) e.g. 120s can be expressed as 90 or 00:02:00")
    var countUntil: Time?

    mutating func run() throws {
        let timeFormat = self.timeFormat
        let direction = self.countDirection
        let limit: Int
        var count = self.startFrom.totalSeconds
        switch direction {
        case .down:
            limit = self.countUntil.map { Int($0.totalSeconds) } ?? 0
            guard limit <= count else { throw SwiftTimerError.limitGreaterThanStartWithDownCount(limit: limit, start: count) }
            guard limit != count else { finishRunning() }
        case .up:
            limit = self.countUntil.map { Int($0.totalSeconds) } ?? .max
            guard count <= limit else { throw SwiftTimerError.limitLessThanStartWithUpCount(limit: limit, start: count) }
            guard count != limit else { finishRunning() }
        }
        print("")
        let timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { timer in
            switch direction {
            case .down: count -= 1
            case .up: count += 1
            }
            switch timeFormat {
            case .clock:
                logTime(time: Time(seconds: count))
                guard count != limit else { finishRunning() }
            case .seconds:
                logCount(count: count)
                guard count != limit else { finishRunning() }
            }
        }
        RunLoop.main.add(timer, forMode: .default)
        RunLoop.main.run()
    }
}

SwiftTimer.main()
