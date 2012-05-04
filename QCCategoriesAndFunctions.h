//
//  QCCategoriesAndFunctions.h
//  QCCategoriesAndFunctions
//
//  Created by Q Cook on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - Constants

#pragma mark Font Names
extern NSString *kArialRoundedBold;
extern NSString *kTrebuchet;
extern NSString *kTrebuchetBold;
extern NSString *kHelveticaNeue;
extern NSString *kHelveticaNeueBold;
extern NSString *kHelveticaBoldOblique;
extern NSString *kHeitiSCMedium;
extern NSString *kVerdana;
extern NSString *kGeorgia;
extern NSString *kGeorgiaItalic;
extern NSString *kPalatino;
extern NSString *kFuturaMedium;

#pragma mark - UIView 
@interface UIView (QCCategory) 

- (void) centerInView:(UIView*)largeView withHorizontal:(NSInteger)horzontalOverride andVerticalOverrides:(NSInteger)verticalOverrides;
- (CGPoint) centeredOriginPointInRect:(CGRect)rect;
- (void) setOrigin:(CGPoint)origin;
- (UIView*) subviewOfType:(Class)clazz;

@property (nonatomic, strong) id userInfo;

@end


#pragma mark - UIColor
@interface UIColor (QCCategory)

+ (UIColor *) colorWithIntegerRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (NSString *) htmlColorWithIntegerRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
- (NSString *) htmlColor;

@end


#pragma mark - UIButton
@interface UIButton (QCCategory)

- (void) setHighlightedAndSelectedTitleColor:(UIColor *)color;
- (void) setHighlightedAndSelectedTitleShadowColor:(UIColor *)color;
- (void) setHighlightedAndSelectedImage:(UIImage *)image;
- (void) setHighlightedAndSelectedBackgroundImage:(UIImage *)image;

@end


#pragma mark - UIImage
@interface UIImage(QCCategory)

- (CGSize) sizeToFitWithinSize:(CGSize)frameSize;

@end

#pragma mark - UIImageView
@interface UIImageView(QCCategory)

- (void) crossFadeToImage:(UIImage *)image;
+ (UIImageView *) imageViewWithImageNamed:(NSString *)name;

@end



#pragma mark - NSDictionary
@interface NSDictionary (QCCategory) 

- (NSString*) stringForKey:(id)key;  // Will convert NSNumber to NSString
- (NSInteger) integerForKey:(id)key; // Will convert NSString to NSInteger
- (NSString*) stringForKey:(id)key convertNSNumber:(BOOL)convert;
- (NSInteger) integerForKey:(id)key convertNSString:(BOOL)convert;
- (NSDictionary*) dictionaryForKey:(id)key;
- (NSArray*) arrayForKey:(id)key;

@end


#pragma mark - NSArray
@interface NSArray(QCCategory)

- (id)nestedObjectAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)countOfNestedArray:(NSUInteger)section;
- (NSIndexPath*) indexPathAfterIndexPath:(NSIndexPath*)previousIndexPath;
- (NSIndexPath*) indexPathOfObjectInNestedArray:(id)object;

@end


#pragma mark - UILabel
@interface UILabel (QCCategory) 

+ (UILabel*) labelWithText:(NSString*)text font:(UIFont*)font color:(UIColor*)color backgroundColor:(UIColor*)bkgColor;

@end


#pragma mark - Functions

extern void ReleaseAndNil(NSObject *object);

#pragma mark CGRect Centering
extern CGRect CGCenteredRectInRectWithOverrides(CGRect innerRect, CGRect outerRect, NSInteger horizontalOverride, NSInteger veritcalOverride);
extern CGRect CGCenteredRectInRect(CGRect innerRect, CGRect outerRect); // Centers both horizontally and vertically
extern CGRect CGCenteredSizeInRectWithOverrides(CGSize size, CGRect outerRect, NSInteger horizontalOverride, NSInteger veritcalOverride);
extern CGRect CGCenteredSizeInRect(CGSize size, CGRect outerRect);

#pragma mark Resizing
extern CGSize CGSizeToFitWithinSize(CGSize innerSize, CGSize outerSize);

#pragma mark File System
extern NSString* ApplicationDocumentFilePath();
extern NSString* CacheFilePath();
extern NSString* TemporaryFilePath();

#pragma mark Device Info
extern NSString* SystemVersion();
extern CGFloat MainDisplayScale();
extern BOOL MainDisplayIsHighResolution();
extern NSString* MemoryStats();





