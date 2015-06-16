//
//  CheckInRequestManager.m
//  intrepid-check-in
//
//  Created by Maya Saxena on 6/16/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "CheckInRequestManager.h"

@implementation CheckInRequestManager

+ (instancetype)sharedManager {
    // creates token so only one instance
    static dispatch_once_t onceToken;
    
    // object to be returned
    static id shared = nil;
    
    //Executes a block object once and only once for the lifetime of an application
    dispatch_once(&onceToken, ^{
        shared = [CheckInRequestManager new];
    });
    return shared;
}

- (void) postCheckInMessageToSlack {
    
}

@end
