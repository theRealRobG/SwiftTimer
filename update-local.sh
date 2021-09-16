#!/bin/sh
swift build -c release && cp .build/release/swift-timer /usr/local/bin/swift-timer
