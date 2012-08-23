//
//  FNSAppDelegate.m
//  fencester
//
//  Created by Norman Richards on 8/23/12.
//  Copyright (c) 2012 hackday. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "UAirship.h"
#import "UAPush.h"

#import "FNSAppDelegate.h"
#import "FNSFirstViewController.h"
#import "FNSSecondViewController.h"


@implementation FNSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *viewController1, *viewController2;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController1 = [[FNSFirstViewController alloc] initWithNibName:@"FNSFirstViewController_iPhone" bundle:nil];
        viewController2 = [[FNSSecondViewController alloc] initWithNibName:@"FNSSecondViewController_iPhone" bundle:nil];
    } else {
        viewController1 = [[FNSFirstViewController alloc] initWithNibName:@"FNSFirstViewController_iPad" bundle:nil];
        viewController2 = [[FNSSecondViewController alloc] initWithNibName:@"FNSSecondViewController_iPad" bundle:nil];
    }
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    
    //Init Airship launch options
    NSDictionary* takeOffOptions =
    @{
        UAirshipTakeOffOptionsLaunchOptionsKey:launchOptions ? launchOptions : @{},
        UAirshipTakeOffOptionsAirshipConfigKey: @{
            @"DEVELOPMENT_APP_KEY": @"dL3-GcxfRWCROH9Frwj7Gg",
            @"DEVELOPMENT_APP_SECRET": @"wahU43hySDKyfO8yKLcZgQ",
            @"APP_STORE_OR_AD_HOC_BUILD": @"NO",
        }
    };
    
        
    [UAirship takeOff:takeOffOptions];        
    [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert)];
    return YES;
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    NSLog(@"registered - got %@", devToken);
    [[UAPush shared] registerDeviceToken:devToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"GOT %@", userInfo);
    NSDictionary* aps = [userInfo objectForKey:@"aps"];
    
    if (aps) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"push!"
                                                        message:[aps objectForKey:@"alert"]
                                                       delegate:self
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
    [UAirship land];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [FBSession.activeSession handleOpenURL:url];
}


@end
