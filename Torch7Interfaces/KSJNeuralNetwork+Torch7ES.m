//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import "KSJNeuralNetwork+Torch7ES.h"
#import "THESLayer.h"
#import "THESDiskFile.h"
#import "KSJPoolingArchConfiguration.h"
#import "KSJFullyConnectedArchConfiguration.h"
#import "KSJConvolutionArchConfiguration.h"

#define THES_LINEAR_LAYER_TYPE_INDEX 1
#define THES_SP_CONV_LAYER_TYPE_INDEX 2
#define THES_SP_MPOOL_LAYER_TYPE_INDEX 3
#define THES_SP_APOOL_LAYER_TYPE_INDEX 4

NSString *const kNeuralNetworkKey = @"KSJNeuralNetworkKey";
NSString *const kNeuralNetworkLayersKey = @"KSJNeuralNetworkLayersKey";
NSString *const kNeuralNetworkLayersDataType = @"KSJNeuralNetworkDataType";

@implementation KSJNeuralNetwork (Torch7ES)

+ (BNNSActivationFunction)activationFunctionForTorchIndex:(NSUInteger)index
{
    //Tanh
    if (index < 5)
    {
        return BNNSActivationFunctionIdentity;
    }
    else if (index == 5)
    {
        return BNNSActivationFunctionTanh;
    }
    //HardTanh
    else if (index == 6)
    {
        return BNNSActivationFunctionScaledTanh;
    }
    //Log Sigmoid
    else if (index == 7)
    {
        return BNNSActivationFunctionIdentity;
    }
    //LogSoftMax
    else if (index == 8)
    {
        return BNNSActivationFunctionIdentity;
    }
    //Sigmoid
    else if (index == 9)
    {
        return BNNSActivationFunctionSigmoid;
    }
    //ReLU
    else if (index == 10)
    {
        return BNNSActivationFunctionRectifiedLinear;
    }
    return BNNSActivationFunctionIdentity;
}

+ (BNNSDataType)dataTypeForTorchIndex:(NSUInteger)index
{
    if (index == 1)
    {
        return BNNSDataTypeFloat32;
    }
    else if (index == 2)
    {
        return BNNSDataTypeFloat32;
    }
    else if (index == 3)
    {
        return BNNSDataTypeInt32;
    }
    return BNNSDataTypeFloat32;
}

+ (NSDictionary *)NeuralNetworkWithTorchESFilePath:(NSString *)path on:(KSJNeuralNetworkDevice)device
{
    KSJNeuralNetwork *neuralNetwork;
    if (device == KSJNeuralNetworkDeviceCPU)
    {
        neuralNetwork = [[KSJNeuralNetworkCPU alloc] init];
    }
    else if (device == KSJNeuralNetworkDeviceGPU)
    {
        neuralNetwork = [[KSJNeuralNetworkGPU alloc] init];
    }
    
    NSArray *layers = [THESDiskFile readLayersBinary:path];
    
    for (int i = 0; i < layers.count; i++)
    {
        THESLayer *layer = layers[i];
        //Linear
        if ([layer.layerType integerValue] == THES_LINEAR_LAYER_TYPE_INDEX)
        {
            BNNSActivationFunction f = BNNSActivationFunctionIdentity;
            if (i + 1 < layers.count)
            {
                f = [self activationFunctionForTorchIndex:[((THESLayer *)layers[i+1]).layerType integerValue]];
            }
            int *net_structure = (int*)[[layer structureBuffer] pointerValue];
            KSJFullyConnectedArchConfiguration *full_conn_arch = [KSJFullyConnectedArchConfiguration archFromStructureBufferWrapped:net_structure weightBuffer:layer.weightsBuffer biasBuffer:layer.biasBuffer dataType:BNNSDataTypeFloat32 activation:f];
            [neuralNetwork addFullyConnectedLayerWithConfiguration:full_conn_arch];
        }
        //Conv
        else if ([layer.layerType integerValue] == THES_SP_CONV_LAYER_TYPE_INDEX)
        {
            BNNSActivationFunction f = BNNSActivationFunctionIdentity;
            if (i + 1 < layers.count)
            {
                f = [self activationFunctionForTorchIndex:[((THESLayer *)layers[i+1]).layerType integerValue]];
            }
            int *net_structure = (int*)[[layer structureBuffer] pointerValue];
            KSJConvolutionArchConfiguration *conv_arch = [KSJConvolutionArchConfiguration archFromStructureBufferWrapped:net_structure weightBuffer:layer.weightsBuffer biasBuffer:layer.biasBuffer dataType:BNNSDataTypeFloat32 activation:f];
            [neuralNetwork addConvolutionLayerWithConfiguration:conv_arch];
        }
        
        //Pooling
        else if ([layer.layerType integerValue] == THES_SP_MPOOL_LAYER_TYPE_INDEX || [layer.layerType integerValue] == THES_SP_APOOL_LAYER_TYPE_INDEX)
        {
            int *net_structure = (int*)[[layer structureBuffer] pointerValue];
            BNNSActivationFunction f = BNNSActivationFunctionIdentity;
            if (i + 1 < layers.count)
            {
                f = [self activationFunctionForTorchIndex:[((THESLayer *)layers[i+1]).layerType integerValue]];
            }
            
            //Max Pooling
            if ([layer.layerType integerValue] == THES_SP_MPOOL_LAYER_TYPE_INDEX)
            {
                KSJPoolingArchConfiguration *pool_arch = [KSJPoolingArchConfiguration archFromStructureBufferWrapped:net_structure weightBuffer:NULL biasBuffer:layer.biasBuffer poolType:BNNSPoolingFunctionMax dataType:BNNSDataTypeFloat32 activation:f];
                [neuralNetwork addMaxPoolingLayerWithConfiguration:pool_arch];
            }
            //Average Pooling
            else if ([layer.layerType integerValue] == THES_SP_APOOL_LAYER_TYPE_INDEX)
            {
                KSJPoolingArchConfiguration *pool_arch = [KSJPoolingArchConfiguration archFromStructureBufferWrapped:net_structure weightBuffer:layer.weightsBuffer biasBuffer:layer.biasBuffer poolType:BNNSPoolingFunctionAverage dataType:BNNSDataTypeFloat32 activation:f];
                [neuralNetwork addAveragePoolingLayerWithConfiguration:pool_arch];
            }
        }
    }
    
    BNNSDataType dataType;
    if (layers.count > 0)
    {
        dataType = [self dataTypeForTorchIndex:[((THESLayer *)layers[0]).layerType integerValue]];
    }
    
    return @{kNeuralNetworkKey:neuralNetwork,kNeuralNetworkLayersKey:layers,kNeuralNetworkLayersDataType:@(dataType)};
}

@end
