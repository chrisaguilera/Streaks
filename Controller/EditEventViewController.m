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

@end

@implementation EditEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self becomeFirstResponder];
    
    
    self.nameTextField.text = self.event.name;
    self.nameTextField.layer.cornerRadius = 5;
    
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
