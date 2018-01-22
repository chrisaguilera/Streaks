//
//  AddEventViewController.m
//  Streaks
//
//  Created by Chris Aguilera on 11/24/17.
//  agui150@usc.edu
//  Copyright © 2017 Chris Aguilera. All rights reserved.
//

#import "AddEventViewController.h"
#import "../Model/Event.h"
#import "../Model/EventsModel.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AddEventViewController () <CLLocationManagerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) EventsModel *eventsModel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *frequencySegmentedControl;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (weak, nonatomic) IBOutlet UILabel *locationInstructionsLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self becomeFirstResponder];
    
    self.nameTextField.delegate = self;
    
    // Location Manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 1.0;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
    
    self.eventsModel = [EventsModel sharedModel];
    
    // Visual elements
    self.nameTextField.layer.cornerRadius = 5;
    
    CLLocation *currentLocation = [self.locationManager location];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 100, 100);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:NO];
    
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self.nameTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    
    NSString *name = self.nameTextField.text;
    [self.nameTextField resignFirstResponder];

    EventFrequency frequency;
    
    if ([self.frequencySegmentedControl selectedSegmentIndex] == 0) {
        frequency = kDaily;
    } else if ([self.frequencySegmentedControl selectedSegmentIndex] == 1) {
        frequency = kWeekly;
    } else {
        frequency = kMonthly;
    }
    
    Event *event;
    if ([self.locationSwitch isOn]) {
        event = [[Event alloc] initWithName:name frequency:frequency requiresLocation:YES];
        
        MKCoordinateRegion coordinateRegion = MKCoordinateRegionForMapRect([self.mapView visibleMapRect]);
        event.coordinateRegion = coordinateRegion;
    } else {
     event = [[Event alloc] initWithName:name frequency:frequency];
    }
    
    [self.eventsModel addEventsObject:event];
    self.completionHandler();
}
- (IBAction)locationSwitchValueChanged:(UISwitch *)sender {
    if ([sender isOn]) {
        [self.mapView setHidden:NO];
        [self.locationInstructionsLabel setHidden:NO];
    } else {
        [self.mapView setHidden:YES];
        [self.locationInstructionsLabel setHidden:YES];
    }
}

// Location Manager Delegate
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

- (IBAction)didPressedBackground:(UIButton *)sender {
    [self.nameTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}
*/



@end
