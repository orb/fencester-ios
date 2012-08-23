//
//  FNSCheckinViewController.m
//  fencester
//
//  Created by Norman Richards on 8/23/12.
//  Copyright (c) 2012 hackday. All rights reserved.
//

#import "FNSCheckinViewController.h"
#import "FNSAppDelegate.h"

@interface FNSCheckinViewController ()
@end


@implementation FNSCheckinViewController
@synthesize locationLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Checkin", @"Checkin");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationLabel.text = [[self app] currentLocationRequest];

}

- (void)viewDidUnload
{
    [self setLocationLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
                                 
       
-(FNSAppDelegate*) app  {
    return (FNSAppDelegate*) [[UIApplication sharedApplication] delegate];
}
                                 
                                 

- (IBAction)doCheckin:(id)sender {
}
@end
