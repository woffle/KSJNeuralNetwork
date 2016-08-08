//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import "KSJNeuralNetworkGPU.h"

@interface KSJNeuralNetworkGPU ()

@property (nonatomic, readwrite) NSMutableArray *nnGraphStructure;
@property (nonatomic, readwrite) BNNSDataType nnDatatype;
@property (nonatomic, readwrite) NSMutableArray *nnModel;
@property (nonatomic, readwrite) KSJNeuralNetworkDevice nnDevice;

@end

@implementation KSJNeuralNetworkGPU

@synthesize nnDevice;
@synthesize nnGraphStructure;
@synthesize nnModel;
@synthesize nnDatatype;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.nnDevice = KSJNeuralNetworkDeviceCPU;
        NSLog(@"GPU NOT YET IMPLEMENTED...");
    }
    return self;
}

- (BOOL)createFullyConnectedLayerWithConfiguration:(KSJFullyConnectedArchConfiguration *)configuration{NSLog(@"GPU NOT YET IMPLEMENTED...");return NO;}
- (BOOL)createConvolutionLayerWithConfiguration:(KSJConvolutionArchConfiguration *)configuration{NSLog(@"GPU NOT YET IMPLEMENTED...");return NO;}
- (BOOL)createPoolingLayerWithConfiguration:(KSJPoolingArchConfiguration *)configuration{NSLog(@"GPU NOT YET IMPLEMENTED...");return NO;}

- (NSValue *)forward:(NSValue *)data
{
    NSLog(@"GPU NOT YET IMPLEMENTED...");
    if (self.nnModel == nil)
    {
        NSLog(@"Build graph first by calling buildGraphUsingAcceleration:andDataType:");
    }
    return nil;
}

@end
