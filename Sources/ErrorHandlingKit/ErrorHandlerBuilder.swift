/// A builder that creates configured `ErrorHandler` instances.
///
/// Use this builder to declaratively construct error handlers by chaining
/// conditional and unconditional actions.
///
/// Example:
/// ```
/// let handler = ErrorHandlerBuilder<NetworkError>()
///     .always { error in print("Error occurred: \(error)") }
///     .when({ $0 == .timeout }, then: [
///         { _ in retryRequest() },
///         { _ in logTimeout() }
///     ])
///     .build()
/// ```
public final class ErrorHandlerBuilder<T: Error> {
    private var actions: [ErrorHandler<T>.Action] = []
    
    /// Creates a new builder with no configured actions.
    public init() {}
    
    /// Adds a conditional action that executes when the predicate returns true.
    ///
    /// - Parameters:
    ///   - condition: A closure that determines if the actions should execute
    ///   - actions: An array of closures to execute when the condition is met
    /// - Returns: The builder instance for method chaining
    public func when(_ condition: @escaping (T) -> Bool, then actions: [(T) -> Void]) -> Self {
        self.actions.append(.conditional(condition: condition, actions: actions))
        return self
    }
    
    /// Adds an unconditional action that always executes.
    ///
    /// - Parameter action: The closure to execute for all errors
    /// - Returns: The builder instance for method chaining
    public func always(_ action: @escaping (T) -> Void) -> Self {
        actions.append(.unconditional(action))
        return self
    }
    
    /// Constructs the configured `ErrorHandler`.
    ///
    /// - Returns: A new `ErrorHandler` instance with all registered actions
    public func build() -> ErrorHandler<T> {
        return ErrorHandler<T>(actions: actions)
    }
}