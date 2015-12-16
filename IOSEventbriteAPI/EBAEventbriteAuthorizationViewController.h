//
//  EBAEventbriteAuthorizationViewController.h
//  InEvent
//
//  Created by Pedro Góes on 12/16/15.
//  Copyright © 2015 InEvent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBAEventbriteApplication.h"

typedef void(^EBAAuthorizationCodeSuccessCallback)(NSString *code);
typedef void(^EBAAuthorizationCodeCancelCallback)(void);
typedef void(^EBAAuthorizationCodeFailureCallback)(NSError *errorReason);

/**
 * View Controller subclass containing a `UIWebView` which will be used to display the Eventbrite web UI to perform the login.
 **/
@interface EBAEventbriteAuthorizationViewController : UIViewController

/** ************************************************************************************************ **
 * @name Initializers
 ** ************************************************************************************************ **/

/**
 * Default initializer.
 * @param application A `EBAEventbriteApplication` configured instance.
 * @param success A success block.
 * @param cancel A cancel block.
 * @param failure A failure block.
 * @returns An initialized instance
 **/
- (id)initWithApplication:(EBAEventbriteApplication *)application 
	              success:(EBAAuthorizationCodeSuccessCallback)success 
				   cancel:(EBAAuthorizationCodeCancelCallback)cancel 
				  failure:(EBAAuthorizationCodeFailureCallback)failure;

@end
