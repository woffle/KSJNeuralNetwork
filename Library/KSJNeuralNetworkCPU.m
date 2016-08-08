//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import "KSJNeuralNetworkCPU.h"

@interface KSJNeuralNetworkCPU ()

@property (nonatomic, readwrite) NSMutableArray *nnGraphStructure;
@property (nonatomic, readwrite) NSInteger nnDatatype;
@property (nonatomic, readwrite) NSMutableArray *nnModel;
@property (nonatomic, readwrite) KSJNeuralNetworkDevice nnDevice;

@end

@implementation KSJNeuralNetworkCPU

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
    }
    return self;
}

- (BOOL)createConvolutionLayerWithConfiguration:(KSJConvolutionArchConfiguration *)configuration
{
    BNNSImageStackDescriptor i_desc =
    {
        .width = configuration.inputWidth,
        .height = configuration.inputHeight,
        .channels = configuration.inputPlane,
        //Row Stride = (width + padding)
        .row_stride = configuration.inputWidth + configuration.padW,
        //image stride = (width + paddingW) * (height + paddingH)
        .image_stride = (configuration.inputWidth + configuration.padW) * (configuration.inputHeight + configuration.padH),
        .data_type = (BNNSDataType)configuration.dataType,
    };
    
    BNNSImageStackDescriptor o_desc =
    {
        .width = configuration.outputWidth,
        .height = configuration.outputHeight,
        .channels = configuration.outputPlane,
        //Row Stride = (width + padding)
        .row_stride = configuration.outputWidth + configuration.padW,
        //image stride = (width + paddingW) * (height + paddingH)
        .image_stride = (configuration.outputWidth + configuration.padW) * (configuration.outputHeight + configuration.padH),
        .data_type = (BNNSDataType)configuration.dataType,
    };
    
    BNNSConvolutionLayerParameters layer_params =
    {
        .k_width = configuration.kernelW,
        .k_height = configuration.kernelH,
        .in_channels = i_desc.channels,
        .out_channels = o_desc.channels,
        .x_stride = configuration.strideW,
        .y_stride = configuration.strideH,
        .x_padding = configuration.padW,
        .y_padding = configuration.padW,
        .activation = configuration.activationFunction,
    };
    
    layer_params.weights.data = configuration.weightBuffer.pointerValue;
    layer_params.bias.data = configuration.biasBuffer.pointerValue;
    layer_params.weights.data_type = configuration.dataType;
    layer_params.bias.data_type = configuration.dataType;
    
    BNNSFilterParameters filter_params =
    {
        
    };
    
    BNNSFilter filter = BNNSFilterCreateConvolutionLayer(&i_desc,&o_desc,&layer_params,&filter_params);
    if (filter == NULL) { fprintf(stderr,"BNNSFilterCreateConvolutionLayer failed\n"); return NO;}
    [self.nnModel addObject:[NSValue valueWithPointer:filter]];
    return YES;
}

- (BOOL)createPoolingLayerWithConfiguration:(KSJPoolingArchConfiguration *)configuration
{
    BNNSImageStackDescriptor i_desc =
    {
        .width = configuration.inputWidth,
        .height = configuration.inputHeight,
        .channels = configuration.inputChannels,
        .row_stride = configuration.inputWidth + configuration.padW,
        .image_stride = (configuration.inputWidth + configuration.padW) * (configuration.inputHeight + configuration.padH),
        .data_type = (BNNSDataType)configuration.dataType,
    };
    
    BNNSImageStackDescriptor o_desc =
    {
        .width = configuration.outputWidth,
        .height = configuration.outputHeight,
        .channels = configuration.outputChannels,
        .row_stride = configuration.outputWidth + configuration.padW,
        .image_stride = (configuration.outputWidth + configuration.padW) * (configuration.outputHeight + configuration.padH),
        .data_type = (BNNSDataType)configuration.dataType,
    };
    
    BNNSPoolingLayerParameters params =
    {
        .x_stride = configuration.strideW,
        .y_stride = configuration.strideH,
        .x_padding = configuration.padW,
        .y_padding = configuration.padH,
        .k_width = configuration.kernelW,
        .k_height = configuration.kernelH,
        .in_channels = i_desc.channels,
        .out_channels = o_desc.channels,
        
        .pooling_function = (BNNSPoolingFunction)configuration.poolType,
        .bias = configuration.biasBuffer.pointerValue,
        .activation = configuration.activationFunction,
    };
    
    BNNSFilterParameters filter_params =
    {
        
    };
    
    BNNSFilter filter = BNNSFilterCreatePoolingLayer(&i_desc, &o_desc, &params, &filter_params);
    if (filter == NULL) { fprintf(stderr,"BNNSFilterCreatePoolingLayer failed\n"); return NO;}
    [self.nnModel addObject:[NSValue valueWithPointer:filter]];
    return YES;
}

