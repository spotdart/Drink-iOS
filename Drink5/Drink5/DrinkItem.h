//
//  DrinkItem.h
//  Drink5
//
//  Created by henry brown on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrinkItem : NSObject {
    NSString *name;
    NSString *price;
    NSString *quantity;
    NSString *something;
    NSInteger row;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *quantity;
@property (nonatomic, retain) NSString *something;
@property NSInteger row;

@end
