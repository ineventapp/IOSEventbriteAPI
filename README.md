IOSEventbriteAPI
==============

A small non intrusive library that makes it easy to authenticate and authorize against Eventbrite using OAuth.
The API uses a UIWebView to authenticate against Eventbrite.

![image](signIn.png)

If the enduser is authenticated you end up with a code that is needed to further authenticate into Eventbrite [API](https://www.eventbrite.com/developer/v3/reference/authentication/)


How To Get Started
------------------
The library can be fetched as a Pod from [cocoapods](http://cocoapods.org/?q=iosEventbriteapi)

If you aren't using Cocoapods you can always download the library and import the files from the folder IOSEventbriteAPI into your existing project.

Example Code
------------

A Eventbrite client is created using a LIAEventbriteApplication.
A LIAEventbriteApplication defines the application which is granted access to the users Eventbrite data.
``` objective-c
LIAEventbriteApplication *application = [LIAEventbriteApplication applicationWithRedirectURL:@"http://www.ancientprogramming.com/liaexample"
                                                                                  clientId:@"clientId"
                                                                              clientSecret:@"clientSecret"
                                                                                     state:@"DCEEFWF45453sdffef424"
                                                                             grantedAccess:@[@"r_fullprofile", @"r_network"]];
return [LIAEventbriteHttpClient clientForApplication:application presentingViewController:nil];
```
* clientId: The id which is provided by Eventbrite upon registering an application.
* clientSecret: The secret which is provided by Eventbrite upon registering an application.
* presentingViewController: The view controller that the UIWebView will be modally presented from.  Passing nil assumes the root view controller.

Afterwards the client can be used to retrieve an accesstoken and access the data using the Eventbrite API:
``` objective-c
- (IBAction)didTapConnectWithEventbrite:(id)sender {
  [self.client getAuthorizationCode:^(NSString *code) {
    [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
      NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
      [self requestMeWithToken:accessToken];
    }                   failure:^(NSError *error) {
      NSLog(@"Quering accessToken failed %@", error);
    }];
  }                      cancel:^{
    NSLog(@"Authorization was cancelled by user");
  }                     failure:^(NSError *error) {
    NSLog(@"Authorization failed %@", error);
  }];
}

```
The code example retrieves an access token and uses it to get userdata for the user which granted the access.
The cancel callback is executed in case the user actively declines the authorization by pressing cancel button in the UIWebView (see illustration above).
The failure callbacks is executed in case either the of the steps fails for some reason.

Example App
------------
Just run 'pods install' in the directory after your clone and you should be able to run the app afterwards


Credits
--------------------
This library was inspired on jeyben original API for LinkedIn. Since both use OAuth2, I just made some modifications to allow it to work with Eventbrite. [https://github.com/jeyben/IOSLinkedInAPI](https://github.com/jeyben/IOSLinkedInAPI)

For its initial setup and further improvments, this library is brought to you by InEvent.
