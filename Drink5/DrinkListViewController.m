//
//  DrinkListViewController.m
//  Drink5
//
//  Created by henry brown on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DropViewController.h"
#import "DrinkListViewController.h"
#import "DrinkCell.h"

@implementation DrinkListViewController

@synthesize listSource;
@synthesize drinkName;
@synthesize drinkPrice;
@synthesize drinkQuantity;
@synthesize drinkCell;
@synthesize tableViewArray;
@synthesize tableView;

DropViewController *dropViewController;

NSString *machineName =@"Big Drink";

NSString *slotStats;
NSInteger *balance;

@synthesize drinkNames;
@synthesize drinkPrices;
@synthesize drinkQuantities;
@synthesize drinkSomethings;

- (IBAction)switchToBigDrink:(id)sender {
    machineName = @"Big Drink";
    [listSource switchMachine:self :@"d"];
}

- (IBAction)switchToLittleDrink:(id)sender {
    machineName = @"Little Drink";
    [listSource switchMachine:self :@"ld"];
}

- (IBAction)switchToSnack:(id)sender {
    machineName = @"Snack";
    [listSource switchMachine:self :@"s"];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
- (IBAction)logout:(id)sender {
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"UserInfo" ofType:@"plist"];
    NSArray *savePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *path = [NSMutableString stringWithString:[savePaths objectAtIndex:0]];
    [path appendString:@"/UserInfo.plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    [plistDict setValue:@"" forKey:@"username"];
    [plistDict setValue:@"" forKey:@"password"];
    [plistDict writeToFile:path atomically: YES];
    [listSource resetStreams];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) setBalance:(NSInteger *)balanceP {
    balance = balanceP;
    [tableView reloadData];
}

- (void)setup
{
    //NSArray *array = [[NSArray alloc] initWithObjects:@"Apple",@"Microsoft",@"Samsung",nil];
    //self.tableViewArray = array;
    [tableView reloadData];
}

- (void) setSlotStats:(NSString *)stats {
    NSLog(@"got stats");
    NSLog(stats);
    NSArray *array = [[NSArray alloc] initWithArray:[stats componentsSeparatedByString:@"\n"]];
    NSMutableArray *mutDrinkNames = [[NSMutableArray alloc] init];
    NSMutableArray *mutDrinkPrices = [[NSMutableArray alloc] init];
    NSMutableArray *mutDrinkQuantities = [[NSMutableArray alloc] init];
    NSMutableArray *mutDrinkSomethings = [[NSMutableArray alloc] init];
    for( int i = 0; i < [array count] - 2; i++) {
        NSArray *quoteArray = [[NSArray alloc] initWithArray:[[array objectAtIndex:i] componentsSeparatedByString:@"\""]];
        NSArray *tempArray = [[NSArray alloc] initWithArray:[[quoteArray objectAtIndex:2] componentsSeparatedByString:@" "]];
        [mutDrinkNames addObject:[quoteArray objectAtIndex:1]];
        [mutDrinkPrices addObject:[NSString stringWithFormat:@"%@ credits", [tempArray objectAtIndex:1]]];
        [mutDrinkQuantities addObject:[NSString stringWithFormat:@"%@ remaining",[tempArray objectAtIndex:2]]];
        [mutDrinkSomethings addObject:[tempArray objectAtIndex:3]];
         }
    drinkNames = mutDrinkNames;
    drinkPrices = mutDrinkPrices;
    drinkQuantities = mutDrinkQuantities;
    drinkSomethings = mutDrinkSomethings;
    
    NSLog(@"slot stats set");
    [self setup];
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)viewDidLoad:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.listSource getDrinkStats];
    [self.listSource getBalance:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [drinkNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)
indexPath
{
    static NSString *DrinkCellIdentifier = @"DrinkCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DrinkCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DrinkCell" owner:self options:nil];
        if ([nib count] > 0) {
            cell = self.drinkCell;
        } else {
            NSLog(@"Failed to load CustomCell nib file!");
        }
    }
    NSUInteger row = [indexPath row];
    drinkName.text = [drinkNames objectAtIndex:row];
    drinkPrice.text = [drinkPrices objectAtIndex:row];
    drinkQuantity.text = [drinkQuantities objectAtIndex:row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"TransitionToDrop" sender:self];
     NSUInteger row = [indexPath row];
    [dropViewController setDrinkName:[drinkNames objectAtIndex:row]];
    [dropViewController setSlotToDrop:row + 1];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TransitionToDrop"]) {
        dropViewController = segue.destinationViewController;
        [dropViewController setDropSource:listSource];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%@ -  %d credits", machineName, balance];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}


@end
 