- (BOOL)createFullyConnectedLayerWithConfiguration:(KSJFullyConnectedArchConfiguration *)configuration
{
    BNNSVectorDescriptor i_desc =
    {
        .size = configuration.inputSize,
        .data_type = (BNNSDataType)configuration.dataType,
        .data_scale = 0,
        .data_bias = 0,
    };
    
    BNNSVectorDescriptor h_desc =
    {
        .size = configuration.outputSize,
        .data_type = (BNNSDataType)configuration.dataType,
        .data_scale = 0,
        .data_bias = 0,
    };
    
    BNNSActivation activation =
    {
        .function = configuration.activationFunction,
        .alpha = 0,
        .beta = 0,
    };
    
    BNNSFullyConnectedLayerParameters in_layer_params =
    {
        .in_size = i_desc.size,
        .out_size = h_desc.size,
        .activation = activation,
        .weights.data = configuration.weightBuffer.pointerValue,
        .weights.data_type = (BNNSDataType)configuration.dataType,
        .bias.data_type = (BNNSDataType)configuration.dataType,
        .bias.data = configuration.biasBuffer.pointerValue,
    };
    
    BNNSFilterParameters filter_params =
    {
        
    };
    
    BNNSFilter ih_filter = BNNSFilterCreateFullyConnectedLayer(&i_desc, &h_desc, &in_layer_params, &filter_params);
    if (ih_filter == NULL) { fprintf(stderr,"BNNSCreateFailedFullyConnected failed\n"); return NO; }
    [self.nnModel addObject:[NSValue valueWithPointer:ih_filter]];
    return YES;
}

- (NSValue *)forward:(NSValue *)data
{
    if (self.nnModel == nil)
    {NSLog(@"Build graph first by calling buildGraphUsingAcceleration:andDataType:");return nil;}
    
    float *input_buffer = (float *)[data pointerValue];
    float *output_buffer = NULL;
    for (int net_iterator = 0; net_iterator < self.nnModel.count; net_iterator++)
    {
        KSJArchConfiguration *configuration = self.nnGraphStructure[net_iterator];
        if ([configuration.layerName isEqualToString:@"Linear"])
        {
            KSJFullyConnectedArchConfiguration *fc_configuration = (KSJFullyConnectedArchConfiguration *)configuration;
            output_buffer = (float *)calloc(fc_configuration.outputSize, sizeof(float));
        }
        else if ([configuration.layerName isEqualToString:@"SpatialConvolution"])
        {
            KSJConvolutionArchConfiguration *conv_configuration = (KSJConvolutionArchConfiguration *)configuration;
            CGFloat image_stride = (conv_configuration.outputWidth + conv_configuration.padW) * (conv_configuration.outputHeight + conv_configuration.padH);
            output_buffer = (float *)calloc(image_stride*conv_configuration.outputPlane, sizeof(float));
        }
        else if ([configuration.layerName isEqualToString:@"SpatialMaxPooling"] || [configuration.layerName isEqualToString:@"SpatialAveragePooling"] )
        {
            KSJPoolingArchConfiguration *pool_configuration = (KSJPoolingArchConfiguration *)configuration;
            CGFloat image_stride = (pool_configuration.outputWidth + pool_configuration.padW) * (pool_configuration.outputHeight + pool_configuration.padH);
            output_buffer = (float *)calloc(image_stride*pool_configuration.outputChannels, sizeof(float));
        }
        
        BNNSFilter *f = [self.nnModel[net_iterator] pointerValue];
        int status = BNNSFilterApply(f, input_buffer, output_buffer);
        if (status != 0) fprintf(stderr,"BNNSFilterApply failed\n");
        input_buffer = output_buffer;
    }
    return [NSValue valueWithPointer:input_buffer];
}

@end
