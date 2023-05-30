/**
   # AST representation
   Represen Abstract syntax tree do describe complete graph tree.
 */

import Foundation

public protocol GetName {
    func getName() -> String
}

public protocol GetType {
    func getTzype() -> String
}

public struct Ident: GetName {
    private let body: String

    public func getName() -> String {
        body
    }
}

public struct ImportName: GetName {
    var ident: Ident

    public func getName() -> String {
        ident.getName()
    }
}

public struct ImportPath: GetName {
    var path: [ImportName]

    public func getName() -> String {
        path.map {
            $0.getName()
        }
        .joined(separator: ".")
    }
}

public struct ConstantName: GetName {
    var ident: Ident

    public func getName() -> String {
        ident.getName()
    }
}

public struct FunctionName: GetName {
    var ident: Ident

    public func getName() -> String {
        ident.getName()
    }
}

public struct ParameterName: GetName {
    var ident: Ident

    public func getName() -> String {
        ident.getName()
    }
}

public struct ValueName: GetName {
    var ident: Ident

    public func getName() -> String {
        ident.getName()
    }
}


public enum PrimitiveType {
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

    public func name() -> String {
        Swift.String(describing: self)
    }
}

public struct StructType: GetName {
    var attr_name: Ident
    var attr_type: Type

    public func getName() -> String {
        attr_name.getName()
    }
}

public struct StructTypes: GetName {
    var struct_name: Ident
    var types: [StructType]

    public func getName() -> String {
        struct_name.getName()
    }
}

public indirect enum Type: GetName {
    case Primitive(PrimitiveType)
    case Struct(StructType)
    case Array(Type, UInt32)

    public func getName() -> String {
        switch self {
        case .Primitive(let type): return type.name()
        case .Struct(let type): return type.getName()
        case .Array(let type, let size): return "[\(type.getName());\(size)]"
        }
    }
}

public enum ConstantValue {
    case Constant(ConstantName)
    case Value(PrimitiveValue)
}

public class ConstantExpression {
    let value: ConstantValue
    let operation: (ExpressionOperations, ConstantExpression)?

    init(value: ConstantValue, operation: (ExpressionOperations, ConstantExpression)?) {
        self.value = value
        self.operation = operation
    }
}

public struct Constant: GetName {
    var constant_name: ConstantName
    var constant_type: Type
    var constant_value: ConstantExpression

    public func getName() -> String {
        constant_name.getName()
    }
}

public struct FunctionParameter: GetName {
    let parameter_name: ParameterName
    let parameter_type: Type

    public func getName() -> String {
        parameter_name.getName()
    }
}

public struct FunctionStatement: GetName {
    let name: FunctionName
    let parameters: [FunctionParameter]
    let result_type: Type
    let body: [BodyStatement]

    public func getName() -> String {
        name.getName()
    }
}

public enum PrimitiveValue {
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

    public var type: PrimitiveType {
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

enum ExpressionValue {
    case ValueName(ValueName)
    case PrimitiveValue(PrimitiveValue)
    case FunctionCall(FunctionCall)
}

enum ExpressionOperations {
    case PlusMinus
    case Multiply
    case Divide
    case ShiftLeft
    case ShiftRight
    case And
    case Or
    case Xor
    case Eq
    case NotEq
    case Great
    case Less
    case GreatEq
    case LessEq
}

public class Expression {
    var expression_value: ExpressionValue
    var operation: (ExpressionOperations, Expression)?

    init(expression_value: ExpressionValue,
         operation: (ExpressionOperations, Expression)?)
    {
        self.expression_value = expression_value
        self.operation = operation
    }
}

public struct LetBinding: GetName {
    var name: ValueName
    var value_type: Type?
    var value: Expression

    public func getName() -> String {
        name.getName()
    }
}

public struct FunctionCall: GetName {
    var name: FunctionName
    var parameters: [Expression]

    public func getName() -> String {
        name.getName()
    }
}

public enum Condition {
    case Great
    case Less
    case Eq
    case GreatEq
    case LessEq
    case NotEq
}

public enum LogicCondition {
    case And
    case Or
}

public struct ExpressionCondition {
    var left: Expression
    var condition: Condition
    var right: Expression
}

public class ExpressionLogicCondition {
    var left: ExpressionCondition
    var right: (LogicCondition, ExpressionLogicCondition)?

    init(left: ExpressionCondition,
         right: (LogicCondition, ExpressionLogicCondition)?)
    {
        self.left = left
        self.right = right
    }
}

public enum IfCondition {
    case Single(Expression)
    case Logic(ExpressionLogicCondition)
}

public class IfStatement {
    var condition: IfCondition
    var body: [IfBodyStatement]
    var else_statement: [IfBodyStatement]?
    var else_if_statement: [IfStatement]?

    init(condition: IfCondition,
         body: [IfBodyStatement],
         else_statement: [IfBodyStatement]?,
         else_if_statement: [IfStatement]?)
    {
        self.condition = condition
        self.body = body
        self.else_statement = else_statement
        self.else_if_statement = else_if_statement
    }
}

public class IfLoopStatement {
    var condition: IfCondition
    var body: [IfLoopBodyStatement]
    var else_statement: [IfLoopBodyStatement]?
    var else_if_statement: [IfLoopStatement]?

    init(condition: IfCondition,
         body: [IfLoopBodyStatement],
         else_statement: [IfLoopBodyStatement]?,
         else_if_statement: [IfLoopStatement]?)
    {
        self.condition = condition
        self.body = body
        self.else_statement = else_statement
        self.else_if_statement = else_if_statement
    }
}

public enum BodyStatement {
    case LetBinding(LetBinding)
    case FunctionCall(FunctionCall)
    case If(IfStatement)
    case Loop([LoopBodyStatement])
    case Expression(Expression)
    case Return(Expression)
}

public enum IfBodyStatement {
    case LetBinding(LetBinding)
    case FunctionCall(FunctionCall)
    case If(IfStatement)
    case Loop([LoopBodyStatement])
    case Return(Expression)
}

public enum IfLoopBodyStatement {
    case LetBinding(LetBinding)
    case FunctionCall(FunctionCall)
    case IfLoop(IfLoopStatement)
    case Loop([LoopBodyStatement])
    case Return(Expression)
    case Break
    case Continue
}

public enum LoopBodyStatement {
    case LetBinding(LetBinding)
    case FunctionCall(FunctionCall)
    case IfLoop(IfLoopStatement)
    case Loop([LoopBodyStatement])
    case Return(Expression)
    case Break
    case Continue
}

public enum MainStatement {
    case Import(ImportPath)
    case Constant(Constant)
    case Types(StructTypes)
    case Function(FunctionStatement)
}

public typealias Main = [MainStatement]
