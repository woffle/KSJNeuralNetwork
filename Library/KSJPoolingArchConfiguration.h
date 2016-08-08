//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "KSJArchConfiguration.h"
@interface KSJPoolingArchConfiguration : KSJArchConfiguration <KSJArchProtocol>

@property (nonatomic, readonly) NSInteger kernelW;
@property (nonatomic, readonly) NSInteger kernelH;
@property (nonatomic, readonly) NSInteger strideW;
@property (nonatomic, readonly) NSInteger strideH;
@property (nonatomic, readonly) NSInteger padW;
@property (nonatomic, readonly) NSInteger padH;

@property (nonatomic, readonly) NSValue *weightBuffer;
@property (nonatomic, readonly) NSValue *biasBuffer;

@property (nonatomic, readonly) NSInteger poolType;

@property (nonatomic, readwrite) CGFloat inputWidth;
@property (nonatomic, readwrite) CGFloat outputWidth;
@property (nonatomic, readwrite) CGFloat inputHeight;
@property (nonatomic, readwrite) CGFloat outputHeight;

@property (nonatomic, readwrite) NSInteger inputChannels;
@property (nonatomic, readwrite) NSInteger outputChannels;


- (void)setPoolType:(NSInteger)poolType;
+ (instancetype)archFromStructureBuffer:(int *)s_buffer weightBuffer:(void *)w_buffer biasBuffer:(void *)b_buffer poolType:(NSInteger)poolType dataType:(NSInteger)dataType activation:(NSInteger)activation;
+ (instancetype)archFromStructureBufferWrapped:(int *)s_buffer weightBuffer:(NSValue *)w_buffer biasBuffer:(NSValue *)b_buffer poolType:(NSInteger)poolType dataType:(NSInteger)dataType activation:(NSInteger)activation;

@end
