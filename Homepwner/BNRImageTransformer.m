//
//  BNRImageTransformer.m
//  Homepwner
//
//  Created by Xiao Lu on 7/26/15.
//  Copyright (c) 2015 Xiao Lu. All rights reserved.
//

#import "BNRImageTransformer.h"
#import <UIKit/UIKit.h>

@implementation BNRImageTransformer

+ (Class)transformedValueClass
{
    return [NSDate class];
}

- (id)transformedValue:(id)value
{
    if (!value) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return  UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}

@end