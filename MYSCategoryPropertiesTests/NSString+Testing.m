//
//  NSString+Testing.m
//  MYSCategoryProperties
//
//  Created by Adam Kirk on 10/15/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "NSString+Testing.h"
#import "MYSCategoryProperties.h"


@implementation NSString (Testing)

@dynamic mys_longLongProperty;
@dynamic mys_boolProperty;
@dynamic mys_integerProperty;
@dynamic mys_floatProperty;
@dynamic mys_doubleProperty;
@dynamic mys_dateProperty;
@dynamic mys_stringProperty;


+ (void)load
{
    [MYSCategoryProperties setup:self];
}

@end
