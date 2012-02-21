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

@interface DrinkViewController() <DrinkLoginSource, DrinkListSource, DropSource>
@end

@implementation DrinkViewController

BOOL suppressReset = NO;

NSMutableData *data;
NSInteger balance;

@synthesize inputStream;
@synthesize outputStream;


LoginViewController *loginViewController;
DrinkListViewController *drinkListViewController;


-(void) writeToServer:(NSString*)string {
    NSLog(string);
    NSInteger bytes = [outputStream write:(const uint8_t *)[string UTF8String] maxLength:[string length]];
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
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    NSLog(@"connecting...?");
    if (![urlStr isEqualToString:@""]) {
        NSURL *website = [NSURL URLWithString:urlStr];
        [NSStream getStreamsToHostNamed:urlStr 
                                   port:portNo 
                            inputStream:&inputStream
                           outputStream:&outputStream];
        [inputStream setDelegate:self];
        [outputStream setDelegate:self];
        [inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop]
                           forMode:NSDefaultRunLoopMode];
        [outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop]
                           forMode:NSDefaultRunLoopMode];
        [outputStream open];
        [inputStream open];
    } 
}


- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    NSStreamStatus status = [stream streamStatus];
    switch(eventCode) {
        case NSStreamEventHasSpaceAvailable:
        {
            outputStream = stream;
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
                NSLog(received);
                
                //HANDLE RESPONSE STRINGS
                if ([received isEqualToString:@"Welcome to Big Drink\n"] && suppressReset == NO) {
                    [self performSegueWithIdentifier:@"TransitionToLogin" sender:self];
                    //connected well!
                }
                if ([received isEqualToString:@"OK:  Welcome to Big Drink\r\n"]) {
                    [self getDrinkStats];
                    //connected well!
                }
                if ([received isEqualToString:@"OK:  Welcome to Snack\r\n"]) {
                    [self getDrinkStats];
                    //connected well!
                }
                if ([received isEqualToString:@"OK:  Welcome to Little Drink\r\n"]) {
                    [self getDrinkStats];
                    //connected well!
                }

                if ([received isEqualToString:@"ERR 407 Invalid password.\r\n"]) {
                    [loginViewController wrongPass];
                    NSLog(@"Invalid password");
                } else {
                    NSError *error = NULL;	
                    NSRegularExpression *loginRegex = [NSRegularExpression regularExpressionWithPattern:@"OK: [0-9]+" options:nil error:&error];
                    NSRange rangeOfFirstMatch = [loginRegex rangeOfFirstMatchInString:received options:0 range:NSMakeRange(0, [received length])];
                    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0)))
                    {
                        [loginViewController rightPass];
                        NSArray *array = [[NSArray alloc] initWithArray:[received componentsSeparatedByString:@" "]];
                        balance = [[array objectAtIndex:1] intValue];
                        [drinkListViewController setBalance:balance];
                    }
                }	
                NSError *error = NULL;
                NSRegularExpression *slotRegex = [NSRegularExpression regularExpressionWithPattern:@"1 \".*" options:nil error:&error];
                NSRange rangeOfFirstMatch = [slotRegex rangeOfFirstMatchInString:received options:0 range:NSMakeRange(0, [received length])];
                    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0)))[drinkListViewController setSlotStats:received];
            }        
        } break;
    }
}

- (void)resetStreams {
    suppressReset = YES;
    [self writeToServer:@"quit"];
    [inputStream close];
    [outputStream close];
    [self connectToServerUsingStream:@"drink.csh.rit.edu" portNo:4242];
}

- (void)viewDidLoad
{
    [inputStream close];
    [outputStream close];
    [self connectToServerUsingStream:@"drink.csh.rit.edu" portNo:4242];
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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
    //[self writeToServer:@"getbalance"];
     }

- (void)switchMachine:(id)sender: (NSString *)machine {
    [self writeToServer:[NSString stringWithFormat:@"machine %@", machine]];
    [sender setup];
}

- (void)dropFromSlot:(NSInteger)slotToDrop {
   [self writeToServer:[NSString stringWithFormat:@"drop %d 0", slotToDrop]];
}
    

@end