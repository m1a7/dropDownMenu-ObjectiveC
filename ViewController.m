//
//  ViewController.m
//  dropDownMenu-ObjectiveC
//
//  Created by Uber on 14/01/2018.
//  Copyright © 2018 Uber. All rights reserved.
//

#import "ViewController.h"
#import <MKDropdownMenu/MKDropdownMenu.h>

// Views
#import "DropDownView.h"

#define specialOffset 30.f


////////////////////////////////////////////////////////////////////
// /*                                                      ////////
//                                                        ////////
//  In the project shown work MKDropdownMenu fraemwork.  ////////
//  by https://github.com/maxkonovalov/                 ////////
//                                                      ///////
// */                                                  ///////
/////////////////////////////////////////////////////////////


static inline void delay(NSTimeInterval delay, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

@interface ViewController () <MKDropdownMenuDataSource, MKDropdownMenuDelegate>

@property (strong, nonatomic) NSArray<NSString*>* arrayForDropDownMenu;           // Data array for drop-down menu
@property (strong, nonatomic) NSString*           selectCategoryFromDropdownMenu; // Here store result which was select in drop-down menu
@property (strong, nonatomic) MKDropdownMenu*     dropdownMenu;                   // The same drop-down menu

@property (strong, nonatomic) NSArray<NSString*>* arrayImageForDropDownMenu;         // Image data for drop-down image
@property (strong, nonatomic) NSIndexPath*        selectedIndexPathFromDropDownMenu; // This property store indexPath from touched in drop-down menu
@end

@implementation ViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.dropdownMenu closeAllComponentsAnimated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add right and left UIBarButtonItem. For slide-out menus.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"grid"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:nil];
   
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor  = [UIColor whiteColor];

    self.navigationController.navigationBar.translucent  = YES;                                                        // Set transparency in navigationBar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.32 green:0.21 blue:0.15 alpha:1.0]; // Set color navigationBar
    
    // Color,size,font for title navigationBar
    NSDictionary* titleTextAttributesDict = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                              NSFontAttributeName            : [UIFont fontWithName:@"AvenirNext-Bold" size:21]};
    [self.navigationController.navigationBar setTitleTextAttributes: titleTextAttributesDict];
    
    
    // Arrays from which drop-down menu will get data
    self.arrayForDropDownMenu      = [NSArray arrayWithObjects:@"Photos", @"Video",  @"Articles", @"Favorites", nil];
    self.arrayImageForDropDownMenu = [NSArray arrayWithObjects:@"photo1", @"video1", @"article1", @"like1",     nil];
    
    // Here store result which was select in drop-down menu
    self.selectCategoryFromDropdownMenu    = [self.arrayForDropDownMenu firstObject];
    // Here store result which was touched in drop-down menu
    self.selectedIndexPathFromDropDownMenu = [NSIndexPath indexPathForRow:0 inSection:0];

    // Calculate size for title in uinavigationbar
    CGSize sizeOfString = [self sizeOfString:self.selectCategoryFromDropdownMenu withFont:[UIFont fontWithName:@"AvenirNext-Bold" size:21]];

    // Init the drop-down menu
    self.dropdownMenu = [[MKDropdownMenu alloc] initWithFrame:CGRectMake(0, 0, sizeOfString.width+specialOffset, sizeOfString.height)];
    self.dropdownMenu.dataSource = self;
    self.dropdownMenu.delegate   = self;
    self.dropdownMenu.alpha = 0.5;
    //self.dropdownMenu.backgroundDimmingOpacity     = -0.67;
    self.dropdownMenu.dropdownShowsTopRowSeparator = NO;
    self.dropdownMenu.dropdownBouncesScroll        = NO;
    self.dropdownMenu.rowSeparatorColor            = [UIColor colorWithWhite:1.0 alpha:0.2];
    self.dropdownMenu.rowTextAlignment             = NSTextAlignmentCenter;
    //self.dropdownMenu.dropdownRoundedCorners = UIRectCornerAllCorners; // You can around all rows in dropdown menu

    self.dropdownMenu.useFullScreenWidth = YES;
    //self.dropdownMenu.fullScreenInsetLeft = 10;  // You can set some offset from left side
    //self.dropdownMenu.fullScreenInsetRight = 10; // You can set some offset from right side
    
    
    UIImage *indicator = [UIImage imageNamed:@"indicator"];
    self.dropdownMenu.disclosureIndicatorImage = indicator; // Set image for vertical arrow near NavBar Title

    // If we've navigationItem, then add drop-down in it. If we don't have navigationItem, add to self.view
    if (self.navigationItem)
     self.navigationItem.titleView = self.dropdownMenu;
    else
     [self.view addSubview:self.dropdownMenu];
}

