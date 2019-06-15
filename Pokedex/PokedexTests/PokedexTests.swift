//
//  PokedexTests.swift
//  PokedexTests
//
//  Created by treinamento on 15/06/19.
//  Copyright © 2019 CWI Software. All rights reserved.
//

@testable import Pokedex
import XCTest

class PokedexTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecoding() {
        let jsonUrl = Bundle(for: PokedexTests.self).url(forResource: "pokemons", withExtension: "json")!
        let data = try! Data(contentsOf: jsonUrl)
        
        XCTAssertNoThrow(try RequestMaker.decoder.decode(PokemonResponse.self, from: data))
        
    }
    
    func testRequestList() {
        let expectation = XCTestExpectation(description: "")
        let requestMaker = RequestMaker()
        requestMaker.make(withEndpoint: .list) {
            (list: PokemonList) in
            XCTAssertGreaterThan(list.pokemons.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }

    func testRequestThrowsDecodingError() {
        let expectation = XCTestExpectation(description: "")
        let requestMaker = RequestMaker()
        
        requestMaker.make(withEndpoint: .list) { (result: RequestMaker.RequestResult<Pokemon>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .decodingFailed)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }

}
