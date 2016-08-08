//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import "ViewController.h"
#import "KSJNeuralNetworkCPU.H"
#import "KSJNeuralNetwork+Torch7ES.h"
#import "THESBufferLoader.h"
#import "THESSampleBuffer.h"
#import "KSJBNNSExtras.h"

#define MNIST_CLASSES_COUNT 10

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Feed Forward Network
    
    NSLog(@"============================================================================================\n=====================XXX=XXX===XXXXXXX===XXXXXX=============================================\n======================XX=XX====X=====X===X====X=============================================\n=======================XXX=====X=====X===XXXXXX=============================================\n======================XX=XX====X=====X===X==X===============================================\n=====================XX===XX===XXXXXXX===X===XX=============================================\n============================================================================================\n============================================================================================");
    
    NSDictionary *xor_network_components = [KSJNeuralNetwork NeuralNetworkWithTorchESFilePath:[[NSBundle mainBundle] pathForResource:@"ios_xor" ofType:@"t7ios"] on:KSJNeuralNetworkDeviceCPU];
    KSJNeuralNetwork *xor_net = xor_network_components[kNeuralNetworkKey];
    BNNSDataType xor_datatype = [xor_network_components[kNeuralNetworkLayersDataType] integerValue];
    [xor_net buildGraphWithDataType:xor_datatype];
    
    float f [] = {1.0f,1.0f};
    float f2 [] = {-1.0f,1.0f};
    NSValue *xor_input = [NSValue valueWithPointer:f];
    NSValue *xor_input_2 = [NSValue valueWithPointer:f2];
    NSValue *xor_result = [xor_net forward:xor_input];
    NSValue *xor_result_2 = [xor_net forward:xor_input_2];
    NSLog(@"result: %f",((float *)[xor_result pointerValue])[0]);
    NSLog(@"result_2: %f",((float *)[xor_result_2 pointerValue])[0]);
    NSLog(@"%@",[xor_net graphToString]);
    
    free([xor_result pointerValue]);
    free([xor_result_2 pointerValue]);
    [xor_net destroyGraph];
    
    //Convolutional Network
    
    NSLog(@"============================================================================================\n======================XXXXXXXX====XX====X====XX====X========================================\n======================X===========X=X===X====X=X===X========================================\n======================X===========X==X==X====X==X==X========================================\n======================X===========X===X=X====X===X=X========================================\n======================X===========X====XX====X====XX========================================\n======================XXXXXXXX====X=====X====X=====X========================================\n============================================================================================");
    
    NSDictionary *network_components = [KSJNeuralNetwork NeuralNetworkWithTorchESFilePath:[[NSBundle mainBundle] pathForResource:@"mnist_ios" ofType:@"t7ios"] on:KSJNeuralNetworkDeviceCPU];
    KSJNeuralNetwork *neuralNet = network_components[kNeuralNetworkKey];
    BNNSDataType datatype = [network_components[kNeuralNetworkLayersDataType] integerValue];
    
    [neuralNet setGeometryForConvolutionAndPoolingLayers:CGPointMake(32, 32)];
    NSLog(@"%@",[neuralNet graphToString]);
    [neuralNet buildGraphWithDataType:datatype];
    
    NSArray *buffers = [THESBufferLoader readSamplesBuffer:[[NSBundle mainBundle] pathForResource:@"mnist_samples" ofType:@"t7iosb"]];
    for (int iter = 0; iter < 5; iter++)
    {
        THESSampleBuffer *sample = (THESSampleBuffer *)buffers[iter];
        NSLog(@"Target: %i",sample.label);
        NSValue *res = [neuralNet forward:sample.buffer];
            
        NSValue *softmax = [NSValue valueWithPointer:[KSJBNNSExtras softmax:[res pointerValue] vector_len:MNIST_CLASSES_COUNT]];
        NSInteger max_index = [KSJBNNSExtras max_value_in_vector:[softmax pointerValue] vector_len:10];
        NSLog(@"Prediction: %i",max_index);
        
        free([softmax pointerValue]);
        free([res pointerValue]);
    }
    
    [buffers enumerateObjectsUsingBlock:^(THESSampleBuffer *samplebuffer, NSUInteger idx, BOOL * _Nonnull stop)
    {
        free([samplebuffer.buffer pointerValue]);
    }];
    [neuralNet destroyGraph];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
