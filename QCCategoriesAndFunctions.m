//
//  QCCategoriesAndFunctions.m
//  QCCategoriesAndFunctions
//
//  Created by Q Cook on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QCCategoriesAndFunctions.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <mach/mach.h>           
#import <malloc/malloc.h>       

#pragma mark - Constants

#pragma mark Font Names
NSString *kArialRoundedBold = @"ArialRoundedMTBold";
NSString *kTrebuchet = @"TrebuchetMS";
NSString *kTrebuchetBold = @"TrebuchetMS-Bold";
NSString *kHelveticaNeue = @"HelveticaNeue";
NSString *kHelveticaNeueBold = @"HelveticaNeue-Bold";
NSString *kHelveticaBoldOblique = @"Helvetica-BoldOblique";
NSString *kHeitiSCMedium = @"STHeitiSC-Medium";
NSString *kVerdana = @"Verdana";
NSString *kGeorgia = @"Georgia";
NSString *kGeorgiaItalic = @"Georgia-Italic";
NSString *kPalatino = @"Palatino";
NSString *kFuturaMedium = @"Futura-Medium";


#pragma mark - UIView 
static const char *kUIViewUserInfoKeyQC = "kUIViewUserInfoKeyQC";
@implementation UIView (QCCategory) 

- (void) centerInView:(UIView*)largeView withHorizontal:(NSInteger)horzontalOverride andVerticalOverrides:(NSInteger)verticalOverride {
    self.frame = CGCenteredRectInRectWithOverrides(self.frame, largeView.frame, horzontalOverride, verticalOverride);
}

- (CGPoint) centeredOriginPointInRect:(CGRect)rect {
    return CGCenteredRectInRectWithOverrides(self.frame, rect, NSNotFound, NSNotFound).origin;
}

- (void) setOrigin:(CGPoint)origin {
    self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
}

- (UIView*) subviewOfType:(Class)clazz {
    // Depth first search for a view type.
    UIView *subviewFound = nil;
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:clazz]) {
            subviewFound = subview;
        } 
        else {
            subviewFound = [subview subviewOfType:clazz];
        }
        
        if (subviewFound != nil) {
            return (UIView *)subviewFound;
        }
    }
    return nil;
}

@dynamic userInfo;
- (id) userInfo {
    return objc_getAssociatedObject(self, kUIViewUserInfoKeyQC);
}

- (void)userInfo:(id)userInfo {
    objc_setAssociatedObject(self, kUIViewUserInfoKeyQC, userInfo, OBJC_ASSOCIATION_ASSIGN);
}

@end


#pragma mark - UIColor
@implementation UIColor (QCCategory)

+ (UIColor *) colorWithIntegerRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue
{
    return [UIColor colorWithRed:((CGFloat)red / 255.0) green:((CGFloat)green / 255.0) blue:((CGFloat)blue / 255.0) alpha:1.0];
}


+ (NSString *) htmlColorWithIntegerRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue
{
    return [NSString stringWithFormat:@"#%02x%02x%02x", red, green, blue];
}

- (NSString *) htmlColor
{
    const float *c = CGColorGetComponents(self.CGColor);
    int red = fmaxf(fminf(c[0], 1.0),0.0) * 255;
    int green = fmaxf(fminf(c[1], 1.0),0.0) * 255;
    int blue = fmaxf(fminf(c[2], 1.0),0.0) * 255;
    return [UIColor htmlColorWithIntegerRed:red green:green blue:blue];
}

@end


#pragma mark - UIButton
@implementation UIButton (QCCategory)

- (void) setHighlightedAndSelectedTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateHighlighted];
    [self setTitleColor:color forState:UIControlStateSelected];
    [self setTitleColor:color forState:(UIControlStateSelected | UIControlStateHighlighted)];
}

- (void) setHighlightedAndSelectedTitleShadowColor:(UIColor *)color
{
    [self setTitleShadowColor:color forState:UIControlStateHighlighted];
    [self setTitleShadowColor:color forState:UIControlStateSelected];
    [self setTitleShadowColor:color forState:(UIControlStateSelected | UIControlStateHighlighted)];
}

- (void) setHighlightedAndSelectedImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateHighlighted];
    [self setImage:image forState:UIControlStateSelected];
    [self setImage:image forState:(UIControlStateSelected | UIControlStateHighlighted)];
}

- (void) setHighlightedAndSelectedBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
    [self setBackgroundImage:image forState:UIControlStateSelected];
    [self setBackgroundImage:image forState:(UIControlStateSelected | UIControlStateHighlighted)];
}

@end


#pragma mark - UIImage
@implementation UIImage(QCCategory)

