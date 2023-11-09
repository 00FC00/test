
// Plugins/GenUserDefaults/GenUserDefaults.swift
import Foundation
import PackagePlugin

@main
struct GenUserDefaults: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let tool = try context.tool(named: "GenUserDefaultsExec")
        let input = target.directory.appending(["defaults"])
        let output = context.pluginWorkDirectory
            .appending(["UserDefaultsPreferences.swift"])
        
        return [
            .buildCommand(
                displayName: "Generating UserDefaults Fields",
                executable: tool.path,
                arguments: [input.string, output.string],
                inputFiles: [input],
                outputFiles: [output])
        ]
    }
}
