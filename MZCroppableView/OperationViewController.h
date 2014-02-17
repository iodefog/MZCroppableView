//
//  ViewController.h
//  MZCroppableView
//
//  Created by macbook on 30/10/2013.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMUFPBannerView.h"

@class MZCroppableView;
@interface OperationViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate ,UIActionSheetDelegate>
{
    IBOutlet UIImageView *croppingImageView;
    
    MZCroppableView *mzCroppableView;
    
    UMUFPBannerView *banner;
}
@end
