//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "KSJArchConfiguration.h"
@interface KSJConvolutionArchConfiguration : KSJArchConfiguration <KSJArchProtocol>

@property (nonatomic, readonly) NSInteger inputPlane;
@property (nonatomic, readonly) NSInteger outputPlane;
@property (nonatomic, readonly) NSInteger kernelW;
@property (nonatomic, readonly) NSInteger kernelH;
@property (nonatomic, readonly) NSInteger strideW;
@property (nonatomic, readonly) NSInteger strideH;
@property (nonatomic, readonly) NSInteger padW;
@property (nonatomic, readonly) NSInteger padH;

@property (nonatomic, readonly) NSValue *weightBuffer;
@property (nonatomic, readonly) NSValue *biasBuffer;

@property (nonatomic, readwrite) CGFloat inputWidth;
@property (nonatomic, readwrite) CGFloat outputWidth;
@property (nonatomic, readwrite) CGFloat inputHeight;
@property (nonatomic, readwrite) CGFloat outputHeight;

@end
