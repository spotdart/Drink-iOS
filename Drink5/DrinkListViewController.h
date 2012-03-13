//
//  DrinkListViewController.h
//  Drink5
//
//  Created by henry brown on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DropViewController.h"
#import "DrinkItem.h"
#import <UIKit/UIKit.h>

@protocol DrinkListSource <DropSource>
- (void)getDrinkStats;
- (void)getBalance:(id)sender;
- (void)switchMachine:(id)sender: (NSString *)machine;
- (void)resetStreams;
- (void)loggedOut;
- (void)connectionError;
@end

@protocol logoutSource <NSObject>
- (void)logout;
@end

@interface DrinkListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *tableViewArray;
    UITableView *tableView;
    NSInteger *balance;
    UITableViewCell *drinkCell;
    NSMutableDictionary *imageNames;
    
    NSMutableArray *drinkItems;
}

@property (weak, nonatomic) IBOutlet UIImageView *drinkThumbnail;
@property (weak, nonatomic) IBOutlet UIImageView *drinkThumbnailOverlay;

@property (nonatomic, retain) NSMutableArray *drinkItems;

@property (nonatomic, retain) NSArray *tableViewArray;

@property (nonatomic, retain) IBOutlet UITableView *tableView; 

@property (nonatomic, strong) IBOutlet id <DrinkListSource> listSource;

@property (nonatomic, strong) IBOutlet id <logoutSource> logoutSource;

@property (weak, nonatomic) IBOutlet UILabel *drinkName;

@property (weak, nonatomic) IBOutlet UILabel *drinkPrice;

@property (weak, nonatomic) IBOutlet UILabel *drinkQuantity;

@property (strong, nonatomic) IBOutlet UITableViewCell *drinkCell;

- (void) setSlotStats:(NSString *)stats;

- (void) setBalance:(NSInteger *)balance;

- (void) setMachineName:(NSString *)name;

- (void) setup;
@end
