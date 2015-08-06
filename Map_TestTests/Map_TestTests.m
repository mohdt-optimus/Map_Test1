//
//  Map_TestTests.m
//  Map_TestTests
//
//  Created by optimusmac-12 on 06/08/15.
//  Copyright (c) 2015 mdtaha.optimus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MapViewController.h"

@interface Map_TestTests : XCTestCase
@property (nonatomic) MapViewController *map;
@end
@interface MapViewController (Test)
-(void) queryGooglePlaces: (NSString *) googleType;
@end
@implementation Map_TestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.map=[[MapViewController alloc]init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
-(void) check{
    
    
    
    
}
- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    NSString *str=@"atm";

    [self measureBlock:^{
        [self.map queryGooglePlaces:str];
        // Put the code you want to measure the time of here.
    }];
}

@end
