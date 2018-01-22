//
//  EditEventViewController.h
//  Streaks
//
//  Created by Chris Aguilera on 11/24/17.
//  agui150@usc.edu
//  Copyright © 2017 Chris Aguilera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/Event.h"

typedef  void(^EditEventViewControllerCompletionHandler)(void);

@interface EditEventViewController : UIViewController

@property (strong, nonatomic) Event *event;
@property (copy, nonatomic) EditEventViewControllerCompletionHandler completionHandler;

@end
