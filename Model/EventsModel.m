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
        NSArray *eventsFromDocumentsDir = [[NSArray alloc] initWithContentsOfFile:_filePath];
        
        NSLog(@"Events from Documents: %@", eventsFromDocumentsDir);
        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mm:ss a"];
//        NSDate *date = [dateFormatter dateFromString:@"05-16-2018 11:59:59 PM"];
//
//        _events = [NSMutableArray arrayWithCapacity:5];
//
//        Event *event1 = [[Event alloc] initWithName:@"Go Jogging" frequency: kDaily];
//        event1.totalNum = 50;
//        event1.completedNum = 30;
//        event1.currentStreakLength = 24;
//        event1.bestStreakLength = 24;
//        event1.completionRate = (float)event1.completedNum/(float)event1.totalNum;
//        event1.deadlineDate = [date dateByAddingTimeInterval:86400];
//
//        Event *event2 = [[Event alloc] initWithName:@"Work on Streaks App" frequency: kWeekly];
//        event2.totalNum = 20;
//        event2.completedNum = 14;
//        event2.currentStreakLength = 6;
//        event2.bestStreakLength = 8;
//        event2.completionRate = (float)event2.completedNum/(float)event2.totalNum;
//
//        [self.events addObject:event1];
//        [self.events addObject:event2];
        
        _events = [NSMutableArray arrayWithCapacity:5];

        // Contruct events from array
        for (NSObject *eventObject in eventsFromDocumentsDir) {

            NSString *name = [eventObject valueForKey:@"name"];
            EventFrequency frequency = [[eventObject valueForKey:@"eventFrequency"] integerValue];

            // Create Event
            Event *event = [[Event alloc] initWithName:name frequency:frequency];
            
            event.currentStreakLength = [[eventObject valueForKey:@"currentStreakLength"] integerValue];
            event.bestStreakLength = [[eventObject valueForKey:@"bestStreakLength"] integerValue];
            event.totalNum = [[eventObject valueForKey:@"totalNum"] integerValue];
            event.completedNum = [[eventObject valueForKey:@"completedNum"] integerValue];
            event.completionRate = [[eventObject valueForKey:@"completionRate"] doubleValue];
            event.interval = [[eventObject valueForKey:@"interval"] integerValue];
            event.deadlineDate = [eventObject valueForKey:@"deadlineDate"];
            event.requiresLocation = [[eventObject valueForKey:@"requiresLocation"] integerValue];
            event.isCompleted = [[eventObject valueForKey:@"isCompleted"] integerValue];
            event.missedDeadline = [[eventObject valueForKey:@"missedDeadline"] integerValue];

            // Add Event to events
            [self.events addObject:event];
        }
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
    
    NSMutableArray *eventDictionaries = [[NSMutableArray alloc] init];
    for (Event *event in self.events) {
        NSDictionary *eventDictionary = @{
                                          @"name": event.name,
                                          @"currentStreakLength": [NSNumber numberWithInt:event.currentStreakLength],
                                          @"bestStreakLength": [NSNumber numberWithInt:event.bestStreakLength],
                                          @"totalNum": [NSNumber numberWithInt:event.totalNum],
                                          @"completedNum": [NSNumber numberWithInt:event.completedNum],
                                          @"completionRate": [NSNumber numberWithDouble:event.completionRate],
                                          @"interval": [NSNumber numberWithDouble:event.interval],
                                          @"deadlineDate": event.deadlineDate,
                                          @"requiresLocation": [NSNumber numberWithBool:event.requiresLocation],
                                          @"isCompleted": [NSNumber numberWithBool:event.isCompleted],
                                          @"eventFrequency":[NSNumber numberWithInt:event.frequency],
                                          @"missedDeadline": [NSNumber numberWithBool:event.missedDeadline]
                                          };
        [eventDictionaries addObject:eventDictionary];
    }
    [eventDictionaries writeToFile:self.filePath atomically:YES];
    
}

@end
