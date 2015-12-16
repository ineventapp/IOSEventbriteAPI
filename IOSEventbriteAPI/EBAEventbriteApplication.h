//
//  EBAEventbriteApplication.h
//  InEvent
//
//  Created by Pedro Góes on 12/16/15.
//  Copyright © 2015 InEvent. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A EBAEventbriteApplication defines the application which is granted access to the users linkedin data.
 **/
@interface EBAEventbriteApplication : NSObject

/** ************************************************************************************************ **
 * @name Initializers
 ** ************************************************************************************************ **/

/**
 * The default initializer.
 * @param clientId The id which is provided by Eventbrite upon registering an application.
 * @param clientSecret The secret which is provided by Eventbrite upon registering an application.
 * @return An initialized instance.
 **/
- (id)initWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret;

/**
 * The default static initializer.
 * @param clientId The id which is provided by Eventbrite upon registering an application.
 * @param clientSecret The secret which is provided by Eventbrite upon registering an application.
 * @return An initialized instance.
 **/
+ (id)applicationWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret;

/** ************************************************************************************************ **
 * @name Attributes
 ** ************************************************************************************************ **/

/**
 * The id which is provided by Eventbrite upon registering an application.
 **/
@property(nonatomic, copy) NSString *clientId;

/**
 * The secret which is provided by Eventbrite upon registering an application.
 **/
@property(nonatomic, copy) NSString *clientSecret;

@end