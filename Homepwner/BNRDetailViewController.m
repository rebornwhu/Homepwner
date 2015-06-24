//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by Xiao Lu on 6/22/15.
//  Copyright (c) 2015 Xiao Lu. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRDatePickerViewController.h"

@interface BNRDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateField;

@end

@implementation BNRDetailViewController

- (void)viewWillAppear:(BOOL)animated
{    
    BNRItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.dateField.text = [dateFormatter stringFromDate:item.dateCreated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    
    BNRItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [self.view endEditing:YES];
}

#pragma mark - Custom methods
- (void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (IBAction)changeDate:(id)sender {
    BNRDatePickerViewController *datePickerVc = [[BNRDatePickerViewController alloc] init];
    datePickerVc.item = self.item;
    [self.navigationController pushViewController:datePickerVc
                                         animated:YES];
}

@end