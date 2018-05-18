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

@interface EventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;


@property (strong, nonatomic) Event *event;

- (void) updateTableViewCell;

@end
