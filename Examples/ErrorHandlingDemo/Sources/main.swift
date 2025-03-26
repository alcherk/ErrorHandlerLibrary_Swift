import Foundation
import ErrorHandlingKit

enum NetworkError: Error {
    case timeout
    case unauthorized
    case serverError
}

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

[NetworkError.timeout, .unauthorized, .serverError].forEach { error in
    print("\nHandling \(error):")
    handler.handle(error) { result in
        print("Completion: Error was \(result == .handled ? "handled" : "not handled")")
    }
}

print("\nTest completed.")