//
//  NSString+Testing.h
//  MYSCategoryProperties
//
//  Created by Adam Kirk on 10/15/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Testing)
@property (nonatomic, assign) long long mys_longLongProperty;
@property (nonatomic, assign) BOOL      mys_boolProperty;
@property (nonatomic, assign) NSInteger mys_integerProperty;
@property (nonatomic, assign) float     mys_floatProperty;
@property (nonatomic, assign) double    mys_doubleProperty;
@property (nonatomic, retain) NSDate    *mys_dateProperty;
@property (nonatomic, copy  ) NSString  *mys_stringProperty;
@end
