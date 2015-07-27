//
//  BNRItemsTableViewController.m
//  Homepwner
//
//  Created by Xiao Lu on 6/14/15.
//  Copyright (c) 2015 Xiao Lu. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRItemCell.h"
#import "BNRImageStore.h"
#import "BNRImageViewController.h"
#import "BNRDetailViewController.h"

@interface BNRItemsViewController ()

<UIPopoverControllerDelegate>
@property (nonatomic, strong) UIPopoverController *imagePopover;

@end


@implementation BNRItemsViewController

- (IBAction)addNewItem:(id)sender
{
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController
                       animated:YES
                     completion:nil];
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = bbi;
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib *nib = [UINib nibWithNibName:@"BNRItemCell"
                                bundle:nil];
    
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"BNRItemCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark - Custom methods
- (NSInteger)getAllItemsCount
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (void)colorCodeCell:(BNRItemCell *)cell byValue:(int)valInt
{
    if (valInt >= 50)
        cell.valueLabel.textColor = [UIColor greenColor];
    else
        cell.valueLabel.textColor = [UIColor redColor];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getAllItemsCount] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNRItemCell"
                                                        forIndexPath:indexPath];
    
    if (indexPath.row < [self getAllItemsCount]) {
        
        // add this line so new item won't be covered by "No more items!" text
        cell.textLabel.text = @"";
    
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        
        BNRItem *item = items[indexPath.row];
        
        cell.nameLabel.text = item.itemName;
        cell.serialNumberLabel.text = item.serialNumber;
        cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];

        [self colorCodeCell:cell byValue:item.valueInDollars];
        
        cell.thumbnailView.image = item.thumbnail;
        
        __weak BNRItemCell *weakCell = cell;
        
        cell.actionBlock = ^{
            NSLog(@"Going to show image for %@", item);
            
            BNRItemCell *strongCell = weakCell;
            
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
                NSString *itemKey = item.itemKey;
                
                UIImage *img = [[BNRImageStore sharedStore] imageForKey:itemKey];
                if (!img)
                    return;
                
                CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds
                                            fromView:strongCell.thumbnailView];
                
                BNRImageViewController *ivc = [[BNRImageViewController alloc] init];
                ivc.image = img;
                
                self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
                self.imagePopover.delegate = self;
                self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
                [self.imagePopover presentPopoverFromRect:rect
                                                   inView:self.view
                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                                 animated:YES];
            }
        };
    }
    else
        cell.textLabel.text = @"No more items!";

    return cell;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        if (indexPath.row < [items count]) {
            BNRItem *item = items[indexPath.row];
            [[BNRItemStore sharedStore] removeItem:item];
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                        toIndex:destinationIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self getAllItemsCount])
        return NO;
    return YES;
}

#pragma mark - Table view delegate
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSUInteger numberOfObjects = [self getAllItemsCount];
    
    if (proposedDestinationIndexPath.row + 1 > numberOfObjects) {
        NSLog(@"HERE");
        return sourceIndexPath;
    }
    else {
        NSLog(@"count=%lu %ld", (long)[self getAllItemsCount], (long)proposedDestinationIndexPath.row);
        return proposedDestinationIndexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    
    if ([items count] <= indexPath.row) {
        // last row is "no more items"
        return;
    }
    
    BNRItem *selectedItem = items[indexPath.row];
    detailViewController.item = selectedItem;
    
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

#pragma mark - UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover = nil;
}

@end