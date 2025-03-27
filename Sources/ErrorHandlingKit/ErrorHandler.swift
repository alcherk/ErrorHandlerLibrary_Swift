/// A generic error handler that processes errors of type `T` according to configured actions.
///
/// The handler executes actions in the order they were registered, with conditional actions
/// only executing when their conditions are met. Unconditional actions always execute.
///
/// - Note: This class is thread-safe and can be used from multiple threads concurrently.
public final class ErrorHandler<T: Error> {
    /// The result of handling an error.
    public enum HandlingResult {
        /// The error was handled by at least one conditional action
        case handled
        /// No conditional actions handled the error
        case unhandled
    }
    
    /// Represents an action that can be taken when handling an error.
    public enum Action {
        /// An action that always executes
        case unconditional((T) -> Void)
        /// Actions that only execute when the condition is met
        case conditional(condition: (T) -> Bool, actions: [(T) -> Void])
    }
    
    private let actions: [Action]
    
    /// Creates an error handler with the specified actions.
    ///
    /// - Parameter actions: The actions to execute when handling errors, in order.
    public init(actions: [Action]) {
        self.actions = actions
    }
    
    /// Handles the specified error, executing all applicable actions.
    ///
    /// - Parameters:
    ///   - error: The error to handle
    ///   - completion: An optional closure called with the handling result
    /// - Returns: The handling result
    @discardableResult
    public func handle(_ error: T, completion: ((HandlingResult) -> Void)? = nil) -> HandlingResult {
        var result = HandlingResult.unhandled
        
        for action in actions {
            switch action {
            case .unconditional(let handler):
                handler(error)
                
            case .conditional(let condition, let handlers):
                if condition(error) {
                    handlers.forEach { $0(error) }
                    result = .handled
                }
            }
        }
        
        completion?(result)
        return result
    }
}