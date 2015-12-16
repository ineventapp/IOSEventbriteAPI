//
//  EBAEventbritePurchaseViewController.m
//  InEvent
//
//  Created by Pedro Góes on 12/16/15.
//  Copyright © 2015 InEvent. All rights reserved.
//

#import "EBAEventbritePurchaseViewController.h"

@interface EBAEventbritePurchaseViewController ()

@property(nonatomic, strong) UIWebView *authenticationWebView;
@property(nonatomic, copy) EBAPurchaseCallback callback;
@property(nonatomic, strong) NSURL *ticketURL;

@end

@interface EBAEventbritePurchaseViewController (UIWebViewDelegate) <UIWebViewDelegate>

@end

@implementation EBAEventbritePurchaseViewController

BOOL handlingRedirectURL;

- (id)initWithTicketURL:(NSURL *)ticketURL callback:(EBAPurchaseCallback)callback {
    self = [super init];
    if (self) {
        self.ticketURL = ticketURL;
        self.callback = callback;
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
    [self.authenticationWebView loadRequest:[NSURLRequest requestWithURL:self.ticketURL]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.authenticationWebView.frame = self.view.bounds;
}

#pragma mark UI Action Methods

- (void)tappedCancelButton:(id)sender {
    self.callback();
}

@end

@implementation EBAEventbritePurchaseViewController (UIWebViewDelegate)

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = [[request URL] absoluteString];
    
    // Prevent loading URL if it is the redirectURL
    handlingRedirectURL = !([url rangeOfString:@"eventbrite.com/orderconfirmation/"].location == NSNotFound);
    
    // Processing has finished
    if (handlingRedirectURL) {
        self.callback();
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
    
    if (!handlingRedirectURL) {
        self.callback();
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
        @"meta.setAttribute( 'content', 'width = 540px, initial-scale = 1.0, user-scalable = yes' ); "
        @"document.getElementsByTagName('head')[0].appendChild(meta)";
        
        [webView stringByEvaluatingJavaScriptFromString:js];
    }
}

@end
