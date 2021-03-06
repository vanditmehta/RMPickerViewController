//
//  RMViewController.m
//  RMPickerViewController-Demo
//
//  Created by Roland Moers on 26.10.13.
//  Copyright (c) 2013 Roland Moers
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "RMViewController.h"

@interface RMViewController () <RMPickerViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UISwitch *blackSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *blurSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *motionSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *bouncingSwitch;

@end

@implementation RMViewController

#pragma mark - Actions
- (IBAction)openPickerController:(id)sender {
    RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
    pickerVC.delegate = self;
    pickerVC.titleLabel.text = @"This is an example title.\n\nPlease choose a row and press 'Select' or 'Cancel'.";
    
    //You can enable or disable bouncing and motion effects
    pickerVC.disableBouncingWhenShowing = !self.bouncingSwitch.on;
    pickerVC.disableMotionEffects = !self.motionSwitch.on;
    pickerVC.disableBlurEffects = !self.blurSwitch.on;
    
    //You can also adjust colors (enabling the following line will result in a black version of RMPickerViewController)
    if(self.blackSwitch.on)
        pickerVC.blurEffectStyle = UIBlurEffectStyleDark;
    
    //Enable the following lines if you want a black version of RMPickerViewController but also disabled blur effects (or run on iOS 7)
    //pickerVC.tintColor = [UIColor whiteColor];
    //pickerVC.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
    //pickerVC.selectedBackgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
    
    //The example project is universal. So we first need to check whether we run on an iPhone or an iPad.
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        //OK, running on an iPhone. The following lines demonstrate the two ways to show the picker view controller on iPhones:
        //(Note: These two methods also work an iPads.)
        
        // 1. Just show the picker view controller (make sure the delegate property is assigned)
        [pickerVC show];
        
        // 2. Instead of using a delegate you can also pass blocks when showing the picker view controller
        //[pickerVC showWithSelectionHandler:^(RMPickerViewController *vc, NSArray *selectedRows) {
        //    NSLog(@"Successfully selected rows: %@", selectedRows);
        //} andCancelHandler:^(RMPickerViewController *vc) {
        //    NSLog(@"Row selection was canceled (with block)");
        //}];
    } else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //OK, running on an iPad. The following lines demonstrate the two special ways of showing the picker view controller on iPads:
        
        // 1. Show the picker view controller from a particular view controller (make sure the delegate property is assigned).
        //    This method can be used to show the picker view controller within popovers.
        //    (Note: We do not use self as the view controller, as showing a picker view controller from a table view controller
        //           is not supported due to UIKit limitations.)
        //[pickerVC showFromViewController:self.navigationController];
        
        // 2. As with the two ways of showing the picker view controller on iPhones, we can also use a blocks based API.
        //[pickerVC showFromViewController:self.navigationController withSelectionHandler:^(RMPickerViewController *vc, NSArray *selectedRows) {
        //    NSLog(@"Successfully selected rows: %@", selectedRows);
        //} andCancelHandler:^(RMPickerViewController *vc) {
        //    NSLog(@"Row selection was canceled (with block)");
        //}];
        
        // 3. Show the date selection view controller using a UIPopoverController. The rect and the view are used to tell the
        //    UIPopoverController where to show up.
        [pickerVC showFromRect:[self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] inView:self.view];
        
        // 4. The date selectionview controller can also be shown within a popover while also using blocks based API.
        //[pickerVC showFromRect:[self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] inView:self.tableView withSelectionHandler:^(RMPickerViewController *vc, NSArray *selectedRows) {
        //    NSLog(@"Successfully selected rows: %@", selectedRows);
        //} andCancelHandler:^(RMPickerViewController *vc) {
        //    NSLog(@"Row selection was canceled (with block)");
        //}];
    }
}

#pragma mark - UITableView Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0) {
        [self openPickerController:self];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - RMPickerViewController Delegates
- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray *)selectedRows {
    NSLog(@"Successfully selected rows: %@", selectedRows);
}

- (void)pickerViewControllerDidCancel:(RMPickerViewController *)vc {
    NSLog(@"Selection was canceled");
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"Row %lu", (long)row];
}

@end
