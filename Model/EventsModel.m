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
        
        _events = [NSMutableArray arrayWithCapacity:5];
        
        /*
        Event *event1 = [[Event alloc] initWithName:@"Go to the Gym" frequency:0];
        event1.currentStreakLength = 5;
        event1.bestStreakLength = 9;
        event1.totalNum = 19;
        event1.completedNum = 14;
        event1.completionRate = 14.0/19.0;
        event1.requiresLocation = NO;
        event1.isCompleted = NO;
        event1.missedDeadline = NO;
        
        Event *event2 = [[Event alloc] initWithName:@"Go to Class" frequency:0];
        event2.currentStreakLength = 6;
        event2.bestStreakLength = 9;
        event2.totalNum = 20;
        event2.completedNum = 15;
        event2.completionRate = 15.0/20.0;
        event2.requiresLocation = NO;
        event2.isCompleted = YES;
        event2.missedDeadline = NO;
        
        NSDate *now = [NSDate date];
        NSDate *deadlineDate1 = [now dateByAddingTimeInterval:120];
        NSDate *prevDeadlineDate = [now dateByAddingTimeInterval:120];
        NSDate *deadlineDate2 = [now dateByAddingTimeInterval:86520];
        event1.deadlineDate = deadlineDate1;
        event2.prevDeadlineDate = prevDeadlineDate;
        event2.deadlineDate = deadlineDate2;
        
        NSLog(@"Now: %@", now);
        NSLog(@"Event 1 Deadline: %@", event1.deadlineDate);
        NSLog(@"Event 2 Prev Deadline: %@", event2.prevDeadlineDate);
        NSLog(@"Event 2 Deadline: %@", event2.deadlineDate);
        
        [self.events addObject:event1];
        [self.events addObject:event2];
        */
        
        
        // Contruct events from array
        for (NSObject *eventObject in eventsFromDocumentsDir) {

            // Get name and frequency
            NSString *name = [eventObject valueForKey:@"name"];
            EventFrequency frequency = [[eventObject valueForKey:@"eventFrequency"] integerValue];

            
            // Construct coordinateLocation
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[eventObject valueForKey:@"latitude"] doubleValue],
                                                                      [[eventObject valueForKey:@"longitude"] doubleValue]);
            MKCoordinateSpan span = MKCoordinateSpanMake([[eventObject valueForKey:@"latitudeDelta"] doubleValue],
                                                         [[eventObject valueForKey:@"longitudeDelta"] doubleValue]);
            MKCoordinateRegion coordinateRegion = {coord, span};
            
            // Create Event
            Event *event = [[Event alloc] initWithName:name frequency:frequency];
            event.currentStreakLength = [[eventObject valueForKey:@"currentStreakLength"] integerValue];
            event.bestStreakLength = [[eventObject valueForKey:@"bestStreakLength"] integerValue];
            event.totalNum = [[eventObject valueForKey:@"totalNum"] integerValue];
            event.completedNum = [[eventObject valueForKey:@"completedNum"] integerValue];
            event.completionRate = [[eventObject valueForKey:@"completionRate"] doubleValue];
            event.interval = [[eventObject valueForKey:@"interval"] integerValue];
            event.prevDeadlineDate = [eventObject valueForKey:@"prevDeadlineDate"];
            event.deadlineDate = [eventObject valueForKey:@"deadlineDate"];
            event.requiresLocation = [[eventObject valueForKey:@"requiresLocation"] boolValue];
            event.isCompleted = [[eventObject valueForKey:@"isCompleted"] boolValue];
            event.missedDeadline = [[eventObject valueForKey:@"missedDeadline"] boolValue];
            event.coordinateRegion = coordinateRegion;
            
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
                                          @"prevDeadlineDate": event.prevDeadlineDate,
                                          @"deadlineDate": event.deadlineDate,
                                          @"requiresLocation": [NSNumber numberWithBool:event.requiresLocation],
                                          @"isCompleted": [NSNumber numberWithBool:event.isCompleted],
                                          @"eventFrequency":[NSNumber numberWithInt:event.frequency],
                                          @"missedDeadline": [NSNumber numberWithBool:event.missedDeadline],
                                          @"latitude": [NSNumber numberWithFloat:event.coordinateRegion.center.latitude],
                                          @"longitude": [NSNumber numberWithFloat:event.coordinateRegion.center.longitude],
                                          @"latitudeDelta": [NSNumber numberWithFloat:event.coordinateRegion.span.latitudeDelta],
                                          @"longitudeDelta": [NSNumber numberWithFloat:event.coordinateRegion.span.longitudeDelta]
                                          };
        [eventDictionaries addObject:eventDictionary];
    }
    
    [eventDictionaries writeToFile:self.filePath atomically:YES];
    
}

- (void) startTimer {
    
    void (^timerBlock)(NSTimer *) = ^(NSTimer *timer){
        
        
        // Check deadlines for all events
        for (Event *event in self.events) {
            if ([event hasDeadlineBeenReached]) {
                
                // Notify delegates (Message from model to view controller)
                [self.viewControllerDelegate modelHasChanged];
                [self.eventPageViewControllerDelegate modelHasChanged];
                
                // Save changed model
                [self save];            }
        }
        
    };
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f repeats:YES block:timerBlock];
}

@end
