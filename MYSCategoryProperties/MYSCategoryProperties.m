//
//  MYSCategoryProperties.m
//  MYSCategoryProperties
//
//  Created by Adam Kirk on 10/15/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSCategoryProperties.h"
#import <objc/runtime.h>


@implementation MYSCategoryProperties

enum TypeEncodings {
    Char                = 'c',
    Short               = 's',
    Int                 = 'i',
    Long                = 'l',
    LongLong            = 'q',
    UnsignedChar        = 'C',
    UnsignedShort       = 'S',
    UnsignedInt         = 'I',
    UnsignedLong        = 'L',
    UnsignedLongLong    = 'Q',
    Float               = 'f',
    Double              = 'd',
    Object              = '@'
};

void *keyForSelector(SEL selector)
{
    NSString *selectorString = NSStringFromSelector(selector);
    if ([selectorString hasPrefix:@"set"] && [selectorString hasSuffix:@":"]) {
        selectorString = [selectorString stringByReplacingOccurrencesOfString:@"set" withString:@""];
        selectorString = [selectorString stringByReplacingOccurrencesOfString:@":" withString:@""];
    }
    return (void *)[[selectorString lowercaseString] hash];
}

static long long longLongGetter(id self, SEL _cmd)
{
    NSNumber *number = objc_getAssociatedObject(self, keyForSelector(_cmd));
    return [number longLongValue];
}

static void longLongSetter(id self, SEL _cmd, long long value)
{
    objc_setAssociatedObject(self, keyForSelector(_cmd), @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static bool boolGetter(id self, SEL _cmd)
{
    NSNumber *number = objc_getAssociatedObject(self, keyForSelector(_cmd));
    return [number boolValue];
}

static void boolSetter(id self, SEL _cmd, bool value)
{
    objc_setAssociatedObject(self, keyForSelector(_cmd), @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static int integerGetter(id self, SEL _cmd)
{
    NSNumber *number = objc_getAssociatedObject(self, keyForSelector(_cmd));
    return [number intValue];
}

static void integerSetter(id self, SEL _cmd, int value)
{
    objc_setAssociatedObject(self, keyForSelector(_cmd), @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static float floatGetter(id self, SEL _cmd)
{
    NSNumber *number = objc_getAssociatedObject(self, keyForSelector(_cmd));
    return [number floatValue];
}

static void floatSetter(id self, SEL _cmd, float value)
{
    objc_setAssociatedObject(self, keyForSelector(_cmd), @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static double doubleGetter(id self, SEL _cmd)
{
    NSNumber *number = objc_getAssociatedObject(self, keyForSelector(_cmd));
    return [number doubleValue];
}

static void doubleSetter(id self, SEL _cmd, double value)
{
    objc_setAssociatedObject(self, keyForSelector(_cmd), @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static id objectGetter(id self, SEL _cmd)
{
    return objc_getAssociatedObject(self, keyForSelector(_cmd));
}

static void objectSetter(id self, SEL _cmd, id object)
{
    if ([self conformsToProtocol:@protocol(NSCopying)]) {
        objc_setAssociatedObject(self, keyForSelector(_cmd), object, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    else {
        objc_setAssociatedObject(self, keyForSelector(_cmd), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}



+ (void)generateGettersSettersForCategoryOnClass:(Class)klass
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(klass, &count);

    for (int i = 0; i < count; ++i) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        const char *attributes = property_getAttributes(property);

        // make sure this follows naming convention
        NSString *nameString = [NSString stringWithUTF8String:name];
        BOOL conformsToNamingConvention = [nameString length] > 3 && [nameString characterAtIndex:3] == '_';
        if (!conformsToNamingConvention) {
            continue;
        }

        char *getter = strstr(attributes, ",G");
        if (getter) {
            getter = strdup(getter + 2);
            getter = strsep(&getter, ",");
        } else {
            getter = strdup(name);
        }
        SEL getterSel = sel_registerName(getter);
        free(getter);

        char *setter = strstr(attributes, ",S");
        if (setter) {
            setter = strdup(setter + 2);
            setter = strsep(&setter, ",");
        } else {
            asprintf(&setter, "set%c%s:", toupper(name[0]), name + 1);
        }
        SEL setterSel = sel_registerName(setter);
        free(setter);

        IMP getterImp = NULL;
        IMP setterImp = NULL;
        char type = attributes[1];
        switch (type) {
            case Short:
            case Long:
            case LongLong:
            case UnsignedChar:
            case UnsignedShort:
            case UnsignedInt:
            case UnsignedLong:
            case UnsignedLongLong:
                getterImp = (IMP)longLongGetter;
                setterImp = (IMP)longLongSetter;
                break;

            case Char:
                getterImp = (IMP)boolGetter;
                setterImp = (IMP)boolSetter;
                break;

            case Int:
                getterImp = (IMP)integerGetter;
                setterImp = (IMP)integerSetter;
                break;

            case Float:
                getterImp = (IMP)floatGetter;
                setterImp = (IMP)floatSetter;
                break;

            case Double:
                getterImp = (IMP)doubleGetter;
                setterImp = (IMP)doubleSetter;
                break;

            case Object:
                getterImp = (IMP)objectGetter;
                setterImp = (IMP)objectSetter;
                break;

            default:
                free(properties);
                [NSException raise:NSInternalInconsistencyException format:@"Unsupported type of property \"%s\" in class %@", name, self];
                break;
        }

        char types[5];

        snprintf(types, 4, "%c@:", type);
        class_addMethod(klass, getterSel, getterImp, types);
        
        snprintf(types, 5, "v@:%c", type);
        class_addMethod(klass, setterSel, setterImp, types);
    }
    
    free(properties);
}




@end
