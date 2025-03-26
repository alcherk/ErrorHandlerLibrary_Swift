/// Builder for creating ErrorHandler instances
public final class ErrorHandlerBuilder<T: Error> {
    private var errorHandlingRules: [ErrorHandler<T>.ErrorHandlingRule] = []
    private var unconditionalActions: [(T) -> Void] = []
    private var preHandlers: [(T) -> Void] = []
    private var postHandlers: [(T, HandlingResult) -> Void] = []
    
    public init() {}
    
    /// Adds a conditional handler
    public func when(_ condition: @escaping (T) -> Bool, then actions: [(T) -> Void]) -> Self {
        errorHandlingRules.append(
            ErrorHandler<T>.ErrorHandlingRule(
                condition: condition,
                actions: actions
            )
        )
        return self
    }
    
    /// Adds a conditional handler with single action
    public func when(_ condition: @escaping (T) -> Bool, then action: @escaping (T) -> Void) -> Self {
        return when(condition, then: [action])
    }
    
    /// Adds an unconditional action
    public func always(_ action: @escaping (T) -> Void) -> Self {
        unconditionalActions.append(action)
        return self
    }
    
    /// Adds multiple unconditional actions
    public func always(_ actions: [(T) -> Void]) -> Self {
        unconditionalActions.append(contentsOf: actions)
        return self
    }
    
    /// Adds a pre-handler that runs before any condition checks
    public func before(_ handler: @escaping (T) -> Void) -> Self {
        preHandlers.append(handler)
        return self
    }
    
    /// Adds a post-handler that runs after handling completes
    public func after(_ handler: @escaping (T, HandlingResult) -> Void) -> Self {
        postHandlers.append(handler)
        return self
    }
    
    public func build() -> ErrorHandler<T> {
        return ErrorHandler<T>(
            errorHandlingRules: errorHandlingRules,
            unconditionalActions: unconditionalActions,
            preHandlers: preHandlers,
            postHandlers: postHandlers
        )
    }
}