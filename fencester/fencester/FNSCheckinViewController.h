//
//  FNSCheckinViewController.h
//  fencester
//
//  Created by Norman Richards on 8/23/12.
//  Copyright (c) 2012 hackday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FNSCheckinViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
- (IBAction)doCheckin:(id)sender;

@end
