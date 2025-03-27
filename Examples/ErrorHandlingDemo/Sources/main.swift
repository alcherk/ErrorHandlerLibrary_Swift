/// A demonstration of the ErrorHandlingKit usage.
///
/// This example shows how to:
/// 1. Define custom error types
/// 2. Configure an error handler with multiple actions
/// 3. Test different error scenarios
import Foundation
import ErrorHandlingKit

/// Custom error types for demonstration purposes
enum NetworkError: Error {
    /// The request timed out
    case timeout
    /// The request was unauthorized
    case unauthorized
    /// A server error occurred
    case serverError
}

// Configure the error handler with various actions
let handler = ErrorHandlerBuilder<NetworkError>()
    .always { (error: NetworkError) in print("1️⃣ First unconditional") }
    .when({ $0 == .timeout }, then: [
        { (error: NetworkError) in print("⏳ Timeout handler 1") },
        { (error: NetworkError) in print("⏳ Timeout handler 2") }
    ])
    .always { (error: NetworkError) in print("2️⃣ Second unconditional") }
    .when({ $0 == .unauthorized }, then: [
        { (error: NetworkError) in print("🔒 Auth handler 1") },
        { (error: NetworkError) in print("🔒 Auth handler 2") },
        { (error: NetworkError) in print("🔒 Auth handler 3") }
    ])
    .always { (error: NetworkError) in print("3️⃣ Third unconditional") }
    .build()

print("Testing multiple actions per condition...\n")

// Test different error scenarios
[NetworkError.timeout, .unauthorized, .serverError].forEach { error in
    print("\nHandling \(error):")
    handler.handle(error) { result in
        print("Completion: Error was \(result == .handled ? "handled" : "not handled")")
    }
}

print("\nTest completed.")