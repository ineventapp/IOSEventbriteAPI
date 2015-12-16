//
//  EBAEventbriteAuthorizationViewController.m
//  InEvent
//
//  Created by Pedro Góes on 12/16/15.
//  Copyright © 2015 InEvent. All rights reserved.
//

#import "EBAEventbriteAuthorizationViewController.h"

NSString *kEventbriteErrorDomain = @"EBAEventbriteERROR";
NSString *kEventbriteDeniedByUser = @"the+user+denied+your+request";

@interface EBAEventbriteAuthorizationViewController ()

@property(nonatomic, strong) UIWebView *authenticationWebView;
@property(nonatomic, copy) EBAAuthorizationCodeFailureCallback failureCallback;
@property(nonatomic, copy) EBAAuthorizationCodeSuccessCallback successCallback;
@property(nonatomic, copy) EBAAuthorizationCodeCancelCallback cancelCallback;
@property(nonatomic, strong) EBAEventbriteApplication *application;

@end

@interface EBAEventbriteAuthorizationViewController (UIWebViewDelegate) <UIWebViewDelegate>

@end

@implementation EBAEventbriteAuthorizationViewController

BOOL handlingRedirectURL;

- (id)initWithApplication:(EBAEventbriteApplication *)application success:(EBAAuthorizationCodeSuccessCallback)success cancel:(EBAAuthorizationCodeCancelCallback)cancel failure:(EBAAuthorizationCodeFailureCallback)failure {
    self = [super init];
    if (self) {
        self.application = application;
        self.successCallback = success;
        self.cancelCallback = cancel;
        self.failureCallback = failure;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef __IPHONE_7_0
    self.edgesForExtendedLayout = UIRectEdgeNone;
#endif

	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(tappedCancelButton:)];
	self.navigationItem.leftBarButtonItem = cancelButton;

    self.authenticationWebView = [[UIWebView alloc] init];
    self.authenticationWebView.delegate = self;
    self.authenticationWebView.scalesPageToFit = YES;
    [self.view addSubview:self.authenticationWebView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *linkedIn = [NSString stringWithFormat:@"https://www.eventbrite.com/oauth/authorize?response_type=code&client_id=%@", self.application.clientId];
    [self.authenticationWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:linkedIn]]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.authenticationWebView.frame = self.view.bounds;
}

#pragma mark UI Action Methods

- (void)tappedCancelButton:(id)sender {
    self.cancelCallback();
}

@end

@implementation EBAEventbriteAuthorizationViewController (UIWebViewDelegate)

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = [[request URL] absoluteString];

    // Prevent loading URL if it is the redirectURL
    handlingRedirectURL = ![url hasPrefix:@"https://www.eventbrite.com"];

    // Process our status codes
    if (handlingRedirectURL) {
        if ([url rangeOfString:@"error"].location != NSNotFound) {
            BOOL accessDenied = [url rangeOfString:kEventbriteDeniedByUser].location != NSNotFound;
            if (accessDenied) {
                self.cancelCallback();
            } else {
                NSString* errorDescription = [self extractGetParameter:@"error_description" fromURLString:url];
                NSError *error = [[NSError alloc] initWithDomain:kEventbriteErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: errorDescription }];
                self.failureCallback(error);
            }
        } else {
            // Extract the code from the url
            NSString *authorizationCode = [self extractGetParameter:@"code" fromURLString:url];
            self.successCallback(authorizationCode);
        }
    }
    return !handlingRedirectURL;
}

- (NSString *)extractGetParameter: (NSString *) parameterName fromURLString:(NSString *)urlString {
    NSMutableDictionary *mdQueryStrings = [[NSMutableDictionary alloc] init];
    urlString = [[urlString componentsSeparatedByString:@"?"] objectAtIndex:1];
    for (NSString *qs in [urlString componentsSeparatedByString:@"&"]) {
        [mdQueryStrings setValue:[[[[qs componentsSeparatedByString:@"="] objectAtIndex:1]
                stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                          forKey:[[qs componentsSeparatedByString:@"="] objectAtIndex:0]];
    }
    return [mdQueryStrings objectForKey:parameterName];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    // Turn off network activity indicator upon failure to load web view
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // In case the user hits 'Allow' before the page is fully loaded
    if (error.code == NSURLErrorCancelled) {
        return;
    }

    // Abort if we are on Eventbrite's domain
    if (!handlingRedirectURL) {
        self.failureCallback(error);
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    // Turn off network activity indicator upon finishing web view load
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	/* fix for the Eventbrite Auth window - it doesn't scale right when placed into
	 a webview inside of a form sheet modal. If we transform the HTML of the page
	 a bit, and fix the viewport to 540px (the width of the form sheet), the problem
	 is solved.
	*/
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		NSString *js =
            @"var meta = document.createElement('meta'); "
            @"meta.setAttribute( 'name', 'viewport' ); "
            @"meta.setAttribute( 'content', 'width = 320px, initial-scale = 1.0, user-scalable = yes' ); "
            @"document.getElementsByTagName('head')[0].appendChild(meta)";
		
		[webView stringByEvaluatingJavaScriptFromString:js];
	}
}

@end
