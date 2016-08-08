//
//
//  Created by Kurt Jacobs
//  Copyright © 2016 RandomDudes. All rights reserved.
//
//

#import "KSJNeuralNetwork.h"
#import "KSJNeuralNetworkCPU.h"
#import "KSJNeuralNetworkGPU.h"

extern NSString *const kNeuralNetworkKey;
extern NSString *const kNeuralNetworkLayersKey;
extern NSString *const kNeuralNetworkLayersDataType;

@interface KSJNeuralNetwork (Torch7ES)

/*! @brief Creates a KSJNeuralNetwork based on a specified .t7ios file.
 *  @param path Path to the .t7ios binary file.
 *  @param device The device that you would like to create the Neural Network instance on.
 */
+ (NSDictionary *)NeuralNetworkWithTorchESFilePath:(NSString *)path on:(KSJNeuralNetworkDevice)device;

@end
