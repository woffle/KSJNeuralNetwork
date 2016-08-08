//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import "KSJPoolingArchConfiguration.h"

@interface KSJPoolingArchConfiguration ()

@property (nonatomic, readwrite) NSInteger kernelW;
@property (nonatomic, readwrite) NSInteger kernelH;
@property (nonatomic, readwrite) NSInteger strideW;
@property (nonatomic, readwrite) NSInteger strideH;
@property (nonatomic, readwrite) NSInteger padW;
@property (nonatomic, readwrite) NSInteger padH;

@property (nonatomic, readwrite) NSValue *biasBuffer;

@property (nonatomic, readwrite) NSInteger poolType;

@property (nonatomic, readwrite) NSString *layerName;
@property (nonatomic, readwrite) NSInteger dataType;
@property (nonatomic, readwrite) NSInteger activationFunction;
@end

@implementation KSJPoolingArchConfiguration

@synthesize layerName;
@synthesize dataType;
@synthesize activationFunction;

+ (instancetype)archFromStructureBuffer:(int *)s_buffer weightBuffer:(void *)w_buffer biasBuffer:(void *)b_buffer dataType:(NSInteger)dataType activation:(NSInteger)activation
{
    KSJPoolingArchConfiguration *arch = [[KSJPoolingArchConfiguration alloc] init];
    arch.layerName = @"SpatialMaxPooling";
    arch.kernelW = s_buffer[0];
    arch.kernelH = s_buffer[1];
    arch.strideW = s_buffer[2];
    arch.strideH = s_buffer[3];
    arch.padW = s_buffer[4];
    arch.padH = s_buffer[5];
    arch.biasBuffer = [NSValue valueWithPointer:b_buffer];
    arch.dataType = dataType;
    arch.activationFunction = activation;
    return arch;
}

+ (instancetype)archFromStructureBufferWrapped:(int *)s_buffer weightBuffer:(NSValue *)w_buffer biasBuffer:(NSValue *)b_buffer dataType:(NSInteger)dataType activation:(NSInteger)activation
{
    KSJPoolingArchConfiguration *arch = [[KSJPoolingArchConfiguration alloc] init];
    arch.layerName = @"SpatialMaxPooling";
    arch.kernelW = s_buffer[0];
    arch.kernelH = s_buffer[1];
    arch.strideW = s_buffer[2];
    arch.strideH = s_buffer[3];
    arch.padW = s_buffer[4];
    arch.padH = s_buffer[5];
    arch.biasBuffer = b_buffer;
    arch.dataType = dataType;
    arch.activationFunction = activation;
    return arch;
}

- (void)setPoolType:(NSInteger)poolType
{
    _poolType = poolType;
}

+ (instancetype)archFromStructureBufferWrapped:(int *)s_buffer weightBuffer:(NSValue *)w_buffer biasBuffer:(NSValue *)b_buffer poolType:(NSInteger)poolType dataType:(NSInteger)dataType activation:(NSInteger)activation
{
    KSJPoolingArchConfiguration *arch = [self archFromStructureBufferWrapped:s_buffer weightBuffer:w_buffer biasBuffer:b_buffer dataType:dataType activation:activation];
    [arch setPoolType:poolType];
    return arch;
}

+ (instancetype)archFromStructureBuffer:(int *)s_buffer weightBuffer:(void *)w_buffer biasBuffer:(void *)b_buffer poolType:(NSInteger)poolType dataType:(NSInteger)dataType activation:(NSInteger)activation
{
    KSJPoolingArchConfiguration *arch = [self archFromStructureBuffer:s_buffer weightBuffer:w_buffer biasBuffer:b_buffer dataType:dataType activation:activation];
    [arch setPoolType:poolType];
    if (poolType == BNNSPoolingFunctionMax){arch.layerName = @"SpatialMaxPooling";}
    else if (poolType == BNNSPoolingFunctionAverage){arch.layerName = @"SpatialAveragePooling";}
    return arch;
}

@end
