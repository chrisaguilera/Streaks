//
//  EventTableViewCell.m
//  Streaks
//
//  Created by Chris Aguilera on 11/23/17.
//  agui150@usc.edu
//  Copyright © 2017 Chris Aguilera. All rights reserved.
//

#import "EventTableViewCell.h"
#import "AudioToolbox/AudioServices.h"
#import <QuartzCore/QuartzCore.h>

FOUNDATION_EXTERN void AudioServicesPlaySystemSoundWithVibration(UInt32 inSystemSoundID,id arg,NSDictionary* vibratePattern);

@interface EventTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIView *streakContainerView;

@end

@implementation EventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Visual Elements
    self.layer.cornerRadius = 5;
    [self.completeButton setImage:[UIImage imageNamed:@"check_gray.png"] forState:UIControlStateDisabled];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateTableViewCell {
    self.nameLabel.text = self.event.name;
    self.currentStreakLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) self.event.currentStreakLength];
    self.deadlineLabel.text = [self getStringForDeadline:self.event.deadline];
    if (self.event.isCompleted) {
        [self.completeButton setEnabled:NO];
    } else {
        [self.completeButton setEnabled:YES];
    }
    
}

- (IBAction)completeButtonPressed:(UIButton *)sender {
    // Vibrate
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    NSMutableArray* arr = [NSMutableArray array ];
    [arr addObject:[NSNumber numberWithBool:YES]];
    [arr addObject:[NSNumber numberWithInt:10]];
    [dict setObject:arr forKey:@"VibePattern"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
    AudioServicesPlaySystemSoundWithVibration(4095,nil,dict);
    
    [self.event completeEvent];
    [self updateTableViewCell];
}

- (NSString *)getStringForDeadline: (NSDate *) deadline {
    return deadline.description;
}

@end
