//
//  DropViewController.h
//  Drink5
//
//  Created by henry brown on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DropSource
- (void)dropFromSlot:(NSInteger)slotToDrop;
@end;
@interface DropViewController : UIViewController {
    NSString *drinkName;
    UILabel *nameLabel;
    NSInteger slotToDrop;
}
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) NSString *drinkName;

@property (nonatomic) NSInteger slotToDrop;

@property (nonatomic, strong) IBOutlet id <DropSource> dropSource;
@end
