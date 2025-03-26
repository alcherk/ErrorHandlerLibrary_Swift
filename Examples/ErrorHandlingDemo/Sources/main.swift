import Foundation
import ErrorHandlingKit

enum NetworkError: Error {
    case timeout
    case invalidResponse
    case unauthorized
    case serverError
}

enum DatabaseError: Error {
    case connectionFailed
    case queryFailed
    case constraintViolation
}

// Create error handlers
let networkHandler = ErrorHandlerBuilder<NetworkError>()
    // Unconditional actions
    .always { _ in print("📡 Network operation started") }
    
    // Conditional handlers
    .when({ $0 == .timeout }, then: [
        { _ in print("⏳ Network timeout detected - starting recovery sequence") },
        { _ in print("   🔄 Step 1: Checking connection stability...") },
        { _ in print("   🔄 Step 2: Reducing request timeout...") },
        { _ in print("   🔄 Step 3: Attempting retry with backoff...") },
        { _ in print("✅ Recovery sequence completed successfully") }
    ])
    
    .when({ $0 == .invalidResponse }, then: { _ in print("⚠️ Invalid server response") })
    
    .when({ $0 == .unauthorized }, then: [
        { _ in print("🔒 Authentication required - checking token") },
        { _ in print("🔄 Attempting token refresh...") },
        { _ in print("⚠️ Please re-authenticate") }
    ])
    
    // Another unconditional action
    .always { _ in print("📡 Network operation completed") }
    .build()

let databaseHandler = ErrorHandlerBuilder<DatabaseError>()
    .when({ $0 == .connectionFailed }, then: { _ in print("💾 Database connection failed - reconnecting...") })
    .when({ $0 == .queryFailed }, then: { _ in print("❌ Database query failed") })
    .build()

// Simulate error handling
print("Starting error handling demo...\n")

let errors: [Error] = [
    NetworkError.timeout,
    NetworkError.invalidResponse,
    DatabaseError.connectionFailed,
    NetworkError.unauthorized,
    DatabaseError.queryFailed
]

for (i, error) in errors.enumerated() {
    print("\nOperation \(i + 1):")
    let result: HandlingResult = {
        switch error {
        case let networkError as NetworkError:
            return networkHandler.handle(networkError)
        case let dbError as DatabaseError:
            return databaseHandler.handle(dbError)
        default:
            print("‼️ Unhandled error: \(error)")
            return .unhandled
        }
    }()
}

print("\nDemo completed.")