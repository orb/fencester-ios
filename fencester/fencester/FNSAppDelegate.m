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
#import "FNSCheckinViewController.h"

static const int kLocationRequest = 10001;

//Private Interface declaration
@interface FNSAppDelegate ()
{
    NSData *ourDevToken;
}
@end


@implementation FNSAppDelegate

@synthesize tabBarController;
@synthesize window;
@synthesize currentLocationRequest;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *viewController1;
    UIViewController *viewController2;
    UIViewController *viewController3;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController1 = [[FNSFirstViewController alloc] initWithNibName:@"FNSFirstViewController_iPhone" bundle:nil];
        viewController2 = [[FNSSecondViewController alloc] initWithNibName:@"FNSSecondViewController_iPhone" bundle:nil];
        viewController3 = [[FNSCheckinViewController alloc] initWithNibName:@"FNSCheckinViewController_iPhone" bundle:nil];
    } else {
        viewController1 = [[FNSFirstViewController alloc] initWithNibName:@"FNSFirstViewController_iPad" bundle:nil];
        viewController2 = [[FNSSecondViewController alloc] initWithNibName:@"FNSSecongController_iPad" bundle:nil];
        viewController3 = [[FNSCheckinViewController alloc] initWithNibName:@"FNSCheckinViewController_iPad" bundle:nil];
    }
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1,
                                                                      viewController2,
                                                                      viewController3,
                                                                      nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    
    //Config Dictionarys
    NSMutableDictionary *takeOffOptions = [NSMutableDictionary new];
    NSMutableDictionary *airshiptOptionsConfigKey = [NSMutableDictionary new];
    
    //airship configs
    [airshiptOptionsConfigKey setValue: @"dL3-GcxfRWCROH9Frwj7Gg" forKey: @"DEVELOPMENT_APP_KEY"];
    [airshiptOptionsConfigKey setValue: @"wahU43hySDKyfO8yKLcZgQ" forKey: @"DEVELOPMENT_APP_SECRET"];
    [airshiptOptionsConfigKey setValue: @"NO" forKey: @"APP_STORE_OR_AD_HOC_BUILD"];
    
    //Take off options
    [takeOffOptions setValue: [NSDictionary new] forKey: UAirshipTakeOffOptionsLaunchOptionsKey];
    [takeOffOptions setValue: airshiptOptionsConfigKey forKey: UAirshipTakeOffOptionsAirshipConfigKey];
    
        
    [UAirship takeOff:takeOffOptions];        
    [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert)];
    
    self.currentLocationRequest = @"Nowhere";
    
    return YES;
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    NSLog(@"registered - got %@", devToken);
    ourDevToken = devToken;
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
        NSString* msg = [aps objectForKey:@"alert"];
        
        NSRange locationPrefix = [msg rangeOfString:@"location:"];
        if (locationPrefix.location== 0) {
            msg = [msg stringByReplacingCharactersInRange:locationPrefix withString:@""];
            NSArray* parts = [msg componentsSeparatedByString:@"|"];
            if ([parts count] ==2) {            
                NSString* loc = [parts objectAtIndex:0];
                NSString* who = [parts objectAtIndex:1];
                            
                [self monitor:loc for:who];
                return;
            }
        }
        
        NSRange checkinPrefix = [msg rangeOfString:@"checkin:"];
        if (checkinPrefix.location== 0) {
            msg = [msg stringByReplacingCharactersInRange:checkinPrefix withString:@""];
            NSArray* parts = [msg componentsSeparatedByString:@"|"];
            if ([parts count] ==2) {
                NSString* loc = [parts objectAtIndex:0];
                NSString* who = [parts objectAtIndex:1];
                
                [self checkin:loc for:who];
                return;
            }
        }
        
    
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"unhandled message"
                                                        message:msg
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


-(void) alertView:(UIAlertView*)view clickedButtonAtIndex:(NSInteger)index {
    NSLog(@"alert");
}



-(void) checkin:(NSString*) location for:(NSString*) who {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Check in"
                                                    message: [NSString stringWithFormat:@"%@ is now at %@", who, location]
                                                   delegate:self
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void) monitor:(NSString*) location for:(NSString*) who {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Location request"
                                                    message: [NSString stringWithFormat:@"We will let %@ know when you get to %@", who, location]
                                                   delegate:self
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil];
    [alert show];
}



@end
