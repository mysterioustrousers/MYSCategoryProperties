//
//  MYSCategoryProperties.m
//  MYSCategoryProperties
//
//  Created by Adam Kirk on 10/15/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSCategoryProperties.h"
#import <MYSRuntime.h>


@implementation MYSCategoryProperties

+ (void)setup:(Class)klass
{
    MYSClass *mysClass = [[MYSClass alloc] initWithClass:klass];
    for (MYSProperty *property in mysClass.properties) {
        if (!property.isDynamic) continue;

        id getterBlock = nil;
        id setterBlock = nil;

        switch (property.type) {
            case MYSTypeShort:
            case MYSTypeLong:
            case MYSTypeLongLong:
            case MYSTypeUnsignedChar:
            case MYSTypeUnsignedShort:
            case MYSTypeUnsignedInt:
            case MYSTypeUnsignedLong:
            case MYSTypeUnsignedLongLong:
            {
                void *key = (void *)[property.name hash];
                getterBlock = ^long long(id self) {
                    NSNumber *number = objc_getAssociatedObject(self, key);
                    return [number longLongValue];
                };

                setterBlock = ^(id self, long long value) {
                    objc_setAssociatedObject(self, key, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                };
            }
                break;

            case MYSTypeBool:
            {
                void *key = (void *)[property.name hash];
                getterBlock = ^BOOL(id self) {
                    NSNumber *number = objc_getAssociatedObject(self, key);
                    return [number boolValue];
                };

                setterBlock = ^(id self, BOOL value) {
                    objc_setAssociatedObject(self, key, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                };
            }

            case MYSTypeChar:
            {
                void *key = (void *)[property.name hash];
                getterBlock = ^char(id self) {
                    NSNumber *number = objc_getAssociatedObject(self, key);
                    return [number charValue];
                };

                setterBlock = ^(id self, char value) {
                    objc_setAssociatedObject(self, key, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                };
            }
                break;

            case MYSTypeInt:
            {
                void *key = (void *)[property.name hash];
                getterBlock = ^int(id self) {
                    NSNumber *number = objc_getAssociatedObject(self, key);
                    return [number intValue];
                };

                setterBlock = ^(id self, int value) {
                    objc_setAssociatedObject(self, key, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                };
            }
                break;

            case MYSTypeFloat:
            {
                void *key = (void *)[property.name hash];
                getterBlock = ^float(id self) {
                    NSNumber *number = objc_getAssociatedObject(self, key);
                    return [number floatValue];
                };

                setterBlock = ^(id self, float value) {
                    objc_setAssociatedObject(self, key, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                };
            }
                break;

            case MYSTypeDouble:
            {
                void *key = (void *)[property.name hash];
                getterBlock = ^double(id self) {
                    NSNumber *number = objc_getAssociatedObject(self, key);
                    return [number doubleValue];
                };

                setterBlock = ^(id self, double value) {
                    objc_setAssociatedObject(self, key, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                };
            }
                break;

            case MYSTypeObject:
            {
                void *key = (void *)[property.name hash];
                getterBlock = ^id(id self) {
                    return objc_getAssociatedObject(self, key);
                };

                setterBlock = ^(id self, id value) {
                    if ([self conformsToProtocol:@protocol(NSCopying)]) {
                        objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
                    }
                    else {
                        objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    }
                };
            }
                break;

            default:
                [NSException raise:NSInternalInconsistencyException
                            format:@"Unsupported type of property \"%@\" in class %@", property.name, self];
                break;
        }

        MYSMethod *getter = [[MYSMethod alloc] initWithName:property.getter implementationBlock:getterBlock];
        BOOL worked = [mysClass addMethod:getter];

        if (!property.isReadOnly) {
            MYSMethod *setter = [[MYSMethod alloc] initWithName:property.setter implementationBlock:setterBlock];
            worked = [mysClass addMethod:setter];
        }
    }
}


@end
