//
//  EventPageViewController.m
//  Streaks
//
//  Created by Chris Aguilera on 11/23/17.
//  agui150@usc.edu
//  Copyright © 2017 Chris Aguilera. All rights reserved.
//

#import "EventPageViewController.h"
#import "EditEventViewController.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <QuartzCore/QuartzCore.h>

FOUNDATION_EXTERN void AudioServicesPlaySystemSoundWithVibration(UInt32 inSystemSoundID,id arg,NSDictionary* vibratePattern);

@interface EventPageViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestStreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *completionRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *bestProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *completionProgressView;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation EventPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.completeButton setImage:[UIImage imageNamed:@"check_gray.png"] forState:UIControlStateDisabled];
    
    // Location Manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 1.0;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
    
    // Visuals
    self.eventNameLabel.text = self.event.name;
    self.currentStreakLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.event.currentStreakLength];
    self.bestStreakLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.event.bestStreakLength];
    self.completionRateLabel.text = [NSString stringWithFormat:@"%.f%%", self.event.completionRate * 100];
    if (self.event.totalNum == 0) {
        [self.bestProgressView setProgress:0.0];
        [self.completionProgressView setProgress:0.0];
    } else {
        [self.bestProgressView setProgress:(float)self.event.currentStreakLength/(float)self.event.bestStreakLength];
        [self.completionProgressView setProgress:self.event.completionRate];
    }
    self.deadlineLabel.text = [self getStringForDeadline:self.event.deadline];
    
    if (self.event.isCompleted) {
        [self.completeButton setEnabled:NO];
    } else {
        [self.completeButton setEnabled:YES];
    }
    if (self.event.requiresLocation) {
        [self.mapView setHidden:NO];
        [self.mapView setRegion:self.event.coordinateRegion];
    } else {
        [self.mapView setHidden:YES];
    }
}

- (void) updateEventPage {
    // Update the visual elements of the event page
    self.eventNameLabel.text = self.event.name;
    self.currentStreakLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.event.currentStreakLength];
    self.bestStreakLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.event.bestStreakLength];
    self.completionRateLabel.text = [NSString stringWithFormat:@"%.f%%", self.event.completionRate * 100];
    if (self.event.totalNum == 0) {
        [self.bestProgressView setProgress:0.0];
        [self.completionProgressView setProgress:0.0];
    } else {
        [self.bestProgressView setProgress:(float)self.event.currentStreakLength/(float)self.event.bestStreakLength];
        [self.completionProgressView setProgress:self.event.completionRate];
    }
    self.deadlineLabel.text = [self getStringForDeadline:self.event.deadline];
    if (self.event.isCompleted) {
        [self.completeButton setEnabled:NO];
    } else {
        [self.completeButton setEnabled:YES];
    }
    
    // Update corresponding table view cell
    self.completionHandler();
}

- (IBAction)completeButtonPressed:(UIButton *)sender {
    // Determine whether the check-in requirement is met
    if (self.event.requiresLocation) {
        CLLocation *currentLocation = [self.locationManager location];
        MKMapPoint currentPoint = MKMapPointForCoordinate(currentLocation.coordinate);
        BOOL inRegion = MKMapRectContainsPoint(self.mapView.visibleMapRect, currentPoint);
        if (inRegion) {
            [self complete];
            
        } else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Check-in Required" message:@"You must be within the check-in region to complete the event." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else {
        [self complete];
    }
}

// Location Manager Delegate
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[EditEventViewController class]]) {
        EditEventViewController *eevc = segue.destinationViewController;
        eevc.event = self.event;
        eevc.completionHandler = ^(){
            [self updateEventPage];
            [self dismissViewControllerAnimated:YES completion:^{}];
        };
    }
}

- (NSString *)getStringForDeadline: (NSDate *) deadline {
    return deadline.description;
}

- (void) complete {
    // Event was completed
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    NSMutableArray* arr = [NSMutableArray array ];
    [arr addObject:[NSNumber numberWithBool:YES]];
    [arr addObject:[NSNumber numberWithInt:10]];
    [dict setObject:arr forKey:@"VibePattern"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
    AudioServicesPlaySystemSoundWithVibration(4095,nil,dict);
    
    [self.event completeEvent];
    [self updateEventPage];
}
- (IBAction)shareButtonPressed:(UIButton *)sender {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:nil];
}

@end