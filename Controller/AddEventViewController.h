//
//  AddEventViewController.h
//  Streaks
//
//  Created by Chris Aguilera on 11/24/17.
//  agui150@usc.edu
//  Copyright © 2017 Chris Aguilera. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddEventViewControllerCompletionHandler)(void);

@interface AddEventViewController : UIViewController

@property (copy,nonatomic) AddEventViewControllerCompletionHandler completionHandler;

@end
