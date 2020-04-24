import XCTest
@testable import ZSCamera

final class ZSCameraTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ZSCamera().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
