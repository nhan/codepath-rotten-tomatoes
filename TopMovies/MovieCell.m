//
//  MovieCell.m
//  TopMovies
//
//  Created by Nhan Nguyen on 3/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
