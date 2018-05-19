//
//  EventsModel.h
//  Streaks
//
//  Created by Chris Aguilera on 11/23/17.
//  agui150@usc.edu
//  Copyright © 2017 Chris Aguilera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@protocol EventsModelDelegate <NSObject>
- (void) modelHasChanged;
@end

@interface EventsModel : NSObject

// Public Properties
@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) id <EventsModelDelegate> viewControllerDelegate;
@property (nonatomic, strong) id <EventsModelDelegate> eventPageViewControllerDelegate;

// Public Methods
+ (instancetype) sharedModel;
- (NSUInteger) numberOfEvents;
- (Event *) eventAtIndex: (NSUInteger)index;
- (void) removeEventAtIndex: (NSUInteger) index;
- (void) addEventsObject:(Event*) event;
- (void) save;
- (void) startTimer;

@end
