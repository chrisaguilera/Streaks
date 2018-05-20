//
//  EventTableViewCell.h
//  Streaks
//
//  Created by Chris Aguilera on 11/23/17.
//  agui150@usc.edu
//  Copyright © 2017 Chris Aguilera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/Event.h"
#import "../Model/EventsModel.h"

@protocol EventTableViewCellDelegate <NSObject>
-(void)invalidLocationForCheckIn;
@end

@interface EventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *prevDeadlineLabel;


@property (strong, nonatomic) Event *event;
@property (nonatomic, strong) id <EventTableViewCellDelegate> delegate;

- (void) updateTableViewCell;

@end
