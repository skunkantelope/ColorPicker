//
//  CPViewController.h
//  Color Picker
//
//  Created by Qian Wang on 4/21/13.
//  Copyright (c) 2013 Pony Studio. All rights reserved.
//

@interface CPViewController : UIViewController <UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)pickPhotoFromPhotoAlbum:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *colorVignette;

@end
