//
//  EventsModel.m
//  Streaks
//
//  Created by Chris Aguilera on 11/23/17.
//  agui150@usc.edu
//  Copyright © 2017 Chris Aguilera. All rights reserved.
//

#import "EventsModel.h"

@implementation EventsModel

+ (instancetype)sharedModel {
    static EventsModel *_sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (NSUInteger)numberOfEvents {
    return self.events.count;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        NSString *documentsDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filename = @"events.plist";
        _filePath = [NSString stringWithFormat:@"%@/%@", documentsDirPath, filename];
        NSLog(@"file path: %@", _filePath);
//        NSArray *eventsFromDocumentsDir = [[NSArray alloc] initWithContentsOfFile:_filePath];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM dd, yyyy"];
        NSDate *date = [dateFormatter dateFromString:@"December 09, 2017"];
        
        _events = [NSMutableArray arrayWithCapacity:5];
        
        Event *event2 = [[Event alloc] initWithName:@"Go Jogging" frequency: kWeekly];
        event2.totalNum = 50;
        event2.completedNum = 30;
        event2.currentStreakLength = 24;
        event2.bestStreakLength = 24;
        event2.completionRate = (float)event2.completedNum/(float)event2.totalNum;
        event2.deadline = [date dateByAddingTimeInterval:604800];
        
        Event *event3 = [[Event alloc] initWithName:@"Work on Streaks App" frequency: kWeekly];
        event3.totalNum = 20;
        event3.completedNum = 14;
        event3.currentStreakLength = 6;
        event3.bestStreakLength = 8;
        event3.completionRate = (float)event3.completedNum/(float)event3.totalNum;
        event3.deadline = [date dateByAddingTimeInterval:604800];
        
        [self.events addObject:event2];
        [self.events addObject:event3];
    }
    return self;
}

- (Event *)eventAtIndex: (NSUInteger)index {
    Event *event;
    if (index < self.events.count) {
        event = self.events[index];
    }
    return event;
}

- (void)removeEventAtIndex:(NSUInteger)index {
    [self.events removeObjectAtIndex:index];
    [self save];
}

- (void)addEventsObject:(Event *)event {
    [self.events addObject:event];
    [self save];
}

- (void) save {
    
//    NSMutableArray *eventDictionaries = [[NSMutableArray alloc] init];
//    for (Event *event in self.events) {
//        NSDictionary *eventDictionary = @{
//                                          @"name": event.name,
//                                          @"currentStreakLength": [NSNumber numberWithInt:event.currentStreakLength],
//                                          @"bestStreakLength": [NSNumber numberWithInt:event.bestStreakLength],
//                                          @"totalNum": [NSNumber numberWithInt:event.totalNum],
//                                          @"completedNum": [NSNumber numberWithInt:event.completedNum],
//                                          @"completionRate": [NSNumber numberWithDouble:event.completionRate],
//                                          @"interval": [NSNumber numberWithDouble:event.interval],
//                                          @"deadline": event.deadline,
//                                          @"requiresLocation": [NSNumber numberWithBool:event.requiresLocation],
//                                          @"isCompleted": [NSNumber numberWithBool:event.isCompleted],
//                                          @"eventFrequency":[NSNumber numberWithInt:event.frequency],
//                                          @"missedDeadline": [NSNumber numberWithBool:event.missedDeadline]
//                                          };
//        [eventDictionaries addObject:eventDictionary];
//    }
//    [eventDictionaries writeToFile:self.filePath atomically:YES];
    
}

@end
