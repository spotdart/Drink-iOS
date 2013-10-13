//
//  DropViewController.m
//  Drink5
//
//  Created by henry brown on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DropViewController.h"

@implementation DropViewController
@synthesize itemIcon;
@synthesize statusSpinner;
@synthesize statusField;
@synthesize nameLabel;

@synthesize drinkName;

@synthesize dropSource;

@synthesize slotToDrop;

- (IBAction)drop:(id)sender {
    [statusSpinner startAnimating];
    statusField.textColor = [UIColor blackColor];
    statusField.text = @"dispensing...";
    [dropSource dropFromSlot:slotToDrop];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
          nameLabel.text = drinkName;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    nameLabel.text = drinkName;
    statusSpinner.hidesWhenStopped = YES;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setStatusField:nil];
    [self setStatusSpinner:nil];
    [self setItemIcon:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
