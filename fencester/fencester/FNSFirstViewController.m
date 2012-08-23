//
//  FNSFirstViewController.m
//  fencester
//
//  Created by Norman Richards on 8/23/12.
//  Copyright (c) 2012 hackday. All rights reserved.
//

#import "FNSFirstViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FNSFirstViewController ()

@end

@implementation FNSFirstViewController
@synthesize nameLabel;
@synthesize locationLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setLocationLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark fbstuff



- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    NSLog(@"statechange");
    switch (state) {
        case FBSessionStateOpen: {
            //            UIViewController *topViewController =
            //            [self.navController topViewController];
            //            if ([[topViewController modalViewController]
            //                 isKindOfClass:[SCLoginViewController class]]) {
            //                [topViewController dismissModalViewControllerAnimated:YES];
            //            }
            NSLog(@"open!");
            
            [self whoami];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            //            // Once the user has logged in, we want them to
            //            // be looking at the root view.
            //            [self.navController popToRootViewControllerAnimated:NO];
            [FBSession.activeSession closeAndClearTokenInformation];
            NSLog(@"close");
            
            //            [self showLoginView];
            
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    [FBSession openActiveSessionWithPermissions:nil
                                   allowLoginUI:YES
                              completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         NSLog(@"blockyblock");
         [self sessionStateChanged:session state:state error:error];
     }];
}






-(void) whoami {
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 self.nameLabel.text = user.name;
                 NSLog(@"user %@ %@", user.name, [user objectForKey:@"id"]);
             }
         }];
    }
}

#pragma mark buttons
- (IBAction)loginAction:(id)sender {
    NSLog(@"button1");

    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"ACTIVE!");
    }
    
    [self openSession];
}

- (IBAction)locateAction:(id)sender {
    NSLog(@"button2");

}

@end
