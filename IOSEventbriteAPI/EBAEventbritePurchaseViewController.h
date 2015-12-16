//
//  EBAEventbritePurchaseViewController.h
//  InEvent
//
//  Created by Pedro Góes on 12/16/15.
//  Copyright © 2015 InEvent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EBAPurchaseCallback)(void);

/**
 * View Controller subclass containing a `UIWebView` which will be used to display the Eventbrite web UI to perform the login.
 **/
@interface EBAEventbritePurchaseViewController : UIViewController

/** ************************************************************************************************ **
 * @name Initializers
 ** ************************************************************************************************ **/

/**
 * Default initializer.
 * @param ticketURL Your event url.
 * @param callback A standard block.
 * @returns An initialized instance
 **/
- (id)initWithTicketURL:(NSURL *)ticketURL callback:(EBAPurchaseCallback)callback;

@end
