//
//  UIImage+JEToolkit.m
//  JEToolkit
//
//  Created by John Rommel Estropia on 2013/02/20.
//  Copyright (c) 2013 John Rommel Estropia. All rights reserved.
//

#import "UIImage+JEToolkit.h"


@implementation UIImage (JEToolkit)

#pragma mark - Public

+ (instancetype)imageFromFile:(NSString *)filePath
                        scale:(CGFloat)scale
                  orientation:(UIImageOrientation)orientation
{
    NSParameterAssert(filePath);
    NSParameterAssert(scale > 0.0f);
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    UIImage *image = [[self alloc] initWithData:data scale:scale];
    if (image.imageOrientation != orientation)
    {
        image = [[self alloc] initWithCGImage:image.CGImage
                                        scale:scale
                                  orientation:orientation];
    }
    return image;
}

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size
{
	CGRect rect = (CGRect){ .origin = CGPointZero, .size = size };
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    [color setFill];
	CGContextFillRect(context, rect);
    
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	return image;
}

+ (UIImage *)screenshot
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize imageSize = [UIScreen mainScreen].bounds.size;
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        imageSize = (CGSize){
            .width = imageSize.height,
            .height = imageSize.width
        };
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGRect windowBounds = window.bounds;
        CGContextSaveGState(context);
        CGContextTranslateCTM(context,
                              window.center.x,
                              window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context,
                              (-windowBounds.size.width * window.layer.anchorPoint.x),
                              (-windowBounds.size.height * window.layer.anchorPoint.y));
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        }
        else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:windowBounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (instancetype)decodedImage
{
    CGImageRef CGImage = self.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(CGImage), CGImageGetHeight(CGImage));
    CGRect imageRect = (CGRect){ .size = imageSize };
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(CGImage);
    
    int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
    BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone
                        || infoMask == kCGImageAlphaNoneSkipFirst
                        || infoMask == kCGImageAlphaNoneSkipLast);
    
    // CGBitmapContextCreate doesn't support kCGImageAlphaNone with RGB.
    // https://developer.apple.com/library/mac/#qa/qa1037/_index.html
    if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1)
    {
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    }
    // Some PNGs tell us they have alpha but only 3 components. Odd.
    else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3)
    {
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 CGImageGetBitsPerComponent(CGImage),
                                                 0,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    if (!context)
    {
        return self;
    }
    
    CGContextDrawImage(context, imageRect, CGImage);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *decompressedImage = [[self class]
                                  imageWithCGImage:decompressedImageRef
                                  scale:self.scale
                                  orientation:self.imageOrientation];
    CGImageRelease(decompressedImageRef);
    
    return decompressedImage;
}


@end
