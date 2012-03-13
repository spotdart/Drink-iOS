//
//  LoginViewController.m
//  Drink5
//
//  Created by henry brown on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "DrinkListViewController.h"
#import "KeychainItemWrapper.h"


@implementation LoginViewController
@synthesize rememberMe;
@synthesize userField;
@synthesize passField;
@synthesize ErrorField;

@synthesize loginSource;

DrinkListViewController *drinkListViewController;
KeychainItemWrapper *keychain;

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

- (void)logout
{
    [keychain setObject:@"" forKey:(__bridge id)kSecAttrAccount];
    [keychain setObject:@"" forKey:(__bridge id)kSecValueData];
    [loginSource resetStreams];
    [userField becomeFirstResponder];
}

- (IBAction)login:(id)sender {
    if (rememberMe.on) 
    {
        [keychain setObject:userField.text forKey:(__bridge id)kSecAttrAccount];
        [keychain setObject:passField.text forKey:(__bridge id)kSecValueData];

    } else {
        [keychain setObject:@"" forKey:(__bridge id)kSecAttrAccount];
        [keychain setObject:@"" forKey:(__bridge id)kSecValueData];
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


- (void)viewWillAppear:(BOOL)animated
{
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"DrinkLoginData" accessGroup:nil];
    userField.text = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    passField.text = [keychain objectForKey:(__bridge id)kSecValueData];
    if (![[keychain objectForKey:(__bridge id)kSecAttrAccount] isEqualToString:@""]) {
        rememberMe.on = YES;

    } else {
        rememberMe.on = NO;
        [userField becomeFirstResponder];

        [self.navigationItem setHidesBackButton:YES animated:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    if (![[keychain objectForKey:(__bridge id)kSecAttrAccount] isEqualToString:@""]) {
        rememberMe.on = YES;
        [self.loginSource loginWithName:[keychain objectForKey:(__bridge id)kSecAttrAccount]];
        [self.loginSource loginWithPass:[keychain objectForKey:(__bridge id)kSecValueData]];
    } else {

    }

}

- (void)viewDidLoad
{
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
    if ([segue.identifier isEqualToString:@"LoggedInSuccessfully"]) {
        drinkListViewController = segue.destinationViewController;
        [segue.destinationViewController setListSource:loginSource];
        [segue.destinationViewController setLogoutSource:self];
    }
}

@end
