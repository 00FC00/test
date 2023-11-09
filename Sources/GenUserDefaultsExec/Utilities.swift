
// Sources/GenUserDefaultsExec/Utilities.swift
import Foundation

struct DefaultValue {
    var name: String
    var type: String
    var value: String?
}

extension String {
    subscript(range: NSRange) -> String {
        return String(self[Range(range, in: self)!])
    }
}

func parseSpecification(_ text: String) -> [DefaultValue] {
    let regex = try! NSRegularExpression(
        pattern: #"^\s*([_\w]+[_\d\w]+)\s+(\w[\d\w]*)\s*(.*)"#)

    return text.components(separatedBy: .newlines).compactMap { line in
        let range = NSRange(location: 0, length: line.utf16.count)

        guard let match = regex.firstMatch(in: line, range: range) else {
            return nil
        }

        let value = line[match.range(at: 3)]

        return DefaultValue(
            name: line[match.range(at: 1)],
            type: line[match.range(at: 2)],
            value: value.isEmpty ? nil : value)
    }
}

func generateCode(_ defaultValues: [DefaultValue]) -> String {
    let keys = defaultValues
        .map { "\t\tpublic static let \($0.name) = \"\($0.name)\"" }
        .joined(separator: "\n")
    let values = defaultValues.map { v in
        let defValue = v.value != nil ? " ?? \(v.value!)" : ""

        return """
        \tpublic var \(v.name): \(v.type)\(v.value == nil ? "?" : "") {
        \t\tget {
        \t\t\treturn object(forKey: .Keys.\(v.name)) as? \(v.type)\(defValue)
        \t\t}
        \t\tset {
        \t\t\tset(newValue, forKey: .Keys.\(v.name))
        \t\t}
        \t}
        """
    }.joined(separator: "\n\n")

    return """
    import Foundation\n
    extension String {\n\tpublic enum Keys {\n\(keys)\n\t}\n}\n
    extension UserDefaults {\n\(values)\n}
    """
}
