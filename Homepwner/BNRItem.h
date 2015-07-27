//
//  BNRItem.h
//  Homepwner
//
//  Created by Xiao Lu on 7/26/15.
//  Copyright (c) 2015 Xiao Lu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class NSManagedObject;

@interface BNRItem : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * itemKey;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic) double orderingValue;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic, retain) id thumbnail;
@property (nonatomic) int valueInDollars;
@property (nonatomic, retain) NSManagedObject *assetType;

- (void)setThumbnailFromImage:(UIImage *)image;

@end