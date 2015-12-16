//
//  EBAEventbriteHttpClient.h
//  InEvent
//
//  Created by Pedro Góes on 12/16/15.
//  Copyright © 2015 InEvent. All rights reserved.
//


#import "AFHTTPRequestOperationManager.h"

@class EBAEventbriteApplication;

/**
 * A Eventbrite client is created using a `EBAEventbriteApplication` and is the network instance that will perform all requests to the Eventbrite API.
 **/
@interface EBAEventbriteHttpClient : AFHTTPRequestOperationManager

/** ************************************************************************************************ **
 * @name Initializers
 ** ************************************************************************************************ **/

/**
 * A Eventbrite client is created using a `EBAEventbriteApplication` and is the network instance that will perform all requests to the Eventbrite API.
 * @param application A `EBAEventbriteApplication` configured instance.
 * @discussion This method calls `+clientForApplication:presentingViewController:` with presenting view controller as nil.
 **/
+ (EBAEventbriteHttpClient *)clientForApplication:(EBAEventbriteApplication *)application;

/**
 * A Eventbrite client is created using a `EBAEventbriteApplication` and is the network instance that will perform all requests to the Eventbrite API.
 * @param application A `EBAEventbriteApplication` configured instance.
 * @param viewController The view controller that the UIWebView will be modally presented from. Passing nil assumes the root view controller.
 **/
+ (EBAEventbriteHttpClient *)clientForApplication:(EBAEventbriteApplication *)application presentingViewController:viewController;

/** ************************************************************************************************ **
 * @name Methods
 ** ************************************************************************************************ **/

/**
 * Retrieves an authorization code.
 * @param success A success block.
 * @param cancel A cancel block. This block is called when the user cancels the linkedin authentication flow.
 * @param failure A failure block containing the error.
 **/
- (void)getAuthorizationCode:(void (^)(NSString *))success cancel:(void (^)(void))cancel failure:(void (^)(NSError *))failure;


/**
 * Retrieves an authorization code.
 * @param ticketURL Eventbrite ticket url.
 * @param callback A block notify the request has finished.
 **/
- (void)buyTicket:(NSString *)ticketURL success:(void (^)(void))success cancel:(void (^)(void))cancel;

@end
