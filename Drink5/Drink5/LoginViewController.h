//
//  LoginViewController.h
//  Drink5
//
//  Created by henry brown on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrinkListViewController.h"
#import "KeychainItemWrapper.h"

@protocol DrinkLoginSource <DrinkListSource>
- (void)loginWithName:(NSString *)userName;
- (void)loginWithPass:(NSString *)password;
- (void)resetStreams;
@end

@interface LoginViewController : UIViewController {
    UITextField *userField;
    UITextField *passField;
    KeychainItemWrapper *keychain;
    id <DrinkLoginSource> loginSource;
}

@property (weak, nonatomic) IBOutlet UISwitch *rememberMe;

@property (strong, nonatomic) IBOutlet UITextField *userField;

@property (strong, nonatomic) IBOutlet UITextField *passField;

@property (strong, nonatomic) IBOutlet UILabel *ErrorField;

@property (nonatomic, strong) IBOutlet id <DrinkLoginSource> loginSource;

- (void)wrongPass;
- (void)rightPass;
@end
