//
//  ViewController.h
//  MZCroppableView
//
//  Created by macbook on 30/10/2013.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZCroppableView;
@interface OperationViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UIImageView *croppingImageView;
    
    MZCroppableView *mzCroppableView;
}
@end
