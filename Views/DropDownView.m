//
//  dropDownSelectView.m
//  dropDownMenu-ObjectiveC
//
//  Created by Uber on 15/01/2018.
//  Copyright © 2018 Uber. All rights reserved.
//

#import "DropDownView.h"

@implementation DropDownView

#pragma mark - Life cycle

- (void)awakeFromNib {
    [super awakeFromNib];

    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnTitle:)];
    tapped.numberOfTapsRequired = 1;
    [self.dropDownTitle addGestureRecognizer:tapped];
}


#pragma mark - Setting view

- (void) setDropDownCellWithImage:(UIImage*) image withTitle:(NSString*) title isHiddenCheckMark:(BOOL) isHiddenCheckMark
{
    self.dropDownImage.image = image;
    self.dropDownTitle.text = title;
    [self isHiddenCheckMark:isHiddenCheckMark];
}

- (void) isHiddenCheckMark:(BOOL) isHidden
{
    self.dropDownCheckImage.hidden = isHidden;
}

#pragma mark - Helpers methods

- (BOOL) inverseBool:(BOOL) inverseVar
{
    return (inverseVar) ? NO : YES;
}

#pragma mark - Actions

-(void)tapOnTitle :(UITapGestureRecognizer*) gesture
{
    if ([gesture.view isKindOfClass:[UILabel class]]) {
        [self isHiddenCheckMark: [self inverseBool:self.dropDownCheckImage.hidden]];
    }
}


@end

