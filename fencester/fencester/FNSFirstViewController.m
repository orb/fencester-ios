//
//  FNSFirstViewController.m
//  fencester
//
//  Created by Norman Richards on 8/23/12.
//  Copyright (c) 2012 hackday. All rights reserved.
//

#import "FNSFirstViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#import "UAPush.h"

@interface FNSFirstViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *lastLocation;


@end

@implementation FNSFirstViewController

@synthesize nameLabel;
@synthesize locationLabel;
@synthesize locationManager = _locationManager;
@synthesize lastLocation;


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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


#pragma mark location

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"old=%@ new= %@", oldLocation, newLocation);
    
    
    self.locationLabel.text = [NSString stringWithFormat:@"[%d] %+.6f %+.6f\n",
                               [[self.locationManager monitoredRegions] count],
                      newLocation.coordinate.latitude,
                      newLocation.coordinate.longitude];
    
    
    self.lastLocation = newLocation;
}


/*
 *  locationManager:didEnterRegion:
 *
 *  Discussion:
 *    Invoked when the user enters a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    NSLog(@"ENTER %@", region);

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"EXIT"
                                                    message:region.identifier
                                                   delegate:self cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil];
    [alert show];
    
}

/*
 *  locationManager:didExitRegion:
 *
 *  Discussion:
 *    Invoked when the user exits a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    NSLog(@"EXIT %@", region);
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"ENTER"
                                                    message:region.identifier
                                                   delegate:self cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil];
    [alert show];
};


-(void) noFence {
    for (CLRegion* region in [self.locationManager monitoredRegions]) {
        [_locationManager stopMonitoringForRegion:region];        
    }
}

-(void) installFence {
    [self noFence];
    //CLLocationDegrees radius = self.locationManager.maximumRegionMonitoringDistance;
    
    CLRegion* region1 = [[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(30.265188, -97.747095)
                                                               radius:10 // meters
                                                           identifier:@"fbhack"];
    CLRegion* region2 = [[CLRegion alloc] initCircularRegionWithCenter:lastLocation.coordinate
                                                                radius:10 // meters
                                                            identifier:@"startpoint"];

    
    [self.locationManager startMonitoringForRegion:region1
                              desiredAccuracy:kCLLocationAccuracyBest];
    
    
    [self.locationManager startMonitoringForRegion:region2
                                   desiredAccuracy:kCLLocationAccuracyBest];
    
//
//    [self.locationManager startMonitoringForRegion:[[CLRegion alloc] initCircularRegionWithCenter:
//                                                                    CLLocationCoordinate2DMake(30.265300,-97.746265)
//                                                                                           radius:10 // meters
//                                                                                       identifier:@"austinjava-corner"]
//                                   desiredAccuracy:kCLLocationAccuracyBest];
//    
//    [self.locationManager startMonitoringForRegion:[[CLRegion alloc] initCircularRegionWithCenter:
//                                                    CLLocationCoordinate2DMake(30.265302,-97.746419)
//                                                                                           radius:10 // meters
//                                                                                       identifier:@""]          
//                                   desiredAccuracy:kCLLocationAccuracyBest];
//    
//    [self.locationManager startMonitoringForRegion:[[CLRegion alloc] initCircularRegionWithCenter:
//                                                    CLLocationCoordinate2DMake(30.265321,-97.746754)
//                                                                                           radius:10 // meters
//                                                                                       identifier:@"main-door"]
//                                   desiredAccuracy:kCLLocationAccuracyBest];
//    [self.locationManager startMonitoringForRegion:[[CLRegion alloc] initCircularRegionWithCenter:
//                                                    
//                                                    CLLocationCoordinate2DMake(30.265273,-97.747403)
//                                                                                           radius:10 // meters
//                                                                                       identifier:@"fns-door"]
//                                   desiredAccuracy:kCLLocationAccuracyBest];
//    [self.locationManager startMonitoringForRegion:[[CLRegion alloc] initCircularRegionWithCenter:
//                                                    
//                                                    CLLocationCoordinate2DMake(30.265184,-97.747561)
//                                                                                           radius:10 // meters
//                                                                                       identifier:@"fns-table"]
//                                   desiredAccuracy:kCLLocationAccuracyBest];
    
    
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"REGISTERED!"
                                                    message:@"WHEEE!"
                                                   delegate:self cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil];
    [alert show];
    
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
                 [self makeAirshipDevTokenOurFacebookUserID: user.id];
                 NSLog(@"user %@ %@", user.name, [user objectForKey:@"id"]);
             }
         }];
    }
}

#pragma devToken update
-(void) makeAirshipDevTokenOurFacebookUserID: (NSString*) facebookUserID
{
    [[UAPush shared] setAlias: facebookUserID];
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
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        //_locationManager.distanceFilter = 10;
        [_locationManager startUpdatingLocation];
        
        NSLog(@"START avail=%d enabled=%d", [CLLocationManager regionMonitoringAvailable], [CLLocationManager regionMonitoringEnabled]);
            
    } else {
        NSLog(@"...");
        [self installFence];
    }
    
    
    NSLog(@"I see %@", [_locationManager monitoredRegions]);


}


@end
