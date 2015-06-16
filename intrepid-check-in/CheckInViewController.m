//
//  CheckInViewController.m
//  intrepid-check-in
//
//  Created by Maya Saxena on 6/16/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "CheckInViewController.h"
#import "CheckInRequestManager.h"

@interface CheckInViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLCircularRegion *intrepidRegion;
@property CLLocationCoordinate2D intrepidCoordinates;
@property (nonatomic, readwrite) CLLocationDegrees latitude;
@property (nonatomic, readwrite) CLLocationDegrees longitude;
@property BOOL hasAlreadyCheckedIn;
@property (strong) UILocalNotification *checkIn;

@end

@implementation CheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasAlreadyCheckedIn = NO;
    
    [self configureLocationManager];
    [self configureCheckInNotification];
    
    
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([region isEqual:self.intrepidRegion]) {
        if (!self.hasAlreadyCheckedIn) {
            NSLog(@"I'm here!");
            self.hasAlreadyCheckedIn = YES;
            [[UIApplication sharedApplication] presentLocalNotificationNow:self.checkIn];
        }
    }
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isEqual:self.intrepidRegion]) {
        if (self.hasAlreadyCheckedIn) {
            NSLog(@"I'm leaving!");
        }
    }
}

- (IBAction)startMonitoringPressed:(UIButton *)sender {
    [self.locationManager startMonitoringForRegion:self.intrepidRegion];
}


- (IBAction)stopMonitoringPressed:(UIButton *)sender {
    [self.locationManager stopMonitoringForRegion:self.intrepidRegion];

}


- (void) configureLocationManager {
    self.latitude = 42.367105;
    self.longitude = -71.080447;
    self.intrepidCoordinates = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    self.intrepidRegion = [[CLCircularRegion alloc]initWithCenter:self.intrepidCoordinates radius:50.0 identifier:@"Intrepid Pursuits"];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void) configureCheckInNotification {
    self.checkIn = [[UILocalNotification alloc] init];
    self.checkIn.alertBody = @"You've reached Intrepid Pursuits!";
    self.checkIn.alertAction = @"Check In";
    self.checkIn.hasAction = YES;
}

- (void) showAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"You've reached Intrepid Pursuits!"
                                                                   message:@"Tell people you're here."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Check In" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [[CheckInRequestManager sharedManager] postCheckInMessageToSlack];
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:NO completion:nil];
    
}



@end
