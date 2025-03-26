/// Protocol defining error handling behavior
public protocol IErrorHandling {
    associatedtype T: Error
    func handle(_ error: T) -> HandlingResult
}

/// Concrete implementation of error handler
public struct ErrorHandler<T: Error>: IErrorHandling {
    private let errorHandlingRules: [ErrorHandlingRule]
    private let unconditionalActions: [(T) -> Void]
    private let preHandlers: [(T) -> Void]
    private let postHandlers: [(T, HandlingResult) -> Void]
    
    public struct ErrorHandlingRule {
        let condition: (T) -> Bool
        let actions: [(T) -> Void]
    }
    
    public init(
        errorHandlingRules: [ErrorHandlingRule],
        unconditionalActions: [(T) -> Void],
        preHandlers: [(T) -> Void],
        postHandlers: [(T, HandlingResult) -> Void]
    ) {
        self.errorHandlingRules = errorHandlingRules
        self.unconditionalActions = unconditionalActions
        self.preHandlers = preHandlers
        self.postHandlers = postHandlers
    }
    
    public func handle(_ error: T) -> HandlingResult {
        preHandlers.forEach { $0(error) }
        
        // Execute unconditional actions
        unconditionalActions.forEach { $0(error) }
        
        for rule in errorHandlingRules {
            if rule.condition(error) {
                rule.actions.forEach { $0(error) }
                postHandlers.forEach { $0(error, .handled) }
                return .handled
            }
        }
        
        postHandlers.forEach { $0(error, .unhandled) }
        return .unhandled
    }
}