- (CGSize) sizeToFitWithinSize:(CGSize)frameSize {
    return CGSizeToFitWithinSize(self.size, frameSize);
}

@end

#pragma mark - UIImageView
@implementation UIImageView(QCCategory)

- (void) crossFadeToImage:(UIImage *)image {
    CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
    crossFade.duration = .24;
    
    // Get a UIImage from the view's contents
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, self.contentScaleFactor);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *currentImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Convert UIImage to CGImage
    if (self.image) {
        crossFade.fromValue = (id)currentImage.CGImage;
    }
    else {
        CGContextSetGrayFillColor(context, 1.0, 1.0);
        CGContextFillRect(context, self.bounds);
        crossFade.fromValue = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    }
    UIGraphicsEndImageContext();
    crossFade.toValue = (id)image.CGImage;
    [self.layer addAnimation:crossFade forKey:@"animateContents"];
    self.image = image;
}

+ (UIImageView *) imageViewWithImageNamed:(NSString *)name {
    return [[[UIImageView alloc] initWithImage:[UIImage imageNamed:name]] autorelease];
}

@end



#pragma mark - NSDictionary
@implementation NSDictionary (QCCategory) 

- (NSString*) stringForKey:(id)key {
    return [self stringForKey:key convertNSNumber:YES];
}

- (NSInteger) integerForKey:(id)key {
    return [self integerForKey:key convertNSString:YES];
}

- (NSString*) stringForKey:(id)key convertNSNumber:(BOOL)convert {
    id returnObject = [self objectForKey:key];
    if ([returnObject isKindOfClass:[NSNumber class]]) {
        return convert ? [returnObject stringValue] : nil;
    }
    return [returnObject isKindOfClass:[NSString class]] ? returnObject : nil;
}

- (NSInteger) integerForKey:(id)key convertNSString:(BOOL)convert {
    id returnObject = [self objectForKey:key];
    if (returnObject && ([returnObject isKindOfClass:[NSNumber class]] || (convert && [returnObject isKindOfClass:[NSString class]]))) {
        return [returnObject intValue];
    }
    return 0;
}
- (NSDictionary*) dictionaryForKey:(id)key {
    id returnObject = [self objectForKey:key];
    if ([returnObject isKindOfClass:[NSDictionary class]]) {
        return returnObject;
    }
    return nil;
}

- (NSArray*) arrayForKey:(id)key {
    id returnObject = [self objectForKey:key];
    if ([returnObject isKindOfClass:[NSArray class]]) {
        return returnObject;
    }
    return nil;
}

@end




#pragma mark - NSArray
@implementation NSArray(QCCategory)

- (id)nestedObjectAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
	NSArray *subArray = [self objectAtIndex:section];
	
	if (![subArray isKindOfClass:[NSArray class]])
		return nil;
	
	if (row >= [subArray count])
		return nil;
	
	return [subArray objectAtIndex:row];
}

- (NSInteger)countOfNestedArray:(NSUInteger)section 
{
	NSArray *subArray = [self objectAtIndex:section];
	return [subArray count];
}

- (NSIndexPath*) indexPathOfObjectInNestedArray:(id)object
{
    int section = 0;
    int row = 0;
    for (NSArray * subArray in self) {
        for (id existingObject in subArray) {
            if (object == existingObject) {
                return [NSIndexPath indexPathForRow:row inSection:section];
            }
            row++;
        }
        row=0;
        section++;
    }
    return nil;
}

- (NSIndexPath*) indexPathAfterIndexPath:(NSIndexPath*)previousIndexPath
{
    if ([self countOfNestedArray:previousIndexPath.section] - 1 > previousIndexPath.row) {
        return [NSIndexPath indexPathForRow:previousIndexPath.row + 1 inSection:previousIndexPath.section];
    }
    else {
        int sectionToCheck = previousIndexPath.section + 1;
        while (sectionToCheck < [self count]) {
            if ([self countOfNestedArray:sectionToCheck]) {
                return [NSIndexPath indexPathForRow:0 inSection:sectionToCheck];
            }
            else {
                sectionToCheck++;
            }
        }
        return nil;
    }
}


@end


#pragma mark - UILabel
@implementation UILabel (QCCategory) 

+ (UILabel*) labelWithText:(NSString*)text font:(UIFont*)font color:(UIColor*)color backgroundColor:(UIColor*)bkgColor
{
    UILabel * label = [[[UILabel alloc] init] autorelease];
    label.text = text;
    label.font = font;
    label.backgroundColor = bkgColor;
    label.textColor = color;
    [label sizeToFit];
    return label;
}

@end


#pragma mark - Functions

extern void ReleaseAndNil(NSObject *object) {
    [object release];
    object = nil;
}

