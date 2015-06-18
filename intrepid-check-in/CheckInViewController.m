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

@property (strong) UILocalNotification *checkInNotification;
@property (strong) UILocalNotification *checkOutNotification;
@property (strong) UILocalNotification *resetNotification;

@property (weak, nonatomic) IBOutlet UILabel *monitoringStatus;

@end

@implementation CheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasAlreadyCheckedIn = NO;
    [self configureLocationManager];
    [self configureCheckInNotification];
    [self configureCheckOutNotification];
    [self configureResetNotification];
    [self updateMonitoringStatus];
    
}


#pragma mark - Configuration functions

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
    self.checkInNotification = [[UILocalNotification alloc] init];
    self.checkInNotification.alertTitle = @"You've reached Intrepid Pursuits!";
    self.checkInNotification.alertBody = @"Tell everybody you're here";
    self.checkInNotification.alertAction = @"Check In";
    
    self.checkInNotification.hasAction = YES;
}

- (void) configureCheckOutNotification {
    self.checkOutNotification = [[UILocalNotification alloc] init];
    self.checkOutNotification.alertTitle = @"You're leaving Intrepid Pursuits!";
    self.checkOutNotification.alertBody = @"Tell everybody you're leaving";
    self.checkOutNotification.alertAction = @"Check Out";
    self.checkOutNotification.hasAction = YES;
}

- (void) configureResetNotification {
    self.resetNotification = [[UILocalNotification alloc] init];
    self.resetNotification.alertTitle = @"";
    self.resetNotification.repeatInterval = NSCalendarUnitDay;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    
    NSDate *midnightOfToday = [cal dateFromComponents:comps];
    
    self.resetNotification.fireDate = midnightOfToday;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:self.resetNotification];
    
    
}


#pragma mark - Location Manager Functions

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([region isEqual:self.intrepidRegion]) {
        [self checkIn];
    }
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isEqual:self.intrepidRegion]) {
        if (self.hasAlreadyCheckedIn) {
            NSLog(@"I'm leaving!");
            [[UIApplication sharedApplication] presentLocalNotificationNow:self.checkOutNotification];
            [self.locationManager stopMonitoringForRegion:self.intrepidRegion];
        }
    }
}


- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    if ([region isEqual:self.intrepidRegion]) {
        NSLog(@"monitoring");

        [self.locationManager requestStateForRegion:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if ([region isEqual:self.intrepidRegion] && state == CLRegionStateInside) {
        NSLog(@"determined");
        [self checkIn];
    }
}


#pragma mark - UI Actions


- (IBAction)startMonitoringPressed:(UIButton *)sender {
    [self.locationManager startMonitoringForRegion:self.intrepidRegion];
    [self updateMonitoringStatus];
}


- (IBAction)stopMonitoringPressed:(UIButton *)sender {
    [self.locationManager stopMonitoringForRegion:self.intrepidRegion];
    [self updateMonitoringStatus];

}


- (void) resetMonitoring {
    self.hasAlreadyCheckedIn = NO;
    [self.locationManager startMonitoringForRegion:self.intrepidRegion];
}


- (void) checkIn {
    if (!self.hasAlreadyCheckedIn) {
        NSLog(@"I'm here!");
        self.hasAlreadyCheckedIn = YES;
        [[UIApplication sharedApplication] presentLocalNotificationNow:self.checkInNotification];
    }
}

- (void) updateMonitoringStatus {
    if ([self.locationManager.monitoredRegions count] > 0) {
        self.monitoringStatus.text = @"Yes";
        self.monitoringStatus.textColor = [UIColor greenColor];
    } else {
        self.monitoringStatus.text = @"No";
        self.monitoringStatus.textColor = [UIColor redColor];
    }
}



#pragma mark - Alert Functions


- (void) showAlertWithTitle:(NSString *)title
                 andMessage:(NSString *)message
             andActionTitle:(NSString *)actionTitle
            andSlackMessage:(NSString *)slackMessage {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:actionTitle
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [[CheckInRequestManager sharedManager]
                                                               postMessageToSlack:slackMessage withUsername:((UITextField *)alert.textFields[0]).text];
                                                          }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter your name";
    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:NO completion:nil];
}




@end
