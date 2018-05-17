//
//  DefaultTableViewCell.m
//  Streaks
//
//  Created by Chris Aguilera on 11/23/17.
//  Copyright © 2017 Chris Aguilera. All rights reserved.
//

#import "EventTableViewCell.h"

@interface EventTableViewCell()

@end

@implementation EventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
