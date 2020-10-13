//
//  ViewController.m
//  TouchID
//
//  Created by admin on 17/5/9.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "MainViewController.h"

@interface ViewController ()
{
    LAContext *context;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

        // 实例化本地身份验证上下文
        [self creatUI];
    
        context= [[LAContext alloc] init];
    
        [self initIT];


}

- (void)creatUI{
    //头像
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-60, 50, 120, 120)];
    [self.view addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"image1"];
    imageV.layer.masksToBounds = YES;
    // 其實就是設定圓角，只是圓角的弧度剛好就是圖片尺寸的一半
    imageV.layer.cornerRadius = 60;
    
    //问好
    UILabel *helloLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x-100, CGRectGetMaxY(imageV.frame)+10, 200, 30)];
    [self.view addSubview:helloLab];
    helloLab.text = [NSString stringWithFormat:@"%@ %@", @"Hello",@"你好"];
    helloLab.font = [UIFont systemFontOfSize:18.0];
    helloLab.textAlignment = NSTextAlignmentCenter;
    helloLab.textColor = [UIColor blackColor];

    //指纹按钮
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x-35, CGRectGetMaxY(imageV.frame)+120 , 70, 70)];
    [self.view addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"auth_finger"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"auth_finger_highlight"] forState:UIControlStateHighlighted];
    btn.backgroundColor = [UIColor clearColor];
    [btn setShowsTouchWhenHighlighted:NO];//滑过即点击
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *labBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x-100, CGRectGetMaxY(btn.frame)+10, 200, 30)];
    [self.view addSubview:labBtn];
    labBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [labBtn setTitle:@"点击进行指纹登录" forState:UIControlStateNormal];
    [labBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [labBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [labBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x-100, CGRectGetMaxY(labBtn.frame)+20, 200, 30)];
    [self.view addSubview:moreBtn];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [moreBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)btn{
    
    [self initIT];
}

- (void)initIT{
    
    // 判断用户手机系统是否是 iOS 8.0 以上版本
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        return;
    }
    
    // 判断是否支持指纹识别
    if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:NULL]) {
        return;
    }
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication
            localizedReason:@"请验证已有指纹"
                      reply:^(BOOL success, NSError * _Nullable error) {
                          
                          // 输入指纹开始验证，异步执行
                          if (success) {
                              
                              [self refreshUI:[NSString stringWithFormat:@"指纹验证成功"] message:nil];
//                               [self pushVC];
                          }else{
                              
                              [self refreshUI:[NSString stringWithFormat:@"指纹验证失败"] message:error.userInfo[NSLocalizedDescriptionKey]];
                          }
                      }];
}
    // 主线程刷新 UI
- (void)refreshUI:(NSString *)str message:(NSString *)msg {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:str
                                                                           message:msg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alert animated:YES completion:^{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alert dismissViewControllerAnimated:YES completion:nil];
                    if ([str isEqualToString:@"指纹验证成功"]) {
                        [self pushVC];
                    }
                });
            }];
        });
}

- (void)pushVC{
    
    MainViewController *vc = [MainViewController new];
    [self presentViewController:vc animated:YES completion:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
