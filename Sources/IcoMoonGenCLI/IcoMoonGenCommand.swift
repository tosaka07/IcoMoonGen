import ArgumentParser

public struct IcoMoonGenCommand: ParsableCommand {
    public static var configuration: CommandConfiguration = CommandConfiguration(
        commandName: "icomoongen",
        abstract: "A icon font code generator.",
        version: "0.0.2",
        shouldDisplay: true,
        subcommands: [GenerateCommand.self],
        defaultSubcommand: GenerateCommand.self)
    
    public init() {}
}
