//
//  SFViewController.m
//  SFFishEyeEffect
//
//  Created by Jagie on 30/06/13.
//  Copyright (c) 2013 Jagie. All rights reserved.
//

#import "SFFishEyesVC.h"
#import <QuartzCore/QuartzCore.h>


@interface SFFishEyesVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) UIImage *srcImage;
@property (strong,nonatomic) UIImage *distortedImage;
@property (weak, nonatomic) IBOutlet UISlider *slide;


@property (weak, nonatomic) IBOutlet UILabel *degreeAngleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;


@end



@implementation SFFishEyesVC

- (uint32_t *)convertToUINT32Array:(UIImage *)srcImage {
    CGSize size = [srcImage size];
    int width = size.width;
    int height = size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [srcImage CGImage]);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return pixels;
}

-(UIImage *)convertUINT32ArrayToUIImage:(uint32_t *)pixels Width:(int)width Height:(int)height{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

-(void)awakeFromNib{
    [super awakeFromNib];
   
  
}

- (IBAction)onSlide:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self buildDistortedImage];
            self.imageView.image = self.distortedImage;
            self.degreeAngleLabel.text = [NSString stringWithFormat:@"%d",(int)self.slide.value];
        });
    });
}


-(void)buildDistortedImage{
    float width = (self.srcImage.size.width);
    float height = (self.srcImage.size.height);
    
    
    float ri = MIN(width, height) / 2;
    
    uint32_t * srcPixels = [self convertToUINT32Array:self.srcImage];
    uint32_t * dstPixels = malloc(width * height * sizeof(uint32_t));
    
    CGPoint center = CGPointMake(width / 2,height / 2);
    
    const float sphereAngle = self.slide.value * M_PI / 180;
    const float sphereRadius = ri / sphereAngle;
    
    
    float h = ri / tan(sphereAngle);
    
    for (int row = 0; row < height; row++) {
        for (int col = 0; col < width; col++) {
            float dx = col - center.x;
            float dy = row - center.y;
            double angle = atan2(dy, dx);
            double dis = sqrt(dx * dx + dy * dy);
            
            
            
            double dis2 = tan(dis / sphereRadius) * h; 
            
            float newDx = dis2 * cos(angle);
            float newDy = dis2 * sin(angle);
            
            int nx = (int)(center.x + newDx);
            int ny = (int)(center.y + newDy);
            
            if (nx < width && ny < height && nx >= 0 && ny >= 0) {
                int index = ny * width + nx;
                dstPixels[row * (int)width + col] = srcPixels[index];
                
            }
            
            
        }
    }
    free(srcPixels);
    UIImage *image2 = [self convertUINT32ArrayToUIImage:dstPixels Width:(int)width Height:(int)height];
    self.distortedImage = image2;
    
    free(dstPixels);
    
}

- (IBAction)onSwitchEyeFish:(id)sender {
    UISwitch *switchControl = sender;
    if (switchControl.on) {
        self.slide.value = 60;
        self.slide.enabled = YES;
        [self onSlide:self.slide];
        
    }else{
        self.imageView.image = self.srcImage;
        self.slide.enabled = NO;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.srcImage = [UIImage imageNamed:@"sample2.png"];
    self.imageView.image = self.srcImage;
    
    [self.switchControl setOn:YES animated:NO];
    [self onSwitchEyeFish:self.switchControl];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)dealloc{
    self.distortedImage = nil;
    self.srcImage = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
