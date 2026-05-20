import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    
    func TestGetValueInRange() throws {
        let array = [1, 2, 3, 4, 5]
        let value = array[safe: 2]
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
    }
    
    func TestGetValuuOutIfRange() throws {
        let array = [1, 2, 3, 4, 5]
        let value = array[safe: 6]
        XCTAssertNil(value)
    }
}
