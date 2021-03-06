//
//  EventTableViewCell.m
//  Streaks
//
//  Created by Chris Aguilera on 11/23/17.
//  agui150@usc.edu
//  Copyright © 2017 Chris Aguilera. All rights reserved.
//

#import "EventTableViewCell.h"
#import "AudioToolbox/AudioServices.h"
#import <QuartzCore/QuartzCore.h>

FOUNDATION_EXTERN void AudioServicesPlaySystemSoundWithVibration(UInt32 inSystemSoundID,id arg,NSDictionary* vibratePattern);

@interface EventTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIView *streakContainerView;

@end

@implementation EventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Visual Elements
    self.layer.cornerRadius = 5;
    [self.completeButton setImage:[UIImage imageNamed:@"check_gray.png"] forState:UIControlStateDisabled];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateTableViewCell {
    self.nameLabel.text = self.event.name;
    self.currentStreakLabel.text = [NSString stringWithFormat:@"%lu %@", (unsigned long) self.event.currentStreakLength, self.event.getEmoji];
    self.deadlineLabel.text = [Event deadlineStringForDate:self.event.deadlineDate];
    if (self.event.isCompleted) {
        [self.completeButton setEnabled:NO];
        self.prevDeadlineLabel.text = [Event deadlineStringForDate:self.event.prevDeadlineDate];
    } else {
        [self.completeButton setEnabled:YES];
        self.prevDeadlineLabel.text = @"NOW";
    }
    
}

- (IBAction)completeButtonPressed:(UIButton *)sender {
    
    if (self.event.requiresLocation) {
        
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.distanceFilter = 1.0;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
        CLLocation *currentLocation = [locationManager location];
        
        MKMapPoint currentMapPoint = MKMapPointForCoordinate(currentLocation.coordinate);
        
        // Make MKMapRect
        MKMapRect mapRect = [self MKMapRectForCoordinateRegion:self.event.coordinateRegion];
        
        BOOL inRegion = MKMapRectContainsPoint(mapRect, currentMapPoint);
        
        if(inRegion) {
            [self complete];
        } else {
            [self.delegate invalidLocationForCheckIn];
        }
        
    } else {
        [self complete];
    }
    
}

- (void) complete {
    
    // Vibrate
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    NSMutableArray* arr = [NSMutableArray array ];
    [arr addObject:[NSNumber numberWithBool:YES]];
    [arr addObject:[NSNumber numberWithInt:10]];
    [dict setObject:arr forKey:@"VibePattern"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
    AudioServicesPlaySystemSoundWithVibration(4095,nil,dict);
    
    // Update Model
    [self.event completeEvent];
    // Update View
    [self updateTableViewCell];
    
    // Save Model
    EventsModel *eventsModel = [EventsModel sharedModel];
    [eventsModel save];
}

- (MKMapRect)MKMapRectForCoordinateRegion:(MKCoordinateRegion)region
{
    MKMapPoint a = MKMapPointForCoordinate(CLLocationCoordinate2DMake(region.center.latitude + region.span.latitudeDelta / 2,
                                                                      region.center.longitude - region.span.longitudeDelta / 2));
    MKMapPoint b = MKMapPointForCoordinate(CLLocationCoordinate2DMake( region.center.latitude - region.span.latitudeDelta / 2,
                                                                      region.center.longitude + region.span.longitudeDelta / 2));
    return MKMapRectMake(MIN(a.x,b.x), MIN(a.y,b.y), ABS(a.x-b.x), ABS(a.y-b.y));
}

@end
