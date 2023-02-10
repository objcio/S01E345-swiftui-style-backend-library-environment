import XCTest
import Backend

struct GreetingKey: EnvironmentKey {
    static var defaultValue: String = "Hello"
}

extension EnvironmentValues {
    var greeting: String {
        get { self[GreetingKey.self] }
        set { self[GreetingKey.self] = newValue }
    }
}

struct Greeting: Rule {
    @Environment(\.greeting) var greeting
    var rules: some Rule {
        greeting
    }
}

struct Home: Rule {
    var rules: some Rule {
        Greeting().path("greeting")
    }
}

final class EnvironmentTests: XCTestCase {
    func testUsers() throws {
        XCTAssertEqual(Greeting().run(environment: .init(request: .init(path: "/"))), Response(body: "Hello".toData))

        let rule = Greeting().environment(\.greeting, "Overridden")
        XCTAssertEqual(rule.run(environment: .init(request: .init(path: "/"))), Response(body: "Overridden".toData))

        let rule2 = Home().environment(\.greeting, "Overridden")
        XCTAssertEqual(rule2.run(environment: .init(request: .init(path: "/greeting"))), Response(body: "Overridden".toData))

    }
}
