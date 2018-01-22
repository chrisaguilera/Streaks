//
//  Event.m
//  Streaks
//
//  Created by Chris Aguilera on 11/22/17.
//  agui150@usc.edu
//  Copyright © 2017 Chris Aguilera. All rights reserved.
//

#import "Event.h"

@implementation Event

- (instancetype)initWithName:(NSString *)name frequency:(EventFrequency)frequency {
    self = [super init];
    if (self) {
        _name = name;
        _currentStreakLength = 0;
        _bestStreakLength = 0;
        _totalNum = 0;
        _completedNum = 0;
        _completionRate = 0;
        _requiresLocation = NO;
        _isCompleted = NO;
        _frequency = frequency;
        
        NSDate *now = [NSDate date];
        if (self.frequency == kDaily) {
            _deadline = [now dateByAddingTimeInterval:86400];
        } else if (self.frequency == kWeekly) {
            _deadline = [now dateByAddingTimeInterval:604800];
        } else {
            _deadline = [now dateByAddingTimeInterval:2592000];
        }
        _missedDeadline = NO;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name frequency:(EventFrequency)frequency requiresLocation:(BOOL)requiresLocation {
    self = [super init];
    if (self) {
        _name = name;
        _currentStreakLength = 0;
        _bestStreakLength = 0;
        _totalNum = 0;
        _completedNum = 0;
        _completionRate = 0;
        _requiresLocation = requiresLocation;
        _isCompleted = NO;
        _frequency = frequency;
        
        NSDate *now = [NSDate date];
        if (self.frequency == kDaily) {
            _deadline = [now dateByAddingTimeInterval:86400];
        } else if (self.frequency == kWeekly) {
            _deadline = [now dateByAddingTimeInterval:604800];
        } else {
            _deadline = [now dateByAddingTimeInterval:2592000];
        }
        _missedDeadline = NO;
    }
    return self;
}

- (void)completeEvent {
    self.currentStreakLength++;
    if (self.currentStreakLength > self.bestStreakLength) {
        self.bestStreakLength = self.currentStreakLength;
    }
    self.totalNum++;
    self.completedNum++;
    self.completionRate = (double)self.completedNum/(double)self.totalNum;
    self.isCompleted = YES;
    // Compute deadline
    NSDate *now = [NSDate date];
    if (self.frequency == kDaily) {
        _deadline = [now dateByAddingTimeInterval:86400];
    } else if (self.frequency == kWeekly) {
        _deadline = [now dateByAddingTimeInterval:604800];
    } else {
        _deadline = [now dateByAddingTimeInterval:2592000];
    }
    
}

- (NSString * ) getEmoji {
    NSString *emoji;
    if (self.currentStreakLength < 5) {
        emoji = @"";
    } else if (self.currentStreakLength < 15) {
        emoji = @"🔥";
    } else if (self.currentStreakLength < 30) {
        emoji = @"☄️";
    } else if (self.currentStreakLength < 100){
        emoji = @"⚡️";
    } else {
        emoji = @"🌈";
    }
    return emoji;
}

@end
