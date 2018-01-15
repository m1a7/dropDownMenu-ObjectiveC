//
//  dropDownSelectView.h
//  dropDownMenu-ObjectiveC
//
//  Created by Uber on 15/01/2018.
//  Copyright © 2018 Uber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *dropDownImage;
@property (weak, nonatomic) IBOutlet UILabel     *dropDownTitle;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownCheckImage;

@property (assign, nonatomic) BOOL selected;

- (void) setDropDownCellWithImage:(UIImage*) image withTitle:(NSString*) title isHiddenCheckMark:(BOOL) isHiddenCheckMark;

@end
