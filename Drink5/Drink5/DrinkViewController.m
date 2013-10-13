//
//  DrinkViewController.m
//  Drink5
//
//  Created by henry brown on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "NSStreamAdditions.h"
#import "DrinkViewController.h"
#import "DrinkListViewController.h"
#import "DropViewController.h"


@interface DrinkViewController() <DrinkLoginSource, DrinkListSource, DropSource>
@end

@implementation DrinkViewController

BOOL suppressReset = NO;
BOOL loggedIn = NO;

NSMutableData *data;
NSInteger balance;


@synthesize connectingStatus;
@synthesize spinner;
@synthesize inputStream;
@synthesize outputStream;

LoginViewController *loginViewController;
DrinkListViewController *drinkListViewController;
DropViewController *dropViewController;

KeychainItemWrapper *keychain;

- (void)connectionError {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                      message:@"Cannot communicate with Drink"
                                                     delegate:self
                                            cancelButtonTitle:@"Disconnect"
                                            otherButtonTitles:nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    exit(1);
}

-(void) writeToServer:(NSString*)string {
    NSLog(@"%@", string);
    [outputStream write:(const uint8_t *)[string UTF8String] maxLength:[string length]];
}

- (void)loginWithName:(NSString *)userName
{
    if (![userName isEqualToString:@""]) {
        NSString *string = [NSString stringWithFormat:@"user %@", userName];
        [self writeToServer:string];
    } else {
        NSLog(@"empty call to username!");
    }
}

- (void)loginWithPass:(NSString *)password
{
    NSString *string = [NSString stringWithFormat:@"pass %@", password];
    [self writeToServer:string];
}

-(void) connectToServerUsingStream:(NSString *)urlStr portNo: (uint) portNo {
    NSInputStream *thisInputStream;
    NSOutputStream *thisOutputStream;
    NSLog(@"connecting...?");
    if (![urlStr isEqualToString:@""]) {
        [NSStream getStreamsToHostNamed:urlStr 
                                   port:portNo 
                            inputStream:&thisInputStream
                           outputStream:&thisOutputStream];
        [thisInputStream setDelegate:self];
        [thisOutputStream setDelegate:self];
        [thisInputStream scheduleInRunLoop:[NSRunLoop mainRunLoop]
                           forMode:NSDefaultRunLoopMode];
        [thisOutputStream scheduleInRunLoop:[NSRunLoop mainRunLoop]
                           forMode:NSDefaultRunLoopMode];
        [thisOutputStream open];
        [thisInputStream open];
    } 
}


- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    switch(eventCode) {
        case NSStreamEventErrorOccurred:
        {
            NSLog(@"Error Occurred");
            [self connectionError];
            connectingStatus.text = @"Can't Connect!";
            spinner.hidesWhenStopped = YES;
            [spinner stopAnimating];
            break;
        }
        case NSStreamEventHasSpaceAvailable:
        {
            outputStream = (NSOutputStream*)stream;
            NSLog(@"has space available");
            break;
        }
        case NSStreamEventHasBytesAvailable:
        {
            if (data == nil) {
                data = [[NSMutableData alloc] init];
            }
            uint8_t buf[1024];
            unsigned int len = 0;
            len = [(NSInputStream *)stream read:buf maxLength:1024];
            if (len) 
            {
                data = [[NSMutableData alloc] init];
                [data appendBytes:(const void *)buf length:len];
                int bytesRead;
                bytesRead += len;
                NSLog(@"read bytes");   
                NSString *received = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                NSLog(@"%@", received);
                
                //HANDLE RESPONSE STRINGS
                if ([received isEqualToString:@"Welcome to Big Drink\n"] && suppressReset == NO) {
                        [self performSegueWithIdentifier:@"TransitionToLogin" sender:self];
                    //connected well!
                }
                if ([received isEqualToString:@"OK:  Welcome to Big Drink\r\n"]) {
                    [self getDrinkStats];
                    [drinkListViewController setMachineName:@"Big Drink"];
                    //connected well!
                }
                if ([received isEqualToString:@"OK:  Welcome to Snack\r\n"]) {
                    [self getDrinkStats];
                    [drinkListViewController setMachineName:@"Snack"];
                    //connected well!
                }
                if ([received isEqualToString:@"OK:  Welcome to Little Drink\r\n"]) {
                    [self getDrinkStats];
                    [drinkListViewController setMachineName:@"Little Drink"];
                    //connected well!
                }
                if ([received isEqualToString:@"OK:  Dropping drink\r\n"]) {
                    dropViewController.statusField.text = @"Come and get it!";
                    dropViewController.statusField.textColor = [UIColor colorWithRed:0.0 green:.67451 blue:.113725 alpha:1.0];
                    [dropViewController.statusSpinner stopAnimating];
                    //connected well!
                }

                if ([received isEqualToString:@"ERR 407 Invalid password.\r\n"]) {
                    [loginViewController wrongPass];
                    NSLog(@"Invalid password");
                } 
                    NSError *error = NULL;	
                    NSRegularExpression *loginRegex = [NSRegularExpression regularExpressionWithPattern:@"OK: [0-9]+" options:nil error:&error];
                    NSRange rangeOfFirstMatch = [loginRegex rangeOfFirstMatchInString:received options:0 range:NSMakeRange(0, [received length])];
                    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0)))
                    {
                        if (loggedIn == NO) {
                            [loginViewController rightPass];
                        }
                        loggedIn = YES;
                        NSArray *array = [[NSArray alloc] initWithArray:[received componentsSeparatedByString:@" "]];
                        balance = [[array objectAtIndex:1] intValue];
                        [drinkListViewController setBalance:balance];
                    }
                NSRegularExpression *errorRegex = [NSRegularExpression regularExpressionWithPattern:@"ERR.*" options:nil error:&error];
                rangeOfFirstMatch = [errorRegex rangeOfFirstMatchInString:received options:0 range:NSMakeRange(0, [received length])];
                if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0)))
                {
                    dropViewController.statusField.text = received;
                    dropViewController.statusField.textColor = [UIColor redColor];
                }
                	
                //NSError *error = NULL;
                NSRegularExpression *slotRegex = [NSRegularExpression regularExpressionWithPattern:@"1 \".*" options:nil error:&error];
                rangeOfFirstMatch = [slotRegex rangeOfFirstMatchInString:received options:0 range:NSMakeRange(0, [received length])];
                    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0)))[drinkListViewController setSlotStats:received];
            }
        default:
            break;
        } break;
    }
}

- (void)resetStreams {
    suppressReset = YES;
    [self writeToServer:@"quit"];
    loggedIn = NO;
    [inputStream close];
    [outputStream close];
    [self connectToServerUsingStream:@"drink.csh.rit.edu" portNo:4242];
    //[self connectToServerUsingStream:@"drink-dev.csh.rit.edu" portNo:4242];
}

- (void)viewDidLoad
{
    self.navigationController.navigationBar.translucent = NO;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [inputStream close];
    [outputStream close];
    [spinner startAnimating];
    [self connectToServerUsingStream:@"drink.csh.rit.edu" portNo:4242];
    //[self connectToServerUsingStream:@"drink-dev.csh.rit.edu" portNo:4242];
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"noAnimationToLogin"]) {
        loginViewController = segue.destinationViewController;
        [segue.destinationViewController setLoginSource:self];
    }
    if ([segue.identifier isEqualToString:@"TransitionToLogin"]) {
        loginViewController = segue.destinationViewController;
        [segue.destinationViewController setLoginSource:self];
    }
}

- (void)getDrinkStats
{
    [self writeToServer:@"stat"];
}

- (void)getBalance:(id)sender {
    [self writeToServer:@"getbalance"];
     }

- (void)switchMachine: (NSString *)machine fromSender:(id)sender {
    [self writeToServer:[NSString stringWithFormat:@"machine %@", machine]];
    [sender setup];
}

- (void) logout {
}

- (void) loggedOut {
}

- (void)dropFromSlot:(NSInteger)slotToDrop {
   [self writeToServer:[NSString stringWithFormat:@"drop %d 0", slotToDrop]];
}

- (void)viewDidUnload {
    [self setSpinner:nil];
    [self setConnectingStatus:nil];
    [super viewDidUnload];
}
@end
