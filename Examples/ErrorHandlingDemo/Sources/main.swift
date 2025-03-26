import Foundation
import ErrorHandlingKit

enum NetworkError: Error {
    case timeout
    case unauthorized
    case serverError
}

let handler = ErrorHandlerBuilder<NetworkError>()
    .always { _ in print("1️⃣ First unconditional") }
    .when({ $0 == .timeout }, then: { _ in print("⏳ Timeout handler") })
    .always { _ in print("2️⃣ Second unconditional") }
    .when({ $0 == .unauthorized }, then: { _ in print("🔒 Auth handler") })
    .always { _ in print("3️⃣ Third unconditional") }
    .build()

print("Testing execution order with completion blocks...\n")

[NetworkError.timeout, .unauthorized, .serverError].forEach { error in
    print("\nHandling \(error):")
    handler.handle(error, completion: { result in
        print("Completion: Error was \(result == .handled ? "handled" : "not handled")")
    })
}

print("\nTest completed.")