import Foundation

protocol GetName {
    func getName() -> String
}

protocol GetType {
    func type() -> String
}

struct Ident: GetName {
    private let body: String

    func getName() -> String {
        body
    }
}

struct ImportName: GetName {
    var ident: Ident

    func getName() -> String {
        ident.getName()
    }
}

struct ImportPath: GetName {
    var path: [ImportName]

    func getName() -> String {
        path.map {
                    $0.getName()
                }
                .joined(separator: ".")
    }
}

struct ConstantName: GetName {
    var ident: Ident

    func getName() -> String {
        ident.getName()
    }
}

struct FunctionName: GetName {
    var ident: Ident

    func getName() -> String {
        ident.getName()
    }
}

struct ParameterName: GetName {
    var ident: Ident

    func getName() -> String {
        ident.getName()
    }
}

struct ValueName: GetName {
    var ident: Ident

    func getName() -> String {
        ident.getName()
    }
}

private typealias RawString = String

enum PrimitiveType {
    case u8
    case u16
    case u32
    case u64
    case i8
    case i16
    case i32
    case i64
    case f32
    case f64
    case bool
    case String
    case char
    case None

    func name() -> String {
        RawString(describing: self)
    }
}

struct StructType: GetName {
    var attr_name: Ident
    var attr_type: Type

    func getName() -> String {
        attr_name.getName()
    }
}

struct StructTypes: GetName {
    var struct_name: Ident
    var types: [StructType]

    func getName() -> String {
        struct_name.getName()
    }
}

indirect enum Type: GetName {
    case Primitive(PrimitiveType)
    case Struct(StructType)
    case Array(Type, UInt32)

    func getName() -> String {
        switch self {
        case .Primitive(let type): return type.name()
        case .Struct(let type): return type.getName()
        case .Array(let type, let size): return "[\(type.getName());\(size)]"
        }
    }
}

enum ConstantValue {
    case Constant(ConstantName)
    case Value(PrimitiveValue)
}

class ConstantExpression {
    var value: ConstantValue
    var operation: Optional<(ExpressionOperations, ConstantExpression)> = nil

    init(value: ConstantValue, operation: (ExpressionOperations, ConstantExpression)?) {
        self.value = value
        self.operation = operation
    }
}

struct Constant: GetName {
    var constant_name: ConstantName
    var constant_type: Type
    var constant_value: ConstantExpression

    func getName() -> String {
        constant_name.getName()
    }
}

struct FunctionParameter: GetName {
    let parameter_name: ParameterName
    let parameter_type: Type

    func getName() -> String {
        parameter_name.getName()
    }
}

struct FunctionStatement: GetName {
    let name: FunctionName
    let parameters: [FunctionParameter]
    let result_type: Type
    let body: [BodyStatement]

    func getName() -> String {
        name.getName()
    }
}

enum PrimitiveValue {
    case U8(UInt8)
    case U16(UInt16)
    case U32(UInt32)
    case U64(UInt64)
    case I8(Int8)
    case I16(Int16)
    case I32(Int32)
    case I64(Int64)
    case F32(Float32)
    case F64(Float64)
    case Bool(Bool)
    case String(String)
    case Char(Character)
    case None

    var type: PrimitiveType {
        get {
            switch self {
            case .U8: return PrimitiveType.u8
            case .U16: return PrimitiveType.u16
            case .U32: return PrimitiveType.u32
            case .U64: return PrimitiveType.u64
            case .I8: return PrimitiveType.i8
            case .I16: return PrimitiveType.i16
            case .I32: return PrimitiveType.i32
            case .I64: return PrimitiveType.i64
            case .F32: return PrimitiveType.f32
            case .F64: return PrimitiveType.f64
            case .Bool: return PrimitiveType.bool
            case .String: return PrimitiveType.String
            case .Char: return PrimitiveType.char
            case .None: return PrimitiveType.None
            }
        }
    }
}

struct BodyStatement {
    let body: String
}

struct ExpressionOperations {
    let body: String
}



