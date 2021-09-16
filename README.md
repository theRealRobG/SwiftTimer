# Swift Timer
This is a simple command-line timer. There are 2 reasons why I wrote this:
1) I couldn't find a default installed timer app on my Mac.
2) I wanted to play with Swift Argument Parser and writing a simple command line app in Swift.

## Building
There are 2 ways of using the executable:
1) Running through Swift (e.g. `swift run swift-timer`).
2) Building the executable (`swift build -c release`) and then using it directly (e.g. `./.build/release/swift-timer`).

A convenience script is also included (`update-local.sh`) that compiles a release executable and then copies it into `/usr/local/bin`:
```sh
% ./update-local.sh     
[4/4] Linking swift-timer

* Build Completed!
```

## Usage
```sh
USAGE: swift-timer [--time-format <time-format>] [--count-direction <count-direction>] [--start-from <start-from>] [--count-until <count-until>]

OPTIONS:
  --time-format <time-format>
                          The format for output time logs (default: seconds)
  --count-direction <count-direction>
                          The direction to count in (default: up)
  --start-from <start-from>
                          The value in seconds or clock format to start the count from (must be positive) e.g. 90s can be expressed as 90 or 00:01:30 (default: 00:00:00)
  --count-until <count-until>
                          The value in seconds or clock format to count until (must be positive) e.g. 120s can be expressed as 90 or 00:02:00
  -h, --help              Show help information.


```

The main command is:
```sh
swift-timer
```
This will start a count-up timer (in seconds) from 0 that will continue indefinitely.

There is the possibility to format the time into more of a digital clock format by passing the `--time-format` option:
```sh
swift-timer --time-format clock
```

You can also define whether you want a count up or down as well as assigning a limit and a starting value for the count.

## Error cases
- Setting a `--count-until` less than your `--start-from` when `--count-direction` is `up` is not supported.
- Setting a `--count-until` greater than your `--start-from` when `--count-direction` is `down` is not supported.
- Negative values for `--count-until` and `--start-from` are not supported.

## Examples
Start a 2 minute count down formatted as a clock:
```sh
swift-timer --time-format clock --count-direction down --start-from 120
```

Count up to 10:
```sh
swift-timer --count-until 10
```

Set a count that ends at 1 hour using clock format input:
```sh
swift-timer --time-format clock --count-until 01:00:00
```
