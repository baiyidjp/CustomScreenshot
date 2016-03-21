//
//  ViewController.m
//  CustomScreenshot
//
//  Created by tztddong on 16/3/21.
//  Copyright © 2016年 dongjiangpeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong)UIImageView *imageBaseView;
@property(nonatomic,assign)CGPoint startPoint;
@property(nonatomic,weak)UIView *clipView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(movePoint:)];
    [self.imageBaseView addGestureRecognizer:panGes];
    [self.view addSubview:self.imageBaseView];
}

- (UIImageView *)imageBaseView{
    if (!_imageBaseView) {
        _imageBaseView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"123454"]];
        _imageBaseView.frame = self.view.frame;
        _imageBaseView.contentMode = UIViewContentModeCenter;
        _imageBaseView.userInteractionEnabled = YES;
    }
    return _imageBaseView;
}

- (void)movePoint:(UIPanGestureRecognizer *)panGes{
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始选择区域");
        //获取起点的位置
        self.startPoint = [panGes locationInView:self.view];
        //显示截图区域的View
        UIView*clipView=[[UIView alloc]init];
        clipView.backgroundColor=[UIColor redColor];
        clipView.alpha=0.5;
        [self.view addSubview:clipView];
        self.clipView=clipView;
        
        
    }else if (panGes.state == UIGestureRecognizerStateChanged){
        NSLog(@"正在选择区域");
        CGPoint currentPoint = [panGes locationInView:self.view];
        CGFloat offsetX = currentPoint.x - self.startPoint.x;
        CGFloat offsetY = currentPoint.y - self.startPoint.y;
        if (offsetX > 0) {
            self.clipView.frame = CGRectMake(self.startPoint.x, self.startPoint.y, offsetX, offsetY);
        }else{
            self.clipView.frame = CGRectMake(currentPoint.x, currentPoint.y, ABS(offsetX), ABS(offsetY));
        }
        
    }else if (panGes.state == UIGestureRecognizerStateEnded){
        NSLog(@"结束选择");
        UIImage *image=[self clipImage:self.imageBaseView withClipRect:self.clipView.frame];
        [self.clipView removeFromSuperview];
        self.clipView = nil;
        self.imageBaseView.image  = image;
        //存到相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
}

- (UIImage *)clipImage:(UIView *)view withClipRect:(CGRect)clipRect{
    
    //1.开始上下文
    UIGraphicsBeginImageContext(view.frame.size);
    //2.绘制图形
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //把layer上的内容绘制到图形上
    [view.layer renderInContext:ctx];
    //获取全屏的截图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //获取制定范围的截图
    UIImage *clipImg = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(newImage.CGImage, clipRect)];
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return clipImg;
}

@end