#pragma mark - Helpers methods

- (CGSize)sizeOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size];
}

#pragma mark - MKDropdownMenuDataSource

/// Return the number of column items in menu. // Like section in UITableView
- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu
{
   return  1;
}

/// Return the number of rows in each component. // Like rows in UITableView
- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component
{
    return self.arrayForDropDownMenu.count;
}

#pragma mark - MKDropdownMenuDelegate
- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component
{
    return 60;
}

// Return NSAttributedString for title in NavBar
- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component {

    return [[NSAttributedString alloc] initWithString:self.selectCategoryFromDropdownMenu
                                           attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Bold" size:21],
                                                        NSForegroundColorAttributeName: [UIColor whiteColor]}];
}


/* Uncomment this piece of code.
   If you want show standart rows from drop-downs menu

*/

/*
 // Return NSAttributedString in rows in dropDown Menu
- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {

    NSDictionary* attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:20 weight:UIFontWeightLight],
                                 NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.arrayForDropDownMenu[row]
                                                                               attributes: attributes];
    return string;
}
*/

// Return UIColor which we set in row.backgroundColor
- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [UIColor lightGrayColor];
}

// Return UIColor which we set in state when row is touching.
- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForHighlightedRowsInComponent:(NSInteger)component {
    return [UIColor darkGrayColor];
}

// Here store implemention, - our reaction on touch on row
- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
   
    self.selectCategoryFromDropdownMenu = self.arrayForDropDownMenu[row];
   __weak ViewController* bself = self;
    
    delay(0.15, ^{
        [dropdownMenu closeAllComponentsAnimated:YES];
        CGSize sizeOfString       = [bself sizeOfString:bself.selectCategoryFromDropdownMenu withFont:[UIFont fontWithName:@"AvenirNext-Bold" size:21]];
        bself.dropdownMenu.bounds =  CGRectMake(0, 0, sizeOfString.width+specialOffset, sizeOfString.height);
        bself.selectedIndexPathFromDropDownMenu = [NSIndexPath indexPathForRow:row inSection:component];
        
        [bself.dropdownMenu reloadComponent:0];
    });
}


// Return CUSTOM UIView for rows in drop-down menu
- (UIView *)dropdownMenu:(MKDropdownMenu *)dropdownMenu viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
   
    switch (component) {
        case 0: {
            DropDownView* cell = (DropDownView*)view;
            if (cell == nil || ![cell isKindOfClass:[DropDownView class]]) {
                cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DropDownView class]) owner:nil options:nil] firstObject];
            }
            BOOL isHiddenCheckMark = YES;
            if ((row==self.selectedIndexPathFromDropDownMenu.row) && (component==self.selectedIndexPathFromDropDownMenu.section))
            {
                isHiddenCheckMark = NO;
            }
                        
            [cell setDropDownCellWithImage: [UIImage imageNamed: self.arrayImageForDropDownMenu[row]]
                                 withTitle: self.arrayForDropDownMenu[row]
                          isHiddenCheckMark: isHiddenCheckMark];
            return cell;
        }
        default:
            return nil;
    }
}

@end
