//
//  DrinkViewController.h
//  Drink5
//
//  Created by henry brown on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropViewController.h"

@interface DrinkViewController : UIViewController <NSStreamDelegate> {
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
}
@property (weak, nonatomic) IBOutlet UILabel *connectingStatus;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;

@end
