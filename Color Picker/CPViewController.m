//
//  CPViewController.m
//  Color Picker
//
//  Created by Qian Wang on 4/21/13.
//  Copyright (c) 2013 Pony Studio. All rights reserved.
//

#import "CPViewController.h"
#import "CPImageView.h"

@interface CPViewController () {
    CGContextRef context;
    
    CPImageView *colorSource;
}

- (void)displayImage:(UIImage *)image;
- (CGContextRef) createCGBitmapContextWithImage:(CGImageRef)image;

@end

@implementation CPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paintColor) name:@"color" object:nil];
	// Do any additional setup after loading the view, typically from a nib.
    UIImage *image = [UIImage imageNamed:@"colorWheel"];
    [self displayImage:image];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)displayImage:(UIImage *)image {
    CGContextRelease(context);
    [colorSource removeFromSuperview];
    
    // This method has the problem when the original image size is bigger than the screen size.
    float width = image.size.width;
    float height = image.size.height;
    CGRect window = self.scrollView.bounds;
    
    colorSource = [[CPImageView alloc] initWithImage:image];
    colorSource.userInteractionEnabled = YES;
   
    colorSource.frame = CGRectMake((window.size.width - width) / 2, (window.size.height - height) / 2, width, height);
    [self.scrollView addSubview:colorSource];
    NSLog(@"image width %f height %f scrollview width %f height %f content x %f y %f", width,height,window.size.width,window.size.height, self.scrollView.contentOffset.x, self.scrollView.contentOffset.y);
   // self.scrollView.contentOffset = CGPointMake(colorSource.frame.origin.x, colorSource.frame.origin.y);
    NSLog(@"content offset %f %f", colorSource.frame.origin.x, colorSource.frame.origin.y);
   // self.scrollView.contentOffset = CGPointMake(-width, -height);
  //  self.scrollView.contentSize = CGSizeMake(width*2, height*2);
    self.scrollView.contentInset = UIEdgeInsetsMake(height/2, width/2, height/2 + 300, width/2 + 300);
    
    // Remedy: scale the original image to fit the screen width. Do it later.
    CGImageRef cgImage = image.CGImage;
    context = [self createCGBitmapContextWithImage:cgImage];
    if (context == NULL) {
        NSLog(@"Failure to create bitmap context");
    }
    
    float w = CGImageGetWidth(cgImage);
    float h = CGImageGetHeight(cgImage);
    CGRect rect = {{0, 0}, {w, h}};
    
    CGContextDrawImage(context, rect, cgImage);


}


- (void) paintColor {
    CGPoint point;
    UIView *view = [self.scrollView.subviews lastObject];
    if ( [view isMemberOfClass:[CPImageView class]] ) {
        point = [(CPImageView *)view location];
    }
    
    UIColor *color = nil;
    int bytesPerRow = CGBitmapContextGetBytesPerRow(context);
    unsigned char* data = CGBitmapContextGetData(context);
    
    if (data != NULL && data != 0) {
        int offset = bytesPerRow * round(point.y) + round(point.x) * 4;
        
        int red = data[offset];
        int green = data[offset + 1];
        int blue = data[offset + 2];
        int alpha = data[offset + 3];
        
        color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
    }

    self.colorVignette.backgroundColor = color;
}

- (CGContextRef) createCGBitmapContextWithImage:(CGImageRef)image {
    CGContextRef c = NULL;
    CGColorSpaceRef colorSpace;
    
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    int widthInPixel = CGImageGetWidth(image);
    int heightInPixel = CGImageGetHeight(image);
    //CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(image);
    
    bitmapBytesPerRow = widthInPixel * 4;
    bitmapByteCount = bitmapBytesPerRow * heightInPixel;
    
    colorSpace = CGColorSpaceCreateDeviceRGB() ;
    
    c = CGBitmapContextCreate(NULL, widthInPixel, heightInPixel, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    
    return c;
    
}

# pragma handling motion events
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        UIImage *image = [UIImage imageNamed:@"colorWheel"];
        [self displayImage:image];
        self.colorVignette.backgroundColor = [UIColor clearColor];
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickPhotoFromPhotoAlbum:(id)sender {
    self.colorVignette.backgroundColor = [UIColor clearColor];
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

# pragma UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self displayImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
