import Foundation

/// Result of error handling attempt
public enum HandlingResult {
    case handled
    case unhandled
    case recovered
}

/// Main entry point for error handling system
/// Global function to create new error handlers
public func createErrorHandler<T: Error>() -> ErrorHandlerBuilder<T> {
    return ErrorHandlerBuilder<T>()
}

/// Global function to handle uncaught errors
public func handleUncaughtError(_ error: Error) {
    print("‼️ Unhandled error: \(error)")
}