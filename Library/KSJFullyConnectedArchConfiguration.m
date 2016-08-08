//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import "KSJFullyConnectedArchConfiguration.h"

@interface KSJFullyConnectedArchConfiguration ()

@property (nonatomic, readwrite) NSInteger inputSize;
@property (nonatomic, readwrite) NSInteger outputSize;

@property (nonatomic, readwrite) NSValue *weightBuffer;
@property (nonatomic, readwrite) NSValue *biasBuffer;

@property (nonatomic, readwrite) NSString *layerName;
@property (nonatomic, readwrite) NSInteger dataType;
@property (nonatomic, readwrite) NSInteger activationFunction;

@end

@implementation KSJFullyConnectedArchConfiguration

@synthesize layerName;
@synthesize dataType;
@synthesize activationFunction;

+ (instancetype)archFromStructureBuffer:(int *)s_buffer weightBuffer:(void *)w_buffer biasBuffer:(void *)b_buffer dataType:(NSInteger)dataType activation:(NSInteger)activation
{
    KSJFullyConnectedArchConfiguration *arch = [[KSJFullyConnectedArchConfiguration alloc] init];
    arch.layerName = @"Linear";
    arch.inputSize = s_buffer[0];
    arch.outputSize = s_buffer[1];
    arch.weightBuffer = [NSValue valueWithPointer:w_buffer];
    arch.biasBuffer = [NSValue valueWithPointer:b_buffer];
    arch.dataType = dataType;
    arch.activationFunction = activation;
    return arch;
}

+ (instancetype)archFromStructureBufferWrapped:(int *)s_buffer weightBuffer:(NSValue *)w_buffer biasBuffer:(NSValue *)b_buffer dataType:(NSInteger)dataType activation:(NSInteger)activation
{
    KSJFullyConnectedArchConfiguration *arch = [[KSJFullyConnectedArchConfiguration alloc] init];
    arch.layerName = @"Linear";
    arch.inputSize = s_buffer[0];
    arch.outputSize = s_buffer[1];
    arch.weightBuffer = w_buffer;
    arch.biasBuffer = b_buffer;
    arch.dataType = dataType;
    arch.activationFunction = activation;
    return arch;
}

@end
