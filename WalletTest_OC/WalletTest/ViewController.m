//
//  ViewController.m
//  WalletTest
//
//  Created by 崔林豪 on 2018/8/14.
//  Copyright © 2018年 崔林豪. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>


@interface ViewController ()<PKAddPassesViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PKAddPassButton *pkAddBtn = [[PKAddPassButton alloc] initWithAddPassButtonStyle:PKAddPassButtonStyleBlack];
    pkAddBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    pkAddBtn.frame = CGRectMake(100, 100, 220, 40);
    [self.view addSubview:pkAddBtn];
    
    [pkAddBtn addTarget:self action:@selector(pkClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)pkClick:(PKAddPassButton *)sender
{
    NSString *passPath = [[NSBundle mainBundle] pathForResource:@"Lollipop" ofType:@"pkpass"];
    NSData *passData = [[NSData alloc] initWithContentsOfFile:passPath];
    NSError *error = nil;
    PKPass *pass = [[PKPass alloc] initWithData:passData error:&error];
    if (error) {
        NSLog(@"创建pass 过程中发生错误,错误信息:%@", error.localizedDescription);
    }
    
    PKAddPassesViewController *vc = [[PKAddPassesViewController alloc] initWithPass:pass];
    vc.delegate = self;
    
    [self presentViewController:vc animated:YES completion:nil];

}


#pragma mark -  delegate

- (void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller
{
    NSLog(@"add pass finished");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
