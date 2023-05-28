import Foundation

/// ValueName type
public typealias ValueName = String
/// InnerType type for values
public typealias InnerType = String

/// Constant repesentation.
/// Constant can contain `name`, `type`.
public struct Constant {
    /// Constant name
    var name: String
    /// Constant type
    var inner_type: InnerType
}

/// Value repesentation.
/// Value can contain `name`, `type` and `allocatopn` status.
public struct Value {
    /// Value name
    var inner_name: ValueName
    /// Value type
    var inner_type: InnerType
    /// Memory allocation status
    var allocated: Bool
}

/// ValueBlockState is values state for specific block
///
/// - values: current block values
/// - inner_values_name: unique values set for current block and parent blocks
/// - labels: unique labels set for current block and parent blocks. Labels used for conditional operations
/// - last_register_number: last register number for current and parent blocks
/// - parent: optional parent `State`
public class ValueBlockState {
    /// Block values
    var values: [ValueName: Value]
    /// Used to keep all names in the block state as unique
    var inner_values_name: Set<ValueName>
    /// Used to keep all labels in the block state as unique.
    /// Labels used for conditional operations
    var labels: Set<String>
    /// Last regster number for current `State`
    var last_register_number: UInt64
    /// Parent `State`
    var parent: ValueBlockState?

    /// Init `State` only from parent `State` values or set `defeult`.
    public init(parent: ValueBlockState? = nil) {
        self.values = [:]
        self.inner_values_name = parent?.inner_values_name ?? []
        self.labels = parent?.labels ?? []
        self.last_register_number = parent?.last_register_number ?? 0
        self.parent = parent
    }

    /// Set `last_register_number` for current and parents `State`.
    /// Register number is always  unique for all block in function body context.
    /// All parents `State` should be updated with the same `State` value.
    public func set_register(_ last_register_number: UInt64) {
        self.last_register_number = last_register_number
        self.parent?.set_register(last_register_number)
    }

    /// Increcment `last_register_number` for current and parents `State`
    public func inc_register() {
        self.set_register(self.last_register_number + 1)
    }

    /// Set `inner_value_name` for `inner_values_name` in current and parents `State`.
    /// `inner_value_name` is unique set of inner value name for function body context.
    /// All parents `State` should be updated with the same `State` value.
    public func set_inner_value_name(_ value_name: ValueName) {
        self.inner_values_name.insert(value_name)
        self.parent?.set_inner_value_name(value_name)
    }

    /// Get value by `value_name`. If value not found in current state just find in all parents `State`.
    public func get_value(_ value_name: ValueName) -> Value? {
        self.values[value_name] ?? self.parent?.get_value(value_name)
    }

    /// Set label to current and parents `State`
    /// All parents `State` should be updated with the same `State` value.
    public func set_label(_ label: String) {
        self.labels.insert(label)
        self.parent?.set_label(label)
    }

    /// Set label to current and parents `State`.
    /// If label exist - recusevely increment it with rule:  `<label_name>.<counter>`.
    /// It mean label counter shoukd always icremented, if label exists.
    public func set_and_get_label(_ label: String) -> String {
        // Label do not exist - insert to Lables set and return
        if !self.labels.contains(label) {
            self.labels.insert(label)
            return label
        }
        // Split label to calculate labal counter
        let lbl = label.split(separator: ".")
        var new_label = ""
        if lbl.count == 2 {
            // Increment label counter
            let counter = (Int(lbl[1]) ?? 0) + 1
            // Setlabel counter
            new_label = "\(lbl[0]).\(counter)"
        } else {
            // Add .0 to labale name for future increments
            new_label = "\(lbl[0]).0"
        }
        // Check is mew label exist
        if self.labels.contains(new_label) {
            // Recalculate label with incresed label counter
            return self.set_and_get_label(new_label)
        } else {
            // Insert label to unique label state
            self.set_label(new_label)
        }
        return new_label
    }
}
