import ArgumentParser

@main
struct Compiler: ParsableCommand {
    @Option(name: [.short, .customLong("input")], help: "Input file")
    public var inputFile: String

    @Option(name: [.short, .customLong("output")], help: "Output file")
    public var outputFIle: String

    @Flag(name: .shortAndLong)
    public var verbose = false

    mutating func run() throws {
        print("Input file \(inputFile)")
    }
}
