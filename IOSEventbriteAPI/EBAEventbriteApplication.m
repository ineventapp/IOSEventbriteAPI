//
//  EBAEventbriteApplication.m
//  InEvent
//
//  Created by Pedro Góes on 12/16/15.
//  Copyright © 2015 InEvent. All rights reserved.
//

#import "EBAEventbriteApplication.h"

@implementation EBAEventbriteApplication

- (id)initWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret {
    self = [super init];
    if (self) {
        self.clientId = clientId;
        self.clientSecret = clientSecret;
    }

    return self;
}

+ (id)applicationWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret {
    return [[self alloc] initWithClientId:clientId clientSecret:clientSecret];
}

@end