#pragma mark CGRect Centering
extern CGRect CGCenteredRectInRectWithOverrides(CGRect innerRect, CGRect outerRect, NSInteger horizontalOverride, NSInteger veritcalOverride) {
    innerRect.origin.x = horizontalOverride == NSNotFound ? ceilf((outerRect.size.width - innerRect.size.width)/2) : horizontalOverride;
    innerRect.origin.y = veritcalOverride == NSNotFound ? ceilf((outerRect.size.height - innerRect.size.height)/2) : veritcalOverride;
    return innerRect;
}

extern CGRect CGCenteredRectInRect(CGRect innerRect, CGRect outerRect) {
    return CGCenteredRectInRectWithOverrides(innerRect, outerRect, NSNotFound, NSNotFound);
}

extern CGRect CGCenteredSizeInRectWithOverrides(CGSize size, CGRect outerRect, NSInteger horizontalOverride, NSInteger veritcalOverride) {
    return CGCenteredRectInRectWithOverrides(CGRectMake(0,0,size.width,size.height), outerRect, horizontalOverride, veritcalOverride);
}

extern CGRect CGCenteredSizeInRect(CGSize size, CGRect outerRect) {
    return CGCenteredRectInRectWithOverrides(CGRectMake(0,0,size.width,size.height), outerRect, NSNotFound, NSNotFound);
}


#pragma mark Resizing
extern CGSize CGSizeToFitWithinSize(CGSize innerSize, CGSize outerSize) {
    CGFloat widthForHeight = rintf(innerSize.width * (outerSize.height / innerSize.height));
    CGFloat heightForWidth = rintf(innerSize.height * (outerSize.width / innerSize.width));
    BOOL isHeightConstrained = (widthForHeight <= outerSize.width);
    
    CGFloat newImageWidth = (isHeightConstrained) ? widthForHeight : outerSize.width;
    CGFloat newImageHeight = (isHeightConstrained) ? outerSize.height : heightForWidth;
    
    return CGSizeMake(newImageWidth, newImageHeight);
}

#pragma mark File System

extern NSString* ApplicationDocumentFilePath();
extern NSString* CacheFilePath();
extern NSString* TemporaryFilePath();


#pragma mark Device Info

extern NSString * SystemVersion() {
    return [[UIDevice currentDevice] systemVersion];
}

extern CGFloat MainDisplayScale() {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        return [[UIScreen mainScreen] scale];
    } else {
        return 1.0;
    }
}

extern BOOL MainDisplayIsHighResolution() {
    return MainDisplayScale() > 1.5;
}

NSString* formatWith3Digits(float value)
{
    if (value < 0) {
        return @"%.3f";
    } else if (value < 10) {
        return @"%.2f";
    } else if (value < 100) {
        return @"%.1f";
    } else {
        return @"%.0f";
    }
}

void addMemoryStat(NSMutableString *result, NSString *label, long value)
{
    if ([result length] != 0) {
        [result appendString:@" "];
    }
    
    [result appendString:label];
    [result appendString:@":"];
    
    NSString *valueSuffix;
    float valueToPrint;
    NSString *valueFormat;
    
    if (value < 1000) {
        valueSuffix = @"b";
        valueToPrint = value;
        valueFormat = @"%.0f";
    } else if (value < 1024*1024) {
        valueSuffix = @"k";
        valueToPrint = ((double)value) / (1024);
        valueFormat = formatWith3Digits(valueToPrint);
    } else if (value < 1024L*1024L*1024L) {
        valueSuffix = @"m";
        valueToPrint = ((double)value) / (1024*1024);
        valueFormat = formatWith3Digits(valueToPrint);
    } else {
        valueSuffix = @"g";
        valueToPrint = ((double)value) / (1024L*1024L*1024L);
        valueFormat = formatWith3Digits(valueToPrint);
    }
    
    [result appendFormat:valueFormat, valueToPrint];
    [result appendString:valueSuffix];
}

extern NSString* MemoryStats() {
    struct task_basic_info taskInfo;
    mach_msg_type_number_t size = sizeof(taskInfo);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&taskInfo, &size);
    if (kerr != KERN_SUCCESS) {
        return @"*** task_info() error ***";
    }
    
    malloc_statistics_t mallocStats;
    malloc_zone_statistics(NULL, &mallocStats);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:50];
    addMemoryStat(result, @"r", taskInfo.resident_size);
    addMemoryStat(result, @"v", taskInfo.virtual_size);
    addMemoryStat(result, @"h", mallocStats.size_in_use);
    addMemoryStat(result, @"xh", mallocStats.max_size_in_use);
    return result;
}





