
// Sources/GenUserDefaultsExec/main.swift
import Foundation

func abortProgram(_ errorCode: Int32) -> Never {
    print("Usage: GenUserDefaultsExec <input spec> <output>")
    exit(errorCode)
}

let arguments = ProcessInfo().arguments

guard arguments.count > 2 else {
    abortProgram(1)
}

let (input, output) = (arguments[1], arguments[2])
let inputURL = URL(fileURLWithPath: input)
let outputURL = URL(fileURLWithPath: output)

do {
    let spec = try String(contentsOf: inputURL)
    let values = parseSpecification(spec)
    let code = generateCode(values)
    
    print("ℹ️ Generated Code")
    print(code)

    try code.write(to: outputURL, atomically: true, encoding: .utf8)
} catch {
    print(error)
    abortProgram(2)
}
