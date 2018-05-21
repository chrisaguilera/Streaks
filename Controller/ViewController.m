//
//  ViewController.m
//  Streaks
//
//  Created by Chris Aguilera on 11/22/17.
//  agui150@usc.edu
//  Copyright © 2017 Chris Aguilera. All rights reserved.
//

#import "ViewController.h"
#import "../Model/Event.h"
#import "../Model/EventsModel.h"
#import "../View/EventTableViewCell.h"
#import "../Controller/EventPageViewController.h"
#import "../Controller/AddEventViewController.h"

@interface ViewController ()

@property (strong, nonatomic) EventsModel *eventsModel;
@property NSInteger selectedCellRow;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    self.eventsModel = [EventsModel sharedModel];
    
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:246.0f/255.0f green:77.0f/255.0f blue:93.0f/255.0f alpha:1.0];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:246.0f/255.0f green:77.0f/255.0f blue:93.0f/255.0f alpha:1.0];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    
    // EventModelDelegate
    self.eventsModel.viewControllerDelegate = self;
    
    // Check deadlines for all events on startup
    for (Event *event in self.eventsModel.events) {
        if ([event hasDeadlineBeenReached]) {
            
            [self modelHasChanged];
            
            // Save changed model
            [self.eventsModel save];
            
        }
    }
    
    [self.eventsModel startTimer];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.eventsModel numberOfEvents];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Default Cell" forIndexPath:indexPath];
    
    // Create event
    Event *event = self.eventsModel.events[indexPath.section];
    
    // Set event for table view cell
    cell.event = event;
    
    cell.nameLabel.text = event.name;
    cell.currentStreakLabel.text = [NSString stringWithFormat:@"%lu %@", (unsigned long) event.currentStreakLength, event.getEmoji];
    cell.deadlineLabel.text = [Event deadlineStringForDate:cell.event.deadlineDate];
    [cell updateTableViewCell];
    
    // Delegate
    cell.delegate = self;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.eventsModel removeEventAtIndex:indexPath.section];
        
        // Animates the deletion
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCellRow = indexPath.section;
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[EventPageViewController class]]) {
        EventPageViewController *epvc = segue.destinationViewController;
        epvc.event = self.eventsModel.events[self.selectedCellRow];
        
        // Check deadline for event when going to event page
        if ([epvc.event hasDeadlineBeenReached]) {
            
            [epvc updateEventPage];
            
            // Save changed model
            [self.eventsModel save];
            
        }
        
        epvc.completionHandler = ^(){
            [[self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:self.selectedCellRow]] updateTableViewCell];
        };
        
    } else {
        AddEventViewController *avc = segue.destinationViewController;
        avc.completionHandler = ^(){
            [self.tableView reloadData];
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        };
    }

}

#pragma mark - EventsModelDelegate

- (void) modelHasChanged {
    [self.tableView reloadData];
}

#pragma mark - EventTableViewCellDelegate

- (void)invalidLocationForCheckIn {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Check-in Required" message:@"You must be within the check-in region to complete the event." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
