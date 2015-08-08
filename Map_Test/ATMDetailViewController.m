//
//  ATMDetailViewController.m
//  Map_Test
//
//  Created by optimusmac-12 on 06/08/15.
//  Copyright (c) 2015 mdtaha.optimus. All rights reserved.
//

#import "ATMDetailViewController.h"

@interface ATMDetailViewController ()

@end

@implementation ATMDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _nameTextField.text=[@"Bank Name : " stringByAppendingString:_nameActual];
    
    _addText.text=[@"Address : "stringByAppendingString:_vicinityActual];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_picUrl]]];
    
    _icon.image=image;
    
    
    [_scroller setScrollEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
