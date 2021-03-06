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
        _missedDeadline = NO;
        
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
        NSDateComponents *components = [calendar components:preservedComponents fromDate:now];
        [components setHour:23];
        [components setMinute:59];
        [components setSecond:59];
        NSDate *normalizedDate = [calendar dateFromComponents:components];
        
        if (frequency == kDaily) {
            _deadlineDate = normalizedDate;
        } else {
            _deadlineDate = [self deadlineDateForDate:normalizedDate frequency:frequency];
        }
        _prevDeadlineDate = self.deadlineDate;
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
        _missedDeadline = NO;
        
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
        NSDateComponents *components = [calendar components:preservedComponents fromDate:now];
        [components setHour:23];
        [components setMinute:59];
        [components setSecond:59];
        NSDate *normalizedDate = [calendar dateFromComponents:components];

        if (frequency == kDaily) {
            _deadlineDate = normalizedDate;
        } else {
            _deadlineDate = [self deadlineDateForDate:normalizedDate frequency:frequency];
        }
        _prevDeadlineDate = self.deadlineDate;
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
    
    // Compute new deadline
    _prevDeadlineDate = self.deadlineDate;
    _deadlineDate = [self deadlineDateForDate:self.deadlineDate frequency:self.frequency];
}

- (void) failedEvent {
    self.currentStreakLength = 0;
    self.totalNum++;
    self.completionRate = (double)self.completedNum/(double)self.totalNum;
    self.isCompleted = NO;
    
    // Compute new deadline
    _prevDeadlineDate = self.deadlineDate;
    _deadlineDate = [self deadlineDateForDate:self.deadlineDate frequency:self.frequency];
}

- (void) makeAvailableForCompletion {
    // Event is no longer completed
    self.isCompleted = NO;
    self.prevDeadlineDate = self.deadlineDate;
}

- (bool) hasDeadlineBeenReached {
    
    BOOL deadlineReached = NO;
    
    if (self.isCompleted) {
        if ([self.prevDeadlineDate timeIntervalSinceNow] < 0.0) {
            // Available to complete event for next deadline
            // NSLog(@"Prev Deadline for %@ Reached!", self.name);
            
            // Update event
            [self makeAvailableForCompletion];
            
            // Return that model has changed so view can be updated
            deadlineReached = YES;
            
        }
    } else {
        if ([self.deadlineDate timeIntervalSinceNow] < 0.0) {
            // Event deadline was missed, take appropriate action
            // NSLog(@"Missed Deadline for %@", self.name);
            
            // Update event
            [self failedEvent];
            
            // Return that model has changed so view can be updated
            deadlineReached = YES;
        }
    }
    
    return deadlineReached;
}

- (NSDate *) deadlineDateForDate:(NSDate *)date frequency:(EventFrequency)frequency {
    NSDate *deadlineDate;
    
    if (frequency == kDaily) {
        deadlineDate = [date dateByAddingTimeInterval:86400];
    } else if (frequency == kWeekly) {
        deadlineDate = [date dateByAddingTimeInterval:604800];
    } else {
        deadlineDate = [date dateByAddingTimeInterval:2592000];
    }
    
    return deadlineDate;
}

+ (NSString *) deadlineStringForDate:(NSDate *)date {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    formatter.timeZone = destinationTimeZone;
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:@"MM-dd-yyyy hh:mm:ss a"];
    
    return [formatter stringFromDate:date];
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
