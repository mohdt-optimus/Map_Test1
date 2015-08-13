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
    if ([_nameActual isEqualToString:@"This is your Location"]){
       _nameTextField.text=@"This is your Home location";
    }else{
    _nameTextField.text=[@"Bank Name : " stringByAppendingString:_nameActual];
    }
    _addText.text=[@"Address : "stringByAppendingString:_vicinityActual];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_picUrl]]];
    
    _icon.image=image;
    
    
    [_scroller setScrollEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
