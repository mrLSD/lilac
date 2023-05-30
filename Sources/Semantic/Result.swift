import Foundation

public typealias StateResult<T> = Result<T, StateErrorResult>

public enum StateErrorKind {
    case constantAlreadyExist
    case typeAlreadyExist
    case functionAlreadyExist
    case valueNotFound
    case functionNotFound
    case returnNotFound
}

public struct StateErrorLocation {
    public let line: Int
    public let column: Int
}

public struct StateErrorResult: Error {
    public let kind: StateErrorKind
    public let value: String
    public let location: StateErrorLocation

    public init(kind: StateErrorKind,
                value: String,
                location: StateErrorLocation)
    {
        self.kind = kind
        self.value = value
        self.location = location
    }

    public func trace_state() -> String {
        "(\(self.kind) for value \(self.value) at \(self.location)"
    }
}
