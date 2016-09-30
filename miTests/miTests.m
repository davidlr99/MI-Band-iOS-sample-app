//
//  miTests.m
//  miTests
//
//  Created by David L-R on 24/09/2016.
//  Copyright © 2016 David L-R. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface miTests : XCTestCase

@end

@implementation miTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
