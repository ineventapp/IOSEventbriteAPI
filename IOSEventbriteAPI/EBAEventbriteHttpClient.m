//
//  EBAEventbriteHttpClient.m
//  InEvent
//
//  Created by Pedro Góes on 12/16/15.
//  Copyright © 2015 InEvent. All rights reserved.
//

#import "EBAEventbriteHttpClient.h"
#import "EBAEventbriteAuthorizationViewController.h"
#import "EBAEventbritePurchaseViewController.h"

@interface EBAEventbriteHttpClient ()
@property(nonatomic, strong) EBAEventbriteApplication *application;
@property(nonatomic, weak) UIViewController *presentingViewController;
@end

@implementation EBAEventbriteHttpClient

+ (EBAEventbriteHttpClient *)clientForApplication:(EBAEventbriteApplication *)application {
    return [self clientForApplication:application presentingViewController:nil];
}

+ (EBAEventbriteHttpClient *)clientForApplication:(EBAEventbriteApplication *)application presentingViewController:viewController {
    EBAEventbriteHttpClient *client = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.eventbrite.com"]];
    client.application = application;
    client.presentingViewController = viewController;
    return client;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self setResponseSerializer:[AFJSONResponseSerializer serializer]];
    }
    return self;
}

- (void)getAuthorizationCode:(void (^)(NSString *))success cancel:(void (^)(void))cancel failure:(void (^)(NSError *))failure {
    EBAEventbriteAuthorizationViewController *authorizationViewController = [[EBAEventbriteAuthorizationViewController alloc] initWithApplication:self.application success:^(NSString *code) {
        [self hideAuthenticateView];
            if (success) {
                success(code);
            }
    } cancel:^{
        [self hideAuthenticateView];
            if (cancel) {
                cancel();
            }
    } failure:^(NSError *error) {
        [self hideAuthenticateView];
        if (failure) {
            failure(error);
        }
    }];
    
    [self showControllerView:authorizationViewController];
}

- (void)buyTicket:(NSString *)ticketURL callback:(void (^)(void))callback {
    EBAEventbritePurchaseViewController *authorizationViewController = [[EBAEventbritePurchaseViewController alloc] initWithTicketURL:[NSURL URLWithString:ticketURL] callback:^{
        [self hideAuthenticateView];
        if (callback) {
            callback();
        }
    }];
    
    [self showControllerView:authorizationViewController];
}

- (void)showControllerView:(UIViewController *)authorizationViewController {
    if (self.presentingViewController == nil) {
        self.presentingViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    }

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:authorizationViewController];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        nc.modalPresentationStyle = UIModalPresentationFormSheet;
    }

    [self.presentingViewController presentViewController:nc animated:YES completion:nil];
}

- (void)hideAuthenticateView {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
