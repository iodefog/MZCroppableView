//
//  ViewController.m
//  MZCroppableView
//
//  Created by macbook on 30/10/2013.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import "OperationViewController.h"
#import "MZCroppableView.h"
#import "TKAlertCenter.h"
#import "QQApiHelper.h"
#import "AppDelegate.h"
@interface OperationViewController ()

@end

@implementation OperationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UILabel *tipTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 320, 44)];
    tipTitle.textAlignment = NSTextAlignmentCenter;
    tipTitle.text = @"请先点击“选图”选取图片";
    tipTitle.textColor = [UIColor grayColor];
    [self.view addSubview:tipTitle];
    croppingImageView = [[UIImageView alloc] init];
    croppingImageView.backgroundColor = [UIColor clearColor];
    croppingImageView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+64, self.view.frame.size.width, self.view.frame.size.height);
//    [croppingImageView setImage:[UIImage imageNamed:@"cropping_sample.png"]];
//    CGRect rect1 = CGRectMake(0, 0, croppingImageView.image.size.width, croppingImageView.image.size.height);
//    CGRect rect2 = croppingImageView.frame;
//    [croppingImageView setFrame:[MZCroppableView scaleRespectAspectFromRect1:rect1 toRect2:rect2]];
    [self.view addSubview:croppingImageView];
    [self setUpMZCroppableView];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetButtonTapped:)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"crop" style:UIBarButtonItemStylePlain target:self action:@selector(cropButtonTapped:)];
    NSArray *titleArray = [NSArray arrayWithObjects:@"选图" ,@"重置", @"抠图", @"保存", @"到微信", @"到QQ" ,nil];
    NSMutableArray *itemsArray = [NSMutableArray array];
    for (int i= 0; i < [titleArray count]; i++) {
        NSString *title = [titleArray objectAtIndex:i];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(barButtonTapped:)];
        barItem.tag = 100 + i;
        [itemsArray addObject:barItem];
    }
    self.navigationItem.leftBarButtonItems = itemsArray;
}

- (void)barButtonTapped:(UIBarButtonItem *)barItem{
    if (barItem.tag == 100) {       // select
        [self postPicker];
    }else if (barItem.tag == 101){  // reset
        [self resetButtonTapped:barItem];
    }else if (barItem.tag == 102){  // crop
        [self cropButtonTapped:barItem];
    }else if (barItem.tag == 103){  // save
        [self saveCutScreen];
    }else if (barItem.tag == 104){  // weixin
        AppDelegate *delegate = (id)[UIApplication sharedApplication].delegate;
        [delegate sendImageContent:[self getCutScreen]];
    }else if (barItem.tag == 105){  // QQ
        [[QQApiHelper shareInstance] sendImageMessage:[self getCutScreen] preViewImage:[self getCutScreen] title:@"截图" descrition:nil];
    }
}

- (void)postPicker{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:picker animated:YES];
}

- (UIImage *)getCutScreen{
    UIView *view = nil;
    view = self.view;
    //    if ([[[[[UIApplication sharedApplication] windows] objectAtIndex:0] subviews] count] > 0) {
    //        view = [[[[[UIApplication sharedApplication] windows] objectAtIndex:0] subviews] objectAtIndex:0];//获得某个window的某个subView
    //    }
    //    NSInteger index = 0;//用来给保存的png命名
    //    for (UIView *subView in [view subviews]) {//遍历这个view的subViews
    //        if ([subView isKindOfClass:NSClassFromString(@"UIImageView")] || [subView isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {//找到自己需要的subView
    //支持retina高分的关键
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    
    //获取图像
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)saveCutScreen{
     UIImageWriteToSavedPhotosAlbum([self getCutScreen], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        NSLog(@"%@", error);
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"保存失败"];
    }
    else  // No errors
    {
        NSLog(@"success");
        // Show message image successfully saved
         [[TKAlertCenter defaultCenter] postAlertWithMessage:@"保存成功"];
        [self resetButtonTapped:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    NSData *data;
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //图片压缩，因为原图都是很大的，不必要传原图
        UIImage *scaleImage = [self scaleImage:originImage toScale:1.0];
        
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 1);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
        
        //将图片传递给截取界面进行截取并设置回调方法（协议）
//        CaptureViewController *captureView = [[CaptureViewController alloc] init];
//        captureView.delegate = self;
//        captureView.image = image;
        //隐藏UIImagePickerController本身的导航栏
        croppingImageView.image = image;
        if (image.size.height > image.size.width) {
           croppingImageView.frame = CGRectMake(croppingImageView.frame.origin.x, croppingImageView.frame.origin.y, (self.view.frame.size.height - 64)*image.size.width/image.size.height, self.view.frame.size.height - 64);
        }else{
            croppingImageView.frame = CGRectMake(croppingImageView.frame.origin.x, croppingImageView.frame.origin.y, 320, image.size.height*320/image.size.width);
        }
        croppingImageView.center = CGPointMake(self.view.center.x, croppingImageView.center.y);

//        [croppingImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin];
//        picker.navigationBar.hidden = YES;
        [self resetButtonTapped:nil];
        [picker dismissViewControllerAnimated:YES completion:nil];
//        [picker pushViewController:captureView animated:YES];
        
    }
}

#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - My Methods -
- (void)setUpMZCroppableView
{
    [mzCroppableView removeFromSuperview];
    mzCroppableView = [[MZCroppableView alloc] initWithImageView:croppingImageView];
    [self.view addSubview:mzCroppableView];
}
#pragma mark - My IBActions -
- (IBAction)resetButtonTapped:(UIBarButtonItem *)sender
{
    [self setUpMZCroppableView];
}
- (IBAction)cropButtonTapped:(UIBarButtonItem *)sender
{
    UIImage *croppedImage = [mzCroppableView deleteBackgroundOfImage:croppingImageView];
    
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"图片为空或者操作失败，请重试"];
    
    UIImageWriteToSavedPhotosAlbum(croppedImage, self, nil, nil);
    
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/final.png"];
    [UIImagePNGRepresentation(croppedImage) writeToFile:path atomically:YES];
    
    NSLog(@"cropped image path: %@",path);
}
@end
