MYSCategoryProperties
=====================

Quickly add properties to categories using runtime associations. Property names **must** follow the 3 letter prefix (e.g. `mys_property`) category naming convention in order for this to work.


## Installation

In your Podfile, add this line:

    pod "MYSCategoryProperties"


## Instructions

Add properties to your header file:


    @interface NSString (Example) 
    @property (nonatomic, copy  ) NSDate    *mys_typedAt;
    @property (nonatomic, assign) NSInteger mys_firstSpaceIndex;
    @end

Import the header:

    #import <MYSCategoryProperties.h>

Add `@dynamic` for each property in your implementation file:

    @implementation NSString (Example)
    @dynamic mys_typedAt;
    @dynamic mys_firstSpaceIndex;
    ...

Call this method in `+ (void)load` (which is called on each category of a class):

    + (void)load
    {
        [MYSCategoryProperties generateGettersSettersForCategoryOnClass:self];
    }

And that's it!

You can now use the properties like normal:

    NSString *string = @"A string";
    string.mys_typedAt = [NSDate date];
    string.mys_firstSpaceIndex = 1;
    
    NSLog(@"A string: \"%@\" that was typed at %@ has a space at %d", string, string.mys_typedAt, string.mys_firstSpaceIndex);

## Contributing

Please update and run the tests before submitting a pull request. Thanks.

## Credit

Much inspiration and code taken from https://github.com/gangverk/GVUserDefaults

## Author

[Adam Kirk](https://github.com/atomkirk) ([@atomkirk](https://twitter.com/atomkirk))
