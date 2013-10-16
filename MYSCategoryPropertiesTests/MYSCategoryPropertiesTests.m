//
//  MYSCategoryPropertiesTests.m
//  MYSCategoryPropertiesTests
//
//  Created by Adam Kirk on 10/15/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Testing.h"


@interface MYSCategoryPropertiesTests : XCTestCase
@property (nonatomic, copy) NSString *testString;
@end


@implementation MYSCategoryPropertiesTests

- (void)setUp
{
    self.testString = @"This is a test";
}

- (void)testLongLongProperty
{
    self.testString.mys_longLongProperty = 234233;
    XCTAssertTrue(self.testString.mys_longLongProperty == 234233);
}

- (void)testBoolProperty
{
    self.testString.mys_boolProperty = YES;
    XCTAssertTrue(self.testString.mys_boolProperty == YES);
}

- (void)testIntegerProperty
{
    self.testString.mys_integerProperty = 2342;
    XCTAssertTrue(self.testString.mys_integerProperty == 2342);
}

- (void)testFloatProperty
{
    self.testString.mys_floatProperty = 232.3234;
    XCTAssertEqualWithAccuracy(self.testString.mys_floatProperty, 232.3234, 0.001);
}

- (void)testDoubleProperty
{
    self.testString.mys_doubleProperty = 323423.23432;
    XCTAssertEqualWithAccuracy(self.testString.mys_doubleProperty, 323423.23432, 0.0001);
}

- (void)testDateProperty
{
    NSDate *date = [NSDate date];
    self.testString.mys_dateProperty = [date copy];
    XCTAssertEqualObjects(date, self.testString.mys_dateProperty);

}

- (void)testStringProperty
{
    self.testString.mys_stringProperty = @"Test string";
    XCTAssertEqualObjects(self.testString.mys_stringProperty, @"Test string");
}

@end
