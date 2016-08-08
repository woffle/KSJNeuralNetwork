//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import "KSJConvolutionArchConfiguration.h"

@interface KSJConvolutionArchConfiguration ()

@property (nonatomic, readwrite) NSInteger inputPlane;
@property (nonatomic, readwrite) NSInteger outputPlane;
@property (nonatomic, readwrite) NSInteger kernelW;
@property (nonatomic, readwrite) NSInteger kernelH;
@property (nonatomic, readwrite) NSInteger strideW;
@property (nonatomic, readwrite) NSInteger strideH;
@property (nonatomic, readwrite) NSInteger padW;
@property (nonatomic, readwrite) NSInteger padH;

@property (nonatomic, readwrite) NSValue *weightBuffer;
@property (nonatomic, readwrite) NSValue *biasBuffer;

@property (nonatomic, readwrite) NSString *layerName;
@property (nonatomic, readwrite) NSInteger dataType;
@property (nonatomic, readwrite) NSInteger activationFunction;

@end

@implementation KSJConvolutionArchConfiguration

@synthesize layerName;
@synthesize dataType;
@synthesize activationFunction;

+ (instancetype)archFromStructureBuffer:(int *)s_buffer weightBuffer:(void *)w_buffer biasBuffer:(void *)b_buffer dataType:(NSInteger)dataType activation:(NSInteger)activation
{
    KSJConvolutionArchConfiguration *arch = [[KSJConvolutionArchConfiguration alloc] init];
    arch.layerName = @"SpatialConvolution";
    arch.inputPlane = s_buffer[0];
    arch.outputPlane = s_buffer[1];
    arch.kernelW = s_buffer[2];
    arch.kernelH = s_buffer[3];
    arch.strideW = s_buffer[4];
    arch.strideH = s_buffer[5];
    arch.padW = s_buffer[6];
    arch.padH = s_buffer[7];
    arch.weightBuffer = [NSValue valueWithPointer:w_buffer];
    arch.biasBuffer = [NSValue valueWithPointer:b_buffer];
    arch.dataType = dataType;
    arch.activationFunction = activation;
    arch.inputWidth = 0.0f;
    arch.outputWidth = 0.0f;
    arch.inputHeight = 0.0f;
    arch.outputHeight = 0.0f;
    return arch;
}

+ (instancetype)archFromStructureBufferWrapped:(int *)s_buffer weightBuffer:(NSValue *)w_buffer biasBuffer:(NSValue *)b_buffer dataType:(NSInteger)dataType activation:(NSInteger)activation
{
    KSJConvolutionArchConfiguration *arch = [[KSJConvolutionArchConfiguration alloc] init];
    arch.layerName = @"SpatialConvolution";
    arch.inputPlane = s_buffer[0];
    arch.outputPlane = s_buffer[1];
    arch.kernelW = s_buffer[2];
    arch.kernelH = s_buffer[3];
    arch.strideW = s_buffer[4];
    arch.strideH = s_buffer[5];
    arch.padW = s_buffer[6];
    arch.padH = s_buffer[7];
    arch.weightBuffer = w_buffer;
    arch.biasBuffer = b_buffer;
    arch.dataType = dataType;
    arch.activationFunction = activation;
    arch.inputWidth = 0.0f;
    arch.outputWidth = 0.0f;
    arch.inputHeight = 0.0f;
    arch.outputHeight = 0.0f;
    return arch;
}

@end
