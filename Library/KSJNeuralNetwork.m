//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import "KSJNeuralNetwork.h"

@interface KSJNeuralNetwork ()

@property (nonatomic, readwrite) NSMutableArray *nnGraphStructure;
@property (nonatomic, readwrite) NSInteger nnDatatype;
@property (nonatomic, readwrite) NSMutableArray *nnModel;
@property (nonatomic, readwrite) KSJNeuralNetworkDevice nnDevice;

@end

@implementation KSJNeuralNetwork

- (BOOL)createFullyConnectedLayerWithConfiguration:(KSJFullyConnectedArchConfiguration *)configuration{return NO;}
- (BOOL)createConvolutionLayerWithConfiguration:(KSJConvolutionArchConfiguration *)configuration{return NO;}
- (BOOL)createPoolingLayerWithConfiguration:(KSJPoolingArchConfiguration *)configuration{return NO;}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.nnGraphStructure = [NSMutableArray new];
        self.nnDatatype = -1;
        self.nnModel = nil;
        self.nnDevice = KSJNeuralNetworkDeviceNONE;
    }
    return self;
}

- (void)addFullyConnectedLayerWithConfiguration:(KSJFullyConnectedArchConfiguration *)configuration
{
    [self.nnGraphStructure addObject:configuration];
}

- (void)addConvolutionLayerWithConfiguration:(KSJFullyConnectedArchConfiguration *)configuration
{
    [self.nnGraphStructure addObject:configuration];
}

- (void)addMaxPoolingLayerWithConfiguration:(KSJFullyConnectedArchConfiguration *)configuration
{
    [self.nnGraphStructure addObject:configuration];
}

- (void)addAveragePoolingLayerWithConfiguration:(KSJFullyConnectedArchConfiguration *)configuration
{
    [self.nnGraphStructure addObject:configuration];
}

- (void)buildGraphWithDataType:(NSInteger)dataType
{
    if (self.nnGraphStructure.count == 0){NSLog(@"no items in graph."); return;}
    if (!self.nnModel){self.nnModel = [NSMutableArray array];}
    else if (self.nnModel){[self destroyGraph];}
    
    self.nnDatatype = dataType;
    [self.nnGraphStructure enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KSJArchConfiguration *configuration = (KSJArchConfiguration *)obj;
        if ([configuration.layerName isEqualToString:@"Linear"])
        {
            [self createFullyConnectedLayerWithConfiguration:obj];
        }
        else if ([configuration.layerName isEqualToString:@"SpatialConvolution"])
        {
            [self createConvolutionLayerWithConfiguration:obj];
        }
        else if ([configuration.layerName isEqualToString:@"SpatialMaxPooling"])
        {
            [self createPoolingLayerWithConfiguration:obj];
        }
        else if ([configuration.layerName isEqualToString:@"SpatialAveragePooling"])
        {
            [self createPoolingLayerWithConfiguration:obj];
        }
    }];
}

- (BOOL)createConvolutionLayerWithDataType:(NSInteger)dataType andStructure:(NSDictionary *)structure
{
    return NO;
}

- (BOOL)createPoolingLayerWithDataType:(NSInteger)dataType poolingType:(NSInteger)poolingType andStructure:(NSDictionary *)structure
{
    return NO;
}

- (BOOL)createFullyConnectedLayerWithDataType:(NSInteger)dataType andStructure:(NSDictionary *)structure
{
    return NO;
}

