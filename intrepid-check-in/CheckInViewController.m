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

@end

@implementation CheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.latitude = 42.367105;
    self.longitude = -71.080447;
    self.intrepidCoordinates = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    self.intrepidRegion = [[CLCircularRegion alloc]initWithCenter:self.intrepidCoordinates radius:50.0 identifier:@"Intrepid Pursuits"];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
        NSLog(@"%f", [self.locationManager location].coordinate.latitude);
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"I'm here!");
}

- (IBAction)startMonitoringPressed:(UIButton *)sender {
    [self.locationManager startMonitoringForRegion:self.intrepidRegion];
}


@end
