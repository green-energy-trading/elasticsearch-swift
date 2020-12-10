import XCTest
@testable import Elasticsearch

import JSON

class BulkTest: XCTestCase {
    var esClient : ESClient = ESClient()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        esClient.prefix = "test_es_"
        let host = URLComponents(string: "http://localhost:9200")!
        do {
            try esClient.addHost(host)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIndex() throws {
        struct Clone : ESIndexable {
            static var esType: String = "Clone"
            static var esIndex: ESIndex = ESIndex("clone")
            
            func serializeES(in: ESContext?) throws -> JSON {
                return JSON(["name": JSON(name), "data": JSON(data)])
            }
            var esId: String = "1"
            var name: String = "Bob"
            var data: String = "The quick brown fox jumps over the lazy dog."
        }
        do {
            let clone = Clone()
            try _ = esClient.index(clone)
        }
        catch {
            fatalError(error.localizedDescription)
        }
        
    }
}
