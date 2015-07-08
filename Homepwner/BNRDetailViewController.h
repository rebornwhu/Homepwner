//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by Xiao Lu on 6/22/15.
//  Copyright (c) 2015 Xiao Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;
@class BNRDatePickerViewController;

@interface BNRDetailViewController : UIViewController

@property (nonatomic, strong) BNRItem *item;

- (instancetype)initForNewItem:(BOOL)isNew;

@end