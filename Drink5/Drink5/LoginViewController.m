//
//  LoginViewController.m
//  Drink5
//
//  Created by henry brown on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "DrinkListViewController.h"

@implementation LoginViewController
@synthesize rememberMe;
@synthesize userField;
@synthesize passField;
@synthesize ErrorField;

@synthesize loginSource;

DrinkListViewController *drinkListViewController;

- (void)rightPass;
{
    [self performSegueWithIdentifier:@"LoggedInSuccessfully" sender:self];
}

- (void)wrongPass 
{
    userField.text = @"";
    passField.text = @"";
    [userField becomeFirstResponder];
    ErrorField.text = @"try again, ya dingus";
    [loginSource resetStreams];
}

- (IBAction)login:(id)sender {
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *savePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *path = [NSMutableString stringWithString:[savePaths objectAtIndex:0]];
    [path appendString:@"/UserInfo.plist"];
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"UserInfo" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (plistDict == nil) {
        plistDict = [[NSMutableDictionary alloc] init];
    }
    
    
    if (rememberMe.on) 
    {
        [plistDict setValue:userField.text forKey:@"username"];
        [plistDict setValue:passField.text forKey:@"password"];
        [plistDict writeToFile:path atomically: YES];

    } else {
        [plistDict setValue:@"" forKey:@"username"];
        [plistDict setValue:@"" forKey:@"password"];
        [plistDict writeToFile:path atomically: YES];
    }
    [self.loginSource loginWithName:userField.text];
    [self.loginSource loginWithPass:passField.text];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
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

- (void)viewDidAppear:(BOOL)animated{
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"UserInfo" ofType:@"plist"];
    NSArray *savePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *path = [NSMutableString stringWithString:[savePaths objectAtIndex:0]];
    [path appendString:@"/UserInfo.plist"];
    
    NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    userField.text = [plistDict objectForKey:@"username"];
    passField.text = [plistDict objectForKey:@"password"];
    
    if (![[plistDict objectForKey:@"username"] isEqualToString:@""]) {
        rememberMe.on = YES;
        [self.loginSource loginWithName:userField.text];
        [self.loginSource loginWithPass:passField.text];
    } else {
                rememberMe.on = NO;
    }
    //userField.text = @"";
    //passField.text = @"";
    [userField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    ErrorField.text = @"";
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setRememberMe:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //userField.text = @"";
    //passField.text = @"";
    if ([segue.identifier isEqualToString:@"LoggedInSuccessfully"]) {
        drinkListViewController = segue.destinationViewController;
        [segue.destinationViewController setListSource:loginSource];
    }
}

@end
