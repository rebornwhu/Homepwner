//
//  BNRDatePickerViewController.m
//  Homepwner
//
//  Created by Xiao Lu on 6/23/15.
//  Copyright (c) 2015 Xiao Lu. All rights reserved.
//

#import "BNRDatePickerViewController.h"
#import "BNRItem.h"

@interface BNRDatePickerViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation BNRDatePickerViewController

- (void)viewDidAppear:(BOOL)animated
{
    [self.datePicker setDate:self.item.dateCreated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    [self.item setDateCreated:[self.datePicker date]];
}

@end