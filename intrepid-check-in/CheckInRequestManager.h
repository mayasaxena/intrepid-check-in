//
//  CheckInRequestManager.h
//  intrepid-check-in
//
//  Created by Maya Saxena on 6/16/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckInRequestManager : NSObject

+ (instancetype) sharedManager;

- (void) postCheckInMessageToSlack;

@end
