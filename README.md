
# DropDownMenu-ObjectiveC


This library allows you to make drop-down menu in ios.

In this project, several examples of interaction with the library MKDropdownMenu.
The project added a custom cell (DropDownView) with possibility to set a Checkmark.




| Shutdown  menu| Opened menu   |
| ------------- |:-------------:|
|![alt text](https://raw.githubusercontent.com/m1a7/dropDownMenu-ObjectiveC/master/ScreenForGitHub/screen_1.png)    | ![alt text](https://raw.githubusercontent.com/m1a7/dropDownMenu-ObjectiveC/master/ScreenForGitHub/screen_2.png)| $1600 |

<br>
<br>

## Step by step


### 1. Subscribe protocols

```objectivec
@interface ViewController () <MKDropdownMenuDataSource, MKDropdownMenuDelegate>
...
@end
```
<br><br>


### 2. Add these property

```objectivec

@interface ViewController () <MKDropdownMenuDataSource, MKDropdownMenuDelegate>

/*
The itself menu
*/
@property (strong, nonatomic) MKDropdownMenu*     dropdownMenu;                   

/*
From this array to get the data to fill the menu.
*/
@property (strong, nonatomic) NSArray<NSString*>* arrayForDropDownMenu;           

/*
From this array to get the image to fill the menu.
*/
@property (strong, nonatomic) NSArray<NSString*>* arrayImageForDropDownMenu;      

/*
In this property to store the index of the selected cell from the dropdown menu. 
This is done so that, when rendering the menu, the library was able to draw the checkmark.
*/
@property (strong, nonatomic) NSString*           selectCategoryFromDropdownMenu; 

/*
Here is kept pressed NSIndexPath of the cell. 
This is done so that, during rendering we can identify this menu,
because their can be many.
*/
@property (strong, nonatomic) NSIndexPath*        selectedIndexPathFromDropDownMenu;
@end
```

<br> <br>
-----





### 3. Prepare your data (arrays and other variables) for correct work of menu.

```objectivec
    self.arrayForDropDownMenu      = [NSArray arrayWithObjects:@"Photos", @"Video",  @"Articles", @"Favorites", nil];
    self.arrayImageForDropDownMenu = [NSArray arrayWithObjects:@"photo1", @"video1", @"article1", @"like1",     nil];
    
    self.selectCategoryFromDropdownMenu    = [self.arrayForDropDownMenu firstObject];
    self.selectedIndexPathFromDropDownMenu = [NSIndexPath indexPathForRow:0 inSection:0];

    // Calculate size for title in uinavigationbar
    CGSize sizeOfString = [self sizeOfString:self.selectCategoryFromDropdownMenu 
                                    withFont:[UIFont fontWithName:@"AvenirNext-Bold" size:21]];
```
<br> <br>

### 4. Initialize the menu itself and set its properties.

```objectivec
   self.dropdownMenu = [[MKDropdownMenu alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                       sizeOfString.width+specialOffset, 
                                                                       sizeOfString.height)];
    self.dropdownMenu.dataSource = self;
    self.dropdownMenu.delegate   = self;
        
    self.dropdownMenu.dropdownShowsTopRowSeparator = NO;
    self.dropdownMenu.dropdownBouncesScroll        = NO;
    self.dropdownMenu.rowSeparatorColor            = [UIColor colorWithWhite:1.0 alpha:0.2];
    self.dropdownMenu.rowTextAlignment             = NSTextAlignmentCenter;

    self.dropdownMenu.useFullScreenWidth = YES;

    // Set image for vertical arrow near NavBar Title
    UIImage *indicator = [UIImage imageNamed:@"indicator"];
    self.dropdownMenu.disclosureIndicatorImage = indicator;
```
<br> <br>

### 5. Implement "safe" adding a menu. If there is navigationBar then add to it. If not - then add on the self.view

```objectivec
if (self.navigationItem)
     self.navigationItem.titleView = self.dropdownMenu;
 else
     [self.view addSubview:self.dropdownMenu];
 ```
  <br> <br>
  
 ### 6. Add Helpers method
 
```objectivec

- (CGSize)sizeOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size];
}
```
<br> <br>


 ### 7. Implement MKDropdownMenuDataSource methods
 
 ```objectivec
// Return the number of column items in menu. // Like section in UITableView
- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu
{
   return  1;
}

// Return the number of rows in each component. // Like rows in UITableView
- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component
{
    return self.arrayForDropDownMenu.count;
}
```
<br> <br>


 ### 8. Implement MKDropdownMenuDelegate methods

 ```objectivec

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

// Return UIColor which we set in row.backgroundColor
- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [UIColor clearColor];
}

// Return UIColor which we set in state when row is touching.
- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForHighlightedRowsInComponent:(NSInteger)component {
    return [UIColor lightGrayColor];
}
 ```
<br> <br>


 ### 9.[Optional] Warning! If you want have standart cells. Realize this methods. 
  ```objectivec
   // Return NSAttributedString in rows in dropDown Menu
- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {

    NSDictionary* attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:20 weight:UIFontWeightLight],
                                 NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.arrayForDropDownMenu[row]
                                                                               attributes: attributes];
    return string;
}
 ```
<br> <br>

 ### 10.[Optional] Warning! If you want have custom cells. Realize this methods. 
  ```objectivec
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
 ```
 <br> <br>

  ### 11.[Optional] If you want capture touch from cells. Realize this methods. 
  
  ```objectivec
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
  ```


### The final ! Use and enjoy :)

