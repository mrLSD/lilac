import Foundation
import Ast

public protocol Codegen {
    func set_struct_type(data: Ast.StructTypes)
    func set_constant(data: Ast.Constant)
    func function_declaration(data: Ast.FunctionStatement)
}
