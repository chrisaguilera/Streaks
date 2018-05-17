//
//  EditEventViewController.m
//  Streaks
//
//  Created by Chris Aguilera on 11/24/17.
//  agui150@usc.edu
//  Copyright © 2017 Chris Aguilera. All rights reserved.
//

#import "EditEventViewController.h"

@interface EditEventViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *currentStreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestStreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *completionRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (weak, nonatomic) IBOutlet UITextField *deadlineTextField;

@end

@implementation EditEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self becomeFirstResponder];
    
    
    self.nameTextField.text = self.event.name;
    self.nameTextField.layer.cornerRadius = 5;
    
    // Visuals
    self.currentStreakLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.event.currentStreakLength];
    self.bestStreakLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.event.bestStreakLength];
    self.completionRateLabel.text = [NSString stringWithFormat:@"%.f%%", self.event.completionRate * 100];
    self.deadlineTextField.text = [Event deadlineStringForDate:self.event.deadlineDate];
    self.deadlineTextField.layer.cornerRadius = 5;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self.nameTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    [self.event setName:self.nameTextField.text];
    [self.nameTextField resignFirstResponder];
    self.completionHandler();
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