- (NSString *)graphToString
{
    __block NSMutableString *graphstructurestr = [NSMutableString stringWithFormat:@"\n\n MODEL ARCHITECTURE, ON DEVICE :%i \n\n",self.nnDevice];
    [self.nnGraphStructure enumerateObjectsUsingBlock:^(KSJArchConfiguration *configuration, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([configuration.layerName isEqualToString:@"Linear"])
         {
             KSJFullyConnectedArchConfiguration *fully_conn = (KSJFullyConnectedArchConfiguration *)configuration;
             [graphstructurestr appendString:[NSString stringWithFormat:@"%@ => [%i]\n",fully_conn.layerName,idx+1]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"%@ => [%i]\n",@"Input Size",fully_conn.inputSize]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"%@ => [%i]\n",@"Output Size",fully_conn.outputSize]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"\n"]];
         }
         else if ([configuration.layerName isEqualToString:@"SpatialConvolution"])
         {
             KSJConvolutionArchConfiguration *conv = (KSJConvolutionArchConfiguration *)configuration;
             [graphstructurestr appendString:[NSString stringWithFormat:@"%@ => [%i]\n",conv.layerName,idx+1]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"%@ => [%i x %i]\n",@"Kernel Size",conv.kernelW,conv.kernelH]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"%@ => [%.2f x %.2f]\n",@"Input Size",conv.inputWidth,conv.inputHeight]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"%@ => [%.2f x %.2f]\n",@"Output Size",conv.outputWidth,conv.outputHeight]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"%@ => [%i]\n",@"Input Channels",conv.inputPlane]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"%@ => [%i]\n",@"Output Channels",conv.outputPlane]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"  %@ => [%i]\n",@"Activation Function",conv.activationFunction]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"\n"]];
         }
         else if ([configuration.layerName isEqualToString:@"SpatialAveragePooling"] || [configuration.layerName isEqualToString:@"SpatialMaxPooling"])
         {
             KSJPoolingArchConfiguration *pool = (KSJPoolingArchConfiguration *)configuration;
             [graphstructurestr appendString:[NSString stringWithFormat:@"%@ => [%i]\n",pool.layerName,idx+1]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"%@ => [%i x %i]\n",@"Kernel Size",pool.kernelW,pool.kernelH]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"%@ => [%.2f x %.2f]\n",@"Input Size",pool.inputWidth,pool.inputHeight]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"%@ => [%.2f x %.2f]\n",@"Output Size",pool.outputWidth,pool.outputHeight]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"%@ => [%i]\n",@"Pooling Type",pool.poolType]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"%@ => [%i]\n",@"Input Channels",pool.inputChannels]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"%@ => [%i]\n",@"Output Channels",pool.outputChannels]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"  %@ => [%i]\n",@"Activation Function",pool.activationFunction]];
             [graphstructurestr appendString:[NSString stringWithFormat:@"\n"]];
         }
     }];
    return graphstructurestr;
}

- (void)destroyGraph
{
    if (self.nnDevice == KSJNeuralNetworkDeviceCPU)
    {
        [self.nnModel enumerateObjectsUsingBlock:^(NSValue *filterPointer, NSUInteger idx, BOOL * _Nonnull stop)
         {
             BNNSFilter filter = [filterPointer pointerValue];
             BNNSFilterDestroy(filter);
         }];
    }
    else if (self.nnDevice == KSJNeuralNetworkDeviceGPU)
    {
        //CLEAR GPU
    }
}

- (NSValue *)forward:(NSValue *)data
{
    return nil;
}

- (void)setGeometryForConvolutionAndPoolingLayers:(CGPoint)geometry
{
    __block CGPoint lastGeometry = geometry;
    __block NSInteger lastOutputChannels = 0;
    [self.nnGraphStructure enumerateObjectsUsingBlock:^(KSJArchConfiguration *configuration, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if ([configuration.layerName isEqualToString:@"SpatialConvolution"])
        {
            KSJConvolutionArchConfiguration *conv = (KSJConvolutionArchConfiguration *)configuration;
            CGFloat outputImageWidth = (int)(lastGeometry.x - conv.kernelW + 1);
            CGFloat outputImageHeight = (int)(lastGeometry.y - conv.kernelH + 1);
            conv.inputWidth = lastGeometry.x;
            conv.inputHeight = lastGeometry.y;
            lastGeometry = CGPointMake(outputImageWidth, outputImageHeight);
            conv.outputWidth = outputImageWidth;
            conv.outputHeight = outputImageHeight;
            lastOutputChannels = conv.outputPlane;
        }
        else if ([configuration.layerName isEqualToString:@"SpatialAveragePooling"] || [configuration.layerName isEqualToString:@"SpatialMaxPooling"])
        {
            KSJPoolingArchConfiguration *pool = (KSJPoolingArchConfiguration *)configuration;
            CGFloat outputImageWidth = (int)(lastGeometry.x / pool.kernelW);
            CGFloat outputImageHeight = (int)(lastGeometry.y / pool.kernelH);
            pool.inputWidth = lastGeometry.x;
            pool.inputHeight = lastGeometry.y;
            lastGeometry = CGPointMake(outputImageWidth, outputImageHeight);
            pool.outputWidth = outputImageWidth;
            pool.outputHeight = outputImageHeight;
            pool.inputChannels = lastOutputChannels;
            pool.outputChannels = lastOutputChannels;
        }
    }];
}

@end
