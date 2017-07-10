//
//  ViewController.m
//  XMRunTimeKit
//
//  Created by 王续敏 on 2017/7/7.
//  Copyright © 2017年 wangxumin. All rights reserved.
//

#import "ViewController.h"
#import "XXModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelectorInBackground:@selector(saveModel) withObject:nil];
}

- (void)saveModel{
    for (int i = 0; i < 20; i++) {
        XXModel *model = [[XXModel alloc] init];
        model.properties0 = [NSString stringWithFormat:@"%d", i + 10];
        model.properties1 = [NSString stringWithFormat:@"%d", i + 10];
        model.properties2 = [NSString stringWithFormat:@"%d", i + 10];
        
        //===============归档
        [model archiverForKey:[NSString stringWithFormat:@"xx_model%d.archiver",i] path:nil];
        
        //==============解档
        XXModel *xxModel = [XXModel unArchiverForKey:[NSString stringWithFormat:@"xx_model%d",i] path:nil];
        NSLog(@"\n\nproperties0=%@\nproperties1=%@\nproperties2=%@\n\n",xxModel.properties0,xxModel.properties1,xxModel.properties2);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
