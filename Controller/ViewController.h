//
//  ViewController.h
//  Streaks
//
//  Created by Chris Aguilera on 11/22/17.
//  agui150@usc.edu
//  Copyright © 2017 Chris Aguilera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsModel.h"
#import "../View/EventTableViewCell.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, EventsModelDelegate, EventTableViewCellDelegate>


@end

