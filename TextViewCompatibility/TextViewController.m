//
//  ViewController.m
//  TextViewCompatibility
//
//  Created by kishikawa katsumi on 2013/11/13.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()

@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic) UIEdgeInsets textViewContentInset;
@property (nonatomic) UIEdgeInsets textViewScrollIndicatorInsets;

@end

@implementation TextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)done:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark -

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.textViewContentInset = self.textView.contentInset;
    self.textViewScrollIndicatorInsets = self.textView.scrollIndicatorInsets;
    
    NSDictionary *userInfo = notification.userInfo;
    
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = CGRectGetHeight(keyboardFrame);
    
    UIEdgeInsets contentInset = self.textView.contentInset;
    self.textViewContentInset = contentInset;
    contentInset.bottom = keyboardHeight;
    
    UIEdgeInsets scrollIndicatorInsets = self.textView.scrollIndicatorInsets;
    self.textViewScrollIndicatorInsets = scrollIndicatorInsets;
    scrollIndicatorInsets.bottom = keyboardHeight;
    
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
    
    self.textView.contentInset = contentInset;
    self.textView.scrollIndicatorInsets = scrollIndicatorInsets;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
    
    self.textView.contentInset = self.textViewContentInset;
    self.textView.scrollIndicatorInsets = self.textViewScrollIndicatorInsets;
    
    [UIView commitAnimations];
}

@end
