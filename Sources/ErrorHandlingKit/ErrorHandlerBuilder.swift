public final class ErrorHandlerBuilder<T: Error> {
    private var actions: [ErrorHandler<T>.Action] = []
    
    public init() {}
    
    public func when(_ condition: @escaping (T) -> Bool, then action: @escaping (T) -> Void) -> Self {
        actions.append(.conditional(condition: condition, action: action))
        return self
    }
    
    public func always(_ action: @escaping (T) -> Void) -> Self {
        actions.append(.unconditional(action))
        return self
    }
    
    public func build() -> ErrorHandler<T> {
        return ErrorHandler<T>(actions: actions)
    }
}