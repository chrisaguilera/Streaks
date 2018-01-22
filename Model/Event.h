//
//  Event.h
//  Streaks
//
//  Created by Chris Aguilera on 11/22/17.
//  agui150@usc.edu
//  Copyright © 2017 Chris Aguilera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

typedef enum EventFrequency : NSUInteger {
    kDaily,
    kWeekly,
    kMonthly
} EventFrequency;

@interface Event : NSObject

// Public Properties
@property NSString *name;
@property NSUInteger currentStreakLength;
@property NSUInteger bestStreakLength;
@property NSUInteger totalNum;
@property NSUInteger completedNum;
@property double completionRate;
@property NSTimeInterval interval;
@property NSDate *deadline;
@property BOOL requiresLocation;
@property BOOL isCompleted;
@property EventFrequency frequency;
@property MKCoordinateRegion coordinateRegion;
@property BOOL missedDeadline;

// Public Methods
- (instancetype)initWithName:(NSString *)name frequency: (EventFrequency)frequency;
- (instancetype)initWithName:(NSString *)name frequency: (EventFrequency)frequency requiresLocation:(BOOL)requiresLocation;
- (NSString *) getEmoji;
- (void)completeEvent;

@end
