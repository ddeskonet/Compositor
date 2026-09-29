// Prints which names in a list are not SF Symbols on the running system.
// Usage: swift scripts/check-symbols.swift names.txt
import AppKit

let path = CommandLine.arguments[1]
let names = try String(contentsOfFile: path, encoding: .utf8)
    .split(separator: "\n").map(String.init).filter { !$0.isEmpty }
let missing = names.filter { NSImage(systemSymbolName: $0, accessibilityDescription: nil) == nil }
print("checked \(names.count), missing \(missing.count)")
for name in missing { print(name) }
