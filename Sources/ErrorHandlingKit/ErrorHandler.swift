public final class ErrorHandler<T: Error> {
    public enum HandlingResult {
        case handled
        case unhandled
    }
    
    public enum Action {
        case unconditional((T) -> Void)
        case conditional(condition: (T) -> Bool, action: (T) -> Void)
    }
    
    private let actions: [Action]
    
    public init(actions: [Action]) {
        self.actions = actions
    }
    
    @discardableResult
    public func handle(_ error: T, completion: ((HandlingResult) -> Void)? = nil) -> HandlingResult {
        var result = HandlingResult.unhandled
        
        for action in actions {
            switch action {
            case .unconditional(let handler):
                handler(error)
                
            case .conditional(let condition, let handler):
                if condition(error) {
                    handler(error)
                    result = .handled
                }
            }
        }
        
        completion?(result)
        return result
    }
}