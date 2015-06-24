//
//  BNRDatePickerViewController.m
//  Homepwner
//
//  Created by Xiao Lu on 6/23/15.
//  Copyright (c) 2015 Xiao Lu. All rights reserved.
//

#import "BNRDatePickerViewController.h"

@interface BNRDatePickerViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation BNRDatePickerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.datePicker setDate:self.date];
}

@end