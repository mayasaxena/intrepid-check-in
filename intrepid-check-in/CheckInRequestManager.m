//
//  CheckInRequestManager.m
//  intrepid-check-in
//
//  Created by Maya Saxena on 6/16/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
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

- (void) postMessageToSlack:(NSString *)message withUsername:(NSString *)username {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"text": message, @"username" : username};
    
    [manager POST:@"https://hooks.slack.com/services/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" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }
     ];
}


@end
