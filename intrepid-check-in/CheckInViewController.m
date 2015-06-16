//
//  CheckInViewController.m
//  intrepid-check-in
//
//  Created by Maya Saxena on 6/16/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "CheckInViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface CheckInViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLCircularRegion *intrepidRegion;
@property CLLocationCoordinate2D intrepidCoordinates;
@property (nonatomic, readwrite) CLLocationDegrees latitude;
@property (nonatomic, readwrite) CLLocationDegrees longitude;
@property BOOL hasAlreadyCheckedIn;

@end

@implementation CheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasAlreadyCheckedIn = NO;
    
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

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([region isEqual:self.intrepidRegion] && !self.hasAlreadyCheckedIn) {
        NSLog(@"I'm here!");
        self.hasAlreadyCheckedIn = YES;
    }
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isEqual:self.intrepidRegion]) {
        NSLog(@"Goodbye!");
    }
}

- (IBAction)startMonitoringPressed:(UIButton *)sender {
    [self.locationManager startMonitoringForRegion:self.intrepidRegion];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
}



